USE [marketing_db];
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Campaigns'
)
BEGIN
    CREATE TABLE Campaigns
    (
        campaign_id INT PRIMARY KEY,
        campaign_name VARCHAR(100) NOT NULL,
        campaign_type VARCHAR(50),
        start_date DATE NOT NULL,
        end_date DATE,
        budget DECIMAL(12,2),
        status VARCHAR(20) NOT NULL,
        created_at DATETIME2 NOT NULL
    );
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'CampaignEvents'
)
BEGIN
    CREATE TABLE CampaignEvents
    (
        event_id INT PRIMARY KEY,
        campaign_id INT NOT NULL,
        customer_id INT NOT NULL,
        event_type VARCHAR(30) NOT NULL,
        event_timestamp DATETIME2 NOT NULL,
        channel VARCHAR(30),
        event_value DECIMAL(12,2),

        CONSTRAINT FK_CampaignEvents_Campaigns
            FOREIGN KEY (campaign_id)
            REFERENCES Campaigns(campaign_id)
    );
END
GO