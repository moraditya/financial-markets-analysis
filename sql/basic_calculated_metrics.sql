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
