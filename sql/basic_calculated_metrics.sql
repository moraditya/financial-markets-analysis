-- Calculated Metrics (Basic)


--- Daily Price Change (Simple Price Difference)
-- Step 1: Add daily_price_change to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN daily_price_change DOUBLE PRECISION;

-- Step 2: Calculate the daily price change
UPDATE stocks_indicators
SET daily_price_change = s."Close" - s."Open"
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";




--- Percentage Change 
-- [((close - open)/open)*100]
-- Step 1: Add percentage_change to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN percentage_change DOUBLE PRECISION;

-- Step 2: Calculate percentage change
UPDATE stocks_indicators
SET percentage_change = ((s."Close" - s."Open") / s."Open") * 100
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";





--- Price Change (High-low Difference)
-- Step 1: Add price_range to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN price_range DOUBLE PRECISION;

-- Step 2: Calculate the price range
UPDATE stocks_indicators
SET price_range = s."High" - s."Low"
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";





--- Average Price
-- Step 1: Add average_price to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN average_price DOUBLE PRECISION;

-- Step 2: Calculate the average price
UPDATE stocks_indicators
SET average_price = (s."Open" + s."Close") / 2
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";





--- Volume-Weighted Average Price
-- Step 1: Add vwap to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN vwap DOUBLE PRECISION;

-- Step 2: Calculate VWAP
UPDATE stocks_indicators
SET vwap = ((s."High" + s."Low" + s."Close") / 3) * s."Volume"
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";





--- Price-Volume Ratio
-- Step 1: Add price_volume_ratio to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN price_volume_ratio DOUBLE PRECISION;

-- Step 2: Calculate the Price-Volume Ratio
UPDATE stocks_indicators
SET price_volume_ratio = s."Close" / s."Volume"
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";






--- Cumulative Volume
-- Step 1: Add cumulative_volume to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN cumulative_volume BIGINT;

-- Step 2: Calculate Cumulative Volume (can be adjusted for weekly, monthly)
WITH cumulative_volume_cte AS (
    SELECT symbol, "Date", SUM("Volume") OVER (PARTITION BY symbol ORDER BY "Date") AS cum_vol
    FROM stocks
)
UPDATE stocks_indicators
SET cumulative_volume = cumulative_volume_cte.cum_vol
FROM cumulative_volume_cte
WHERE stocks_indicators.symbol = cumulative_volume_cte.symbol
AND stocks_indicators."Date" = cumulative_volume_cte."Date";






--- Daily Volatility Percentage (DVP)
-- Step 1: Add daily_volatility_percent to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN daily_volatility_percent DOUBLE PRECISION;

-- Step 2: Calculate the daily volatility percentage
UPDATE stocks_indicators
SET daily_volatility_percent = ((s."High" - s."Low") / s."Open") * 100
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";






--- Volume Change (day-over-day change)
-- Step 1: Add volume_change to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN volume_change BIGINT;

-- Step 2: Calculate the volume change
WITH volume_cte AS (
    SELECT symbol, "Date",
           "Volume" - LAG("Volume") OVER (PARTITION BY symbol ORDER BY "Date") AS vol_change
    FROM stocks
)
UPDATE stocks_indicators
SET volume_change = volume_cte.vol_change
FROM volume_cte
WHERE stocks_indicators.symbol = volume_cte.symbol
AND stocks_indicators."Date" = volume_cte."Date";






--- High-low Percent Difference
-- Step 1: Add high_low_percent_diff to stocks_indicators
ALTER TABLE stocks_indicators ADD COLUMN high_low_percent_diff DOUBLE PRECISION;

-- Step 2: Calculate High-Low Percent Difference
UPDATE stocks_indicators
SET high_low_percent_diff = ((s."High" - s."Low") / s."Low") * 100
FROM stocks s
WHERE stocks_indicators.symbol = s.symbol
AND stocks_indicators."Date" = s."Date";

