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
