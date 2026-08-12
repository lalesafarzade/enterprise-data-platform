USE [marketing_db];
GO

INSERT INTO Campaigns
(
    campaign_id,
    campaign_name,
    campaign_type,
    start_date,
    end_date,
    budget,
    status,
    created_at
)
VALUES
(8001, 'Spring Electronics Sale', 'EMAIL',
 '2025-03-01', '2025-03-31',
 15000.00, 'COMPLETED', '2025-02-15'),

(8002, 'New Customer Promotion', 'SOCIAL',
 '2025-04-01', '2025-04-30',
 25000.00, 'COMPLETED', '2025-03-15'),

(8003, 'Summer Office Refresh', 'EMAIL',
 '2025-05-01', '2025-05-31',
 18000.00, 'ACTIVE', '2025-04-15'),

(8004, 'Back to Business', 'PAID_SEARCH',
 '2025-06-01', '2025-06-30',
 30000.00, 'PLANNED', '2025-05-15');
GO


INSERT INTO CampaignEvents
(
    event_id,
    campaign_id,
    customer_id,
    event_type,
    event_timestamp,
    channel,
    event_value
)
VALUES
(9001, 8001, 1001, 'EMAIL_OPEN',
 '2025-03-02 08:15:00', 'EMAIL', 0.00),

(9002, 8001, 1001, 'CLICK',
 '2025-03-02 08:20:00', 'EMAIL', 0.00),

(9003, 8001, 1001, 'CONVERSION',
 '2025-03-02 09:10:00', 'EMAIL', 129.97),

(9004, 8001, 1002, 'EMAIL_OPEN',
 '2025-03-03 10:00:00', 'EMAIL', 0.00),

(9005, 8002, 1003, 'CLICK',
 '2025-04-05 13:30:00', 'SOCIAL', 0.00),

(9006, 8002, 1003, 'CONVERSION',
 '2025-04-05 14:00:00', 'SOCIAL', 89.99),

(9007, 8003, 1005, 'EMAIL_OPEN',
 '2025-05-03 09:15:00', 'EMAIL', 0.00),

(9008, 8003, 1005, 'CLICK',
 '2025-05-03 09:20:00', 'EMAIL', 0.00),

(9009, 8003, 1005, 'CONVERSION',
 '2025-05-03 10:05:00', 'EMAIL', 659.98);
GO