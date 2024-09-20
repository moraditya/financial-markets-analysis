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





-- Daily Summary View
CREATE OR REPLACE VIEW daily_summary AS
SELECT 
    s.symbol,
    s."Date",
    s."Close",
    s."Volume",
    si.ema_14,
    si.rsi_14,
    si.macd_line,
    si.bollinger_upper_band,
    si.bollinger_lower_band,
    si.volatility,
    (s."Close" - LAG(s."Close") OVER (PARTITION BY s.symbol ORDER BY s."Date")) / LAG(s."Close") OVER (PARTITION BY s.symbol ORDER BY s."Date") * 100 AS daily_return
FROM stocks s
JOIN stocks_indicators si ON s.symbol = si.symbol AND s."Date" = si."Date"
WHERE s."Close" IS NOT NULL;




-- Weekly Summary View
CREATE OR REPLACE VIEW weekly_summary AS
SELECT 
    s.symbol,
    DATE_TRUNC('week', s."Date") AS week_start,
    AVG(s."Close") AS weekly_avg_close,
    SUM(s."Volume") AS weekly_volume,
    MAX(si.rsi_14) AS max_weekly_rsi,
    MIN(si.bollinger_lower_band) AS min_weekly_bollinger,
    AVG(si.volatility) AS avg_weekly_volatility
FROM stocks s
JOIN stocks_indicators si ON s.symbol = si.symbol AND s."Date" = si."Date"
WHERE s."Close" IS NOT NULL
GROUP BY s.symbol, DATE_TRUNC('week', s."Date")
ORDER BY s.symbol, week_start;






-- Monthly Summary View
CREATE OR REPLACE VIEW monthly_summary AS
SELECT 
    s.symbol,
    DATE_TRUNC('month', s."Date") AS month_start,
    AVG(s."Close") AS monthly_avg_close,
    SUM(s."Volume") AS monthly_volume,
    AVG(si.ema_14) AS avg_monthly_ema_14,
    AVG(si.rsi_14) AS avg_monthly_rsi,
    MAX(si.bollinger_upper_band) AS max_monthly_bollinger
FROM stocks s
JOIN stocks_indicators si ON s.symbol = si.symbol AND s."Date" = si."Date"
WHERE s."Close" IS NOT NULL
GROUP BY s.symbol, DATE_TRUNC('month', s."Date")
ORDER BY s.symbol, month_start;





-- Volume Trend View
CREATE OR REPLACE VIEW volume_trend AS
SELECT 
    s.symbol,
    s."Date",
    s."Volume",
    AVG(s."Volume") OVER (PARTITION BY s.symbol ORDER BY s."Date" ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_weekly_volume,
    AVG(s."Volume") OVER (PARTITION BY s.symbol ORDER BY s."Date" ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS avg_monthly_volume
FROM stocks s
WHERE s."Volume" IS NOT NULL;





-- Performance Comparison View
CREATE OR REPLACE VIEW performance_comparison AS
SELECT 
    c."GICS Sector",
    c.symbol,
    DATE_TRUNC('month', s."Date") AS month_start,
    AVG(s."Close") AS sector_avg_close,
    AVG(si.rsi_14) AS sector_avg_rsi
FROM stocks s
JOIN companies c ON s.symbol = c.symbol
JOIN stocks_indicators si ON s.symbol = si.symbol AND s."Date" = si."Date"
GROUP BY c."GICS Sector", c.symbol, DATE_TRUNC('month', s."Date")
ORDER BY c."GICS Sector", month_start;





-- High Volatility Events View
CREATE OR REPLACE VIEW high_volatility_events AS
SELECT 
    s.symbol,
    s."Date",
    s."Close",
    si.volatility,
    si.high_volatility_flag,
    si.price_outlier
FROM stocks s
JOIN stocks_indicators si ON s.symbol = si.symbol AND s."Date" = si."Date"
WHERE si.high_volatility_flag = TRUE
ORDER BY s.symbol, s."Date";





-- Sector-Wise Performance View
CREATE OR REPLACE VIEW sector_performance AS
SELECT 
    c."GICS Sector",
    DATE_TRUNC('quarter', s."Date") AS quarter_start,
    AVG(s."Close") AS avg_sector_close,
    SUM(s."Volume") AS total_sector_volume
FROM stocks s
JOIN companies c ON s.symbol = c.symbol
GROUP BY c."GICS Sector", DATE_TRUNC('quarter', s."Date")
ORDER BY c."GICS Sector", quarter_start;





-- Outlier Detection View
CREATE OR REPLACE VIEW outlier_detection AS
SELECT 
    s.symbol,
    s."Date",
    s."Close",
    si.price_outlier,
    CASE 
        WHEN si.price_outlier = TRUE THEN 'Significant Outlier'
        ELSE 'Normal'
    END AS outlier_status
FROM stocks s
JOIN stocks_indicators si ON s.symbol = si.symbol AND s."Date" = si."Date"
WHERE si.price_outlier IS NOT NULL
ORDER BY s.symbol, s."Date";



