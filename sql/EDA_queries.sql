-- Exploratory Data Analysis Queries


--- Cleaned and aggregated tables (daily, weekly, and monthly)
-- Daily Aggregated Table
CREATE TABLE daily_aggregated_data AS
SELECT 
    symbol,
    "Date",
    "Close",
    "Volume"
FROM stocks
WHERE "Close" IS NOT NULL;

-- Weekly Aggregated Table
CREATE TABLE weekly_aggregated_data AS
SELECT 
    symbol,
    DATE_TRUNC('week', "Date") AS week_start,
    AVG("Close") AS weekly_avg_close,
    SUM("Volume") AS weekly_volume
FROM stocks
GROUP BY symbol, DATE_TRUNC('week', "Date")
ORDER BY symbol, week_start;

-- Monthly Aggregated Table
CREATE TABLE monthly_aggregated_data AS
SELECT 
    symbol,
    DATE_TRUNC('month', "Date") AS month_start,
    AVG("Close") AS monthly_avg_close,
    SUM("Volume") AS monthly_volume
FROM stocks
GROUP BY symbol, DATE_TRUNC('month', "Date")
ORDER BY symbol, month_start;
