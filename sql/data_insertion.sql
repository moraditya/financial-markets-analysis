-- Insert data into the companies table
INSERT INTO companies (symbol, "Security", "GICS Sector", "GICS Sub-Industry", "Headquarters Location")
SELECT DISTINCT symbol, "Security", "GICS Sector", "GICS Sub-Industry", "Headquarters Location"
FROM stock_data;


-- Insert data into the stocks table with date conversion
INSERT INTO stocks (symbol, "Date", "Open", "High", "Low", "Close", "Volume", "Dividends", "Stock Splits")
SELECT symbol, 
       TO_DATE("Date", 'YYYY-MM-DD'),  -- convert the "Date" from text to DATE type
       CAST("Open" AS DOUBLE PRECISION),  -- ensure "Open" is cast to correct type
       CAST("High" AS DOUBLE PRECISION),  -- ensure "High" is cast to correct type
       CAST("Low" AS DOUBLE PRECISION),   -- ensure "Low" is cast to correct type
       CAST("Close" AS DOUBLE PRECISION), -- ensure "Close" is cast to correct type
       CAST("Volume" AS BIGINT),          -- ensure "Volume" is cast to BIGINT
       CAST("Dividends" AS DOUBLE PRECISION),  -- ensure "Dividends" is cast to correct type
       CAST("Stock Splits" AS DOUBLE PRECISION) -- ensure "Stock Splits" is cast to correct type
FROM stock_data;


-- Insert data into the stocks_indicators table with date conversion
INSERT INTO stocks_indicators (symbol, "Date", moving_avg_7, moving_avg_30, normalized_close, volatility, high_volatility_flag, price_outlier)
SELECT symbol, 
       TO_DATE("Date", 'YYYY-MM-DD'),  -- convert "Date" from text to DATE type
       CAST(moving_avg_7 AS DOUBLE PRECISION),  -- ensure moving_avg_7 is cast to correct type
       CAST(moving_avg_30 AS DOUBLE PRECISION),  -- ensure moving_avg_30 is cast to correct type
       CAST(normalized_close AS DOUBLE PRECISION),  -- ensure normalized_close is cast to correct type
       CAST(volatility AS DOUBLE PRECISION),  -- ensure volatility is cast to correct type
       CAST(high_volatility_flag AS BOOLEAN),  -- ensure high_volatility_flag is cast to correct type
       CAST(price_outlier AS BOOLEAN)  -- ensure price_outlier is cast to correct type
FROM stock_data;
