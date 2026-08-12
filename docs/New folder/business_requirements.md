# Background

Northwind Retail Group is a mid-sized retailer that sells products online and through physical stores.

Over the years, different departments implemented their own systems:

Sales uses a CRM.
Finance uses an ERP.
E-commerce stores orders in SQL Server.
Marketing tracks campaigns in a separate platform.
Customer Support manages tickets independently.

Because these systems don't communicate well, reporting is slow, inconsistent, and difficult to trust.

# Business Challenges
Customer information is duplicated across systems.
Sales reports take hours to produce.
Product and inventory data are inconsistent.
Business users don't have a single source of truth.
The current SQL Server environment doesn't scale well.

# Project Goal

Design and build a modern enterprise data platform that:

Consolidates data from multiple source systems.
Migrates legacy SQL Server workloads to Snowflake.
Uses Data Vault 2.0 for scalable integration.
Creates dimensional data marts for analytics.
Automates ingestion, testing, deployment, and monitoring.


# Functional Requirements

1. Ingest customer data from the CRM.

2. Load product and inventory data from the ERP.

3. Import sales transactions from SQL Server.

4. Load marketing campaign data from external APIs.

5. Store raw data in Snowflake.

6. Transform data using dbt.

7. Build a Data Vault 2.0 model.

8. Create dimensional data marts.

9. Publish business-ready datasets for reporting.

10. Run automated data quality checks.

# Non-Functional Requirements

• Secure access using RBAC

• Automated deployments

• Data lineage

• High availability

• Scalability

• Auditability

• Incremental loading

• Error handling

• Monitoring

• Logging