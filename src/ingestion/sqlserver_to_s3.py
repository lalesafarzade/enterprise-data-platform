
import io
import json
import logging
import os
from datetime import datetime, timezone
import uuid
import boto3
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine



# Configuration


load_dotenv()

SQLSERVER_HOST = os.getenv("SQLSERVER_HOST", "localhost")
SQLSERVER_PORT = os.getenv("SQLSERVER_PORT", "1433")
SQLSERVER_USER = os.getenv("SQLSERVER_USER")
SQLSERVER_PASSWORD = os.getenv("SQLSERVER_PASSWORD")

AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
S3_BUCKET = os.getenv("S3_BUCKET")

CONFIG_FILE = "config/ingestion_config.json"


# Logging


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logger = logging.getLogger(__name__)


# SQL Server Connection


def get_sqlserver_engine(database):
    """
    Create a SQLAlchemy engine for a SQL Server database.
    """

    connection_string = (
        f"mssql+pyodbc://{SQLSERVER_USER}:{SQLSERVER_PASSWORD}"
        f"@{SQLSERVER_HOST}:{SQLSERVER_PORT}/{database}"
        "?driver=ODBC+Driver+18+for+SQL+Server"
        "&TrustServerCertificate=yes"
    )

    return create_engine(
        connection_string,
        pool_pre_ping=True
    )



# Extract


def extract_table(database, table):
    """
    Extract a complete table from SQL Server into a pandas DataFrame.
    """

    logger.info(
        "Starting extraction: %s.%s",
        database,
        table
    )

    engine = get_sqlserver_engine(database)

    query = f"SELECT * FROM [{table}]"

    try:
        dataframe = pd.read_sql(
            query,
            engine
        )

        logger.info(
            "Extraction successful: %s.%s | rows=%d | columns=%d",
            database,
            table,
            len(dataframe),
            len(dataframe.columns)
        )

        return dataframe

    finally:
        engine.dispose()



# Data Quality Validation


def validate_dataframe(dataframe, system, table):
  

    logger.info(
        "Validating: %s.%s",
        system,
        table
    )

    # Check for zero rows
    if dataframe.empty:
        raise ValueError(
            f"{system}.{table} contains zero rows"
        )

    # Check for columns
    if dataframe.columns.empty:
        raise ValueError(
            f"{system}.{table} contains no columns"
        )

    # Check for duplicate column names
    if dataframe.columns.duplicated().any():
        raise ValueError(
            f"{system}.{table} contains duplicate column names"
        )

    logger.info(
        "Validation passed: %s.%s | rows=%d | columns=%d",
        system,
        table,
        len(dataframe),
        len(dataframe.columns)
    )



# S3 Upload


def upload_to_s3(dataframe, system, table):
    """
    Convert the DataFrame to CSV and upload it to S3.

    S3 structure:

    system/
        table/
            ingestion_date=YYYY-MM-DD/
                table.csv
    """

    ingestion_date = datetime.now(
        timezone.utc
    ).strftime("%Y-%m-%d")

    s3_key = (
        f"{system}/"
        f"{table.lower()}/"
        f"{ingestion_date}/"
        f"{table.lower()}.csv"
    )

    logger.info(
        "Preparing S3 upload: s3://%s/%s",
        S3_BUCKET,
        s3_key
    )

    csv_buffer = io.StringIO()

    dataframe.to_csv(
        csv_buffer,
        index=False
    )

    s3 = boto3.client(
        "s3",
        region_name=AWS_REGION
    )

    s3.put_object(
        Bucket=S3_BUCKET,
        Key=s3_key,
        Body=csv_buffer.getvalue(),
        ContentType="text/csv"
    )

    logger.info(
        "S3 upload successful: s3://%s/%s | rows=%d",
        S3_BUCKET,
        s3_key,
        len(dataframe)
    )

    return s3_key



# Configuration Loader


def load_config():
    """
    Load ingestion configuration from JSON.
    """

    logger.info(
        "Loading configuration from %s",
        CONFIG_FILE
    )

    if not os.path.exists(CONFIG_FILE):
        raise FileNotFoundError(
            f"Configuration file not found: {CONFIG_FILE}"
        )

    with open(
        CONFIG_FILE,
        "r",
        encoding="utf-8"
    ) as file:
        return json.load(file)



# Configuration Validation


def validate_configuration(config):
    """
    Validate required configuration settings.
    """

    if not SQLSERVER_USER:
        raise ValueError(
            "SQLSERVER_USER is not configured"
        )

    if not SQLSERVER_PASSWORD:
        raise ValueError(
            "SQLSERVER_PASSWORD is not configured"
        )

    if not S3_BUCKET:
        raise ValueError(
            "S3_BUCKET is not configured"
        )

    if "sources" not in config:
        raise ValueError(
            "Configuration must contain 'sources'"
        )

    if not config["sources"]:
        raise ValueError(
            "No sources configured"
        )



# Single Table Processing


def process_table(system, database, table, run_id):

    logger.info(
        "--------------------------------------------------"
    )

    logger.info(
        "Processing %s.%s.%s",
        system,
        database,
        table
    )

    started_at = datetime.now(timezone.utc)

    try:

        dataframe = extract_table(
            database,
            table
        )

        validate_dataframe(
            dataframe,
            system,
            table
        )

        s3_key = upload_to_s3(
            dataframe,
            system,
            table
        )

        completed_at = datetime.now(timezone.utc)

        write_audit_record(
            run_id=run_id,
            system=system,
            database=database,
            table=table,
            rows_extracted=len(dataframe),
            s3_key=s3_key,
            status="SUCCESS",
            error_message=None,
            started_at=started_at,
            completed_at=completed_at
        )

        logger.info(
            "Completed successfully: %s.%s.%s",
            system,
            database,
            table
        )

        return True

    except Exception as error:

        completed_at = datetime.now(timezone.utc)

        write_audit_record(
            run_id=run_id,
            system=system,
            database=database,
            table=table,
            rows_extracted=0,
            s3_key=None,
            status="FAILED",
            error_message=str(error),
            started_at=started_at,
            completed_at=completed_at
        )

        logger.exception(
            "FAILED: %s.%s.%s",
            system,
            database,
            table
        )

        return False


# Main Ingestion Process


def run_ingestion():
    """
    Run ingestion for every configured source and table.
    """

    logger.info("==============================================")
    logger.info("Enterprise Data Platform Ingestion Started")
    logger.info("==============================================")

    start_time = datetime.now(
        timezone.utc
    )
    run_id = str(uuid.uuid4())
    config = load_config()

    validate_configuration(
        config
    )

    successful_tables = 0
    failed_tables = 0

    for source in config["sources"]:

        system = source["system"]
        database = source["database"]
        tables = source["tables"]

        logger.info(
            "Source system: %s | database: %s | tables: %d",
            system,
            database,
            len(tables)
        )

        for table in tables:

            try:

                process_table(
                    system,
                    database,
                    table,
                    run_id
                )

                successful_tables += 1

            except Exception as error:

                failed_tables += 1

                logger.exception(
                    "FAILED: %s.%s.%s | error=%s",
                    system,
                    database,
                    table,
                    error
                )

    end_time = datetime.now(
        timezone.utc
    )

    duration = end_time - start_time

    logger.info("==============================================")
    logger.info("Enterprise Data Platform Ingestion Completed")
    logger.info(
        "Successful tables: %d",
        successful_tables
    )
    logger.info(
        "Failed tables: %d",
        failed_tables
    )
    logger.info(
        "Duration: %s",
        duration
    )
    logger.info("==============================================")

def write_audit_record(
    run_id,
    system,
    database,
    table,
    rows_extracted,
    s3_key,
    status,
    error_message,
    started_at,
    completed_at
):
    """
    Write one ingestion audit record locally.

    This will later be replaced with a Snowflake
    audit table.
    """

    audit_file = "audit/ingestion_audit.csv"

    audit_record = pd.DataFrame([
        {
            "run_id": run_id,
            "source_system": system,
            "database": database,
            "table_name": table,
            "rows_extracted": rows_extracted,
            "s3_key": s3_key,
            "status": status,
            "error_message": error_message,
            "started_at": started_at,
            "completed_at": completed_at
        }
    ])

    file_exists = os.path.exists(audit_file)

    audit_record.to_csv(
        audit_file,
        mode="a",
        header=not file_exists,
        index=False
    )

    logger.info(
        "Audit record written: %s.%s | %s",
        system,
        table,
        status
    )

# ============================================================
# Entry Point
# ============================================================

if __name__ == "__main__":

    try:

        run_ingestion()

    except Exception as error:

        logger.exception(
            "Ingestion pipeline failed: %s",
            error
        )

        raise
