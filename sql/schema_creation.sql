-- Create the companies table
CREATE TABLE companies (
	symbol VARCHAR(10) PRIMARY KEY, -- unique stock symbol
	"Security" VARCHAR(255),        -- the name of the company
	"GICS Sector" VARCHAR(100),
	"GICS Sub-Industry" VARCHAR(100),
	"Headquarters Location" VARCHAR(255)
);

-- Create the stocks table
CREATE TABLE stocks (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) REFERENCES companies(symbol), -- Foreign key referencing companies table
    "Date" DATE, 
    "Open" DOUBLE PRECISION,
    High DOUBLE PRECISION,
    Low DOUBLE PRECISION,
    "Close" DOUBLE PRECISION,
    Volume BIGINT,
    Dividends DOUBLE PRECISION,
    "Stock Splits" DOUBLE PRECISION,
    CONSTRAINT unique_symbol_date UNIQUE (symbol, "Date") -- Composite unique constraint
);


-- Create the stock indicators table
CREATE TABLE stocks_indicators (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) REFERENCES companies(symbol), -- Foreign key referencing companies table
    "Date" DATE, 
    moving_avg_7 DOUBLE PRECISION, 
    moving_avg_30 DOUBLE PRECISION, 
    normalized_close DOUBLE PRECISION, 
    volatility DOUBLE PRECISION, 
    high_volatility_flag BOOLEAN, 
    price_outlier BOOLEAN,
    CONSTRAINT fk_symbol_date FOREIGN KEY (symbol, "Date") REFERENCES stocks(symbol, "Date") -- Foreign key referencing stocks table
);
