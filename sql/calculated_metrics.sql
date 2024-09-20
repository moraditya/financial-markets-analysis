-- Calculated Metrics (Advanced)



-- Exponential Moving Average (EMA)
--- Step 1: add ema_14 to stocks_indicators
ALTER TABLE stocks_indicators
ADD COLUMN ema_14 DOUBLE PRECISION;
-- Step 2: Calculate the 14-day Simple Moving Average to initialize EMA
WITH ema_14_calc AS (
    SELECT s.symbol, s."Date",
           AVG(s."Close") OVER (PARTITION BY s.symbol ORDER BY s."Date" ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS sma_14
    FROM stocks s
)
UPDATE stocks_indicators si
SET ema_14 = ema_14_calc.sma_14
FROM ema_14_calc
WHERE si.symbol = ema_14_calc.symbol
AND si."Date" = ema_14_calc."Date";

-- Step 3: Iteratively update EMA for subsequent days
WITH iterative_ema AS (
    SELECT si.symbol, si."Date", 
           si.ema_14,
           LAG(si.ema_14) OVER (PARTITION BY si.symbol ORDER BY si."Date") AS prev_ema_14,
           s."Close"
    FROM stocks_indicators si
    JOIN stocks s ON si.symbol = s.symbol AND si."Date" = s."Date"
)
UPDATE stocks_indicators
SET ema_14 = (prev_ema_14 + (2 / (14 + 1)) * (iterative_ema."Close" - prev_ema_14))
FROM iterative_ema
WHERE stocks_indicators.symbol = iterative_ema.symbol
AND stocks_indicators."Date" = iterative_ema."Date"
AND iterative_ema.prev_ema_14 IS NOT NULL; -- Ensure only subsequent updates








-- Relative Strength Index (RSI)
-- Step 1: Add the RSI column to the stocks_indicators table
ALTER TABLE stocks_indicators
ADD COLUMN rsi_14 DOUBLE PRECISION;
-- Step 2: Calculate daily returns, gain and loss, average gain and loss for 14 days, RS and RSI
WITH daily_returns AS (
    SELECT symbol, "Date",
           ("Close" - LAG("Close") OVER (PARTITION BY symbol ORDER BY "Date")) AS daily_change
    FROM stocks
)
, gains_losses AS (
    SELECT symbol, "Date",
           CASE WHEN daily_change > 0 THEN daily_change ELSE 0 END AS gain,
           CASE WHEN daily_change < 0 THEN ABS(daily_change) ELSE 0 END AS loss
    FROM daily_returns
)
, avg_gain_loss AS (
    SELECT symbol, "Date",
           AVG(gain) OVER (PARTITION BY symbol ORDER BY "Date" ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS avg_gain_14,
           AVG(loss) OVER (PARTITION BY symbol ORDER BY "Date" ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS avg_loss_14
    FROM gains_losses
)
, rs_rsi AS (
    SELECT symbol, "Date",
           CASE WHEN avg_loss_14 = 0 THEN 100
                ELSE 100 - (100 / (1 + (avg_gain_14 / avg_loss_14)))
           END AS rsi_14
    FROM avg_gain_loss
)
-- Step 3: Update stocks_indicators table with RSI values
UPDATE stocks_indicators
SET rsi_14 = rs_rsi.rsi_14
FROM rs_rsi
WHERE stocks_indicators.symbol = rs_rsi.symbol
AND stocks_indicators."Date" = rs_rsi."Date";





-- On-Balance Volume
-- Step 1: Add OBV column to stocks_indicators table
ALTER TABLE stocks_indicators
ADD COLUMN obv BIGINT;
-- Step 2: calculate OBV for each stock based on daily volume changes using CTE
WITH obv_calc AS (
    SELECT symbol, "Date",
           "Volume",
           LAG("Close") OVER (PARTITION BY symbol ORDER BY "Date") AS prev_close,
           CASE 
               WHEN "Close" > LAG("Close") OVER (PARTITION BY symbol ORDER BY "Date") THEN "Volume"
               WHEN "Close" < LAG("Close") OVER (PARTITION BY symbol ORDER BY "Date") THEN - "Volume"
               ELSE 0
           END AS obv_change
    FROM stocks
),
obv_cumulative AS (
    -- Calculate cumulative OBV by summing obv_change over time
    SELECT symbol, "Date",
           SUM(obv_change) OVER (PARTITION BY symbol ORDER BY "Date" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS obv
    FROM obv_calc
)
-- Step 3: Update the OBV values in the stocks_indicators table
UPDATE stocks_indicators
SET obv = obv_cumulative.obv
FROM obv_cumulative
WHERE stocks_indicators.symbol = obv_cumulative.symbol
AND stocks_indicators."Date" = obv_cumulative."Date";





-- Bollinger Bands
-- Step 1: Add Bollinger Bands columns to stocks_indicators table
ALTER TABLE stocks_indicators
ADD COLUMN bollinger_sma_20 DOUBLE PRECISION,
ADD COLUMN bollinger_upper_band DOUBLE PRECISION,
ADD COLUMN bollinger_lower_band DOUBLE PRECISION;
-- Step 2: Calculate 20-day SMA, upper band, and lower band for Bollinger Bands
WITH sma_20_calc AS (
    SELECT stocks.symbol, stocks."Date",
           AVG(stocks."Close") OVER (PARTITION BY stocks.symbol ORDER BY stocks."Date" ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS sma_20
    FROM stocks
),
stddev_calc AS (
    -- Calculate standard deviation over the same 20-day window
    SELECT sma_20_calc.symbol, sma_20_calc."Date",
           sma_20_calc.sma_20,
           STDDEV(stocks."Close") OVER (PARTITION BY stocks.symbol ORDER BY stocks."Date" ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS stddev_20
    FROM sma_20_calc
    JOIN stocks ON sma_20_calc.symbol = stocks.symbol AND sma_20_calc."Date" = stocks."Date"
)
-- Step 3: Update stocks_indicators table with the calculated Bollinger Bands
UPDATE stocks_indicators
SET bollinger_sma_20 = stddev_calc.sma_20,
    bollinger_upper_band = stddev_calc.sma_20 + (2 * stddev_calc.stddev_20),
    bollinger_lower_band = stddev_calc.sma_20 - (2 * stddev_calc.stddev_20)
FROM stddev_calc
WHERE stocks_indicators.symbol = stddev_calc.symbol
AND stocks_indicators."Date" = stddev_calc."Date";




-- Moving Average Convergence Divergence (MACD)
-- Step 1: Add columns for MACD, Signal line, and Histogram to stocks_indicators table
ALTER TABLE stocks_indicators
ADD COLUMN ema_12 DOUBLE PRECISION,
ADD COLUMN ema_26 DOUBLE PRECISION,
ADD COLUMN macd_line DOUBLE PRECISION,
ADD COLUMN signal_line DOUBLE PRECISION,
ADD COLUMN macd_histogram DOUBLE PRECISION;
-- Step 2: Calculate the 12-day EMA
WITH ema_12_calc AS (
    SELECT stocks.symbol, stocks."Date",
           AVG(stocks."Close") OVER (PARTITION BY stocks.symbol ORDER BY stocks."Date" ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS sma_12
    FROM stocks
)
UPDATE stocks_indicators
SET ema_12 = ema_12_calc.sma_12
FROM ema_12_calc
WHERE stocks_indicators.symbol = ema_12_calc.symbol
AND stocks_indicators."Date" = ema_12_calc."Date";
-- Step 3: Calculate the 26-day EMA
WITH ema_26_calc AS (
    SELECT stocks.symbol, stocks."Date",
           AVG(stocks."Close") OVER (PARTITION BY stocks.symbol ORDER BY stocks."Date" ROWS BETWEEN 25 PRECEDING AND CURRENT ROW) AS sma_26
    FROM stocks
)
UPDATE stocks_indicators
SET ema_26 = ema_26_calc.sma_26
FROM ema_26_calc
WHERE stocks_indicators.symbol = ema_26_calc.symbol
AND stocks_indicators."Date" = ema_26_calc."Date";
-- Step 4: Calculate the MACD line (ema_12 - ema_26)
UPDATE stocks_indicators
SET macd_line = ema_12 - ema_26;
-- Step 5: Calculate the Signal line (9-day EMA of the MACD line)
WITH signal_calc AS (
    SELECT stocks_indicators.symbol, stocks_indicators."Date",
           AVG(stocks_indicators.macd_line) OVER (PARTITION BY stocks_indicators.symbol ORDER BY stocks_indicators."Date" ROWS BETWEEN 8 PRECEDING AND CURRENT ROW) AS signal_9
    FROM stocks_indicators
)
UPDATE stocks_indicators
SET signal_line = signal_calc.signal_9
FROM signal_calc
WHERE stocks_indicators.symbol = signal_calc.symbol
AND stocks_indicators."Date" = signal_calc."Date";
-- Step 6: Calculate the MACD Histogram (macd_line - signal_line)
UPDATE stocks_indicators
SET macd_histogram = macd_line - signal_line;




-- Average True Range (ATR)
-- Step 1: Add atr_14 to stocks_indicators
ALTER TABLE stocks_indicators
ADD COLUMN atr_14 DOUBLE PRECISION;
-- Step 2: Calculate and populate the True Range and 14-day ATR
WITH tr_cte AS (
    SELECT symbol, "Date",
           GREATEST(
               ("High" - "Low"), 
               ABS("High" - LAG("Close") OVER (PARTITION BY symbol ORDER BY "Date")),
               ABS("Low" - LAG("Close") OVER (PARTITION BY symbol ORDER BY "Date"))
           ) AS true_range
    FROM stocks
    WHERE "High" IS NOT NULL AND "Low" IS NOT NULL AND "Close" IS NOT NULL
),
atr_calc AS (
    SELECT symbol, "Date",
           AVG(true_range) OVER (PARTITION BY symbol ORDER BY "Date" ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS atr_14
    FROM tr_cte
)
-- Step 3: Update stocks_indicators with the calculated ATR
UPDATE stocks_indicators
SET atr_14 = atr_calc.atr_14
FROM atr_calc
WHERE stocks_indicators.symbol = atr_calc.symbol
AND stocks_indicators."Date" = atr_calc."Date";






-- Price Momentum
-- Step 1: Add momentum_10 to stocks_indicators
ALTER TABLE stocks_indicators
ADD COLUMN momentum_10 DOUBLE PRECISION;

-- Step 2: Calculate 10-day Momentum
WITH momentum_cte AS (
    SELECT symbol, "Date",
           "Close" - LAG("Close", 10) OVER (PARTITION BY symbol ORDER BY "Date") AS momentum_10
    FROM stocks
)

-- Step 3: Update stocks_indicators with the calculated Momentum
UPDATE stocks_indicators
SET momentum_10 = momentum_cte.momentum_10
FROM momentum_cte
WHERE stocks_indicators.symbol = momentum_cte.symbol
AND stocks_indicators."Date" = momentum_cte."Date";


select * from stocks_indicators;