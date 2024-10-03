# Stock Market Analysis Project

## Project Overview
This project is an end-to-end data pipeline for analyzing stock market data. It involves extracting, transforming, and loading (ETL) S&P 500 stock data from June 2024 till September 2024, performing exploratory data analysis (EDA), calculating key financial metrics, and building dynamic dashboards in Tableau for visualizing stock performance. The project showcases skills in data engineering, SQL, and data visualization.

## Table of Contents
- [Project Overview](#project-overview)
- [Data Pipeline](#data-pipeline)
- [Database Schema](#database-schema)
- [Data Aggregation and Calculated Metrics](#data-aggregation-and-calculated-metrics)
- [SQL Queries](#sql-queries)
- [Tableau Dashboards](#tableau-dashboards)
- [Technologies Used](#technologies-used)
- [How to Run the Project](#how-to-run-the-project)
- [Conclusions](#conclusions)

## Data Pipeline

The ETL pipeline processes stock data, aggregates it, and loads it into a PostgreSQL database. The pipeline includes:

1. **Extract**: Stock market data (multiple CSV files) was compiled into a single dataset.
![image](https://github.com/user-attachments/assets/9cee21ab-a0fe-4e35-80a6-6e4bbbb54a8f)
2. **Transform**: Data cleaning and feature engineering steps such as calculating moving averages, volatility, and flagging price outliers.
![image](https://github.com/user-attachments/assets/7caf0735-2ca9-4181-a262-092885a598b4)
3. **Load**: Processed data was loaded into a PostgreSQL database.
![image](https://github.com/user-attachments/assets/a6d7e9b2-91f1-400c-9c8c-c2bc96fa6b5e)

**Each respective s&p 500 company csv file is located in  `data/stock_data` folder, and the original s&p 500 dataset used for ETL is stored in `data/s&p500.csv`.**

**Key Scripts**:
- `etl_pipeline/ETL_stock_data.ipynb`: Uses the s&p 500 dataset to extract stock information using the yahoo finance API, transforms the data for each s&p500 company, and loads and saves each company's data into a csv file.
- `etl_pipeline/compiling_stock_data.ipynb`: Compiles raw CSV files into a single dataset.
![image](https://github.com/user-attachments/assets/d4f1836d-51ee-4f3b-b74d-ac864dea06c4)
- `etl_pipeline/stock_data_EDA.ipynb`: Performs exploratory data analysis on the aggregated dataframe.
![image](https://github.com/user-attachments/assets/d78e5a83-e810-4fec-932b-c667c07bfc71)
- `etl_pipeline/load_to_postgresql.ipynb`: Loads cleaned and aggregated data into PostgreSQL.
![image](https://github.com/user-attachments/assets/5a453c39-ec4c-44f6-bd45-75f989fbd5de)


## Database Schema

The PostgreSQL schema consists of three main tables:

1. **stock_data**: Aggregated dataframe from ETL pipeline that was used to create the following tables.
2. **stocks**: Contains core stocks information.
3. **companies**: Contains metadata about companies (e.g., sector, industry).
4. **stocks_indicators**: Holds basic and advanced calculated financial indicators (e.g., EMA, RSI, MACD).
5. **daily_aggregated_data**: Holds close and volume stock information on a daily scale.
6. **weekly_aggregated_data**: Holds close and volume stock information on a weekly scale (averaged).
7. **monthly_aggregated_data**: Holds close and volume stock information on a monthly scale (averaged).


**SQL Files**:
- `sql/create_schema.sql`: SQL queries to create the tables and relationships.
 ![image](https://github.com/user-attachments/assets/95ebf931-df96-4e7c-8c98-ac776c9f3567)
- `sql/insert_data.sql`: Queries to insert data into the tables.
![image](https://github.com/user-attachments/assets/7fce92d9-d6c7-477b-ba22-ced6fb3723a5)


## Data Aggregation and Calculated Metrics

The project computes several **basic** and **advanced financial metrics** to aid in stock analysis:

### Basic Metrics:
- Daily, weekly, and monthly price changes, among others. Below is an example of some of the computed basic metrics. Refer to `sql/basic_calculated_metrics.sql` to see them all.
![image](https://github.com/user-attachments/assets/537e5a73-7fa1-470f-88d1-ca19dff25621)

### Advanced Metrics (Note: Longer queries were pasted in notepad for screenshot availibility, and shorter ones were done directly in postgres):

- **EMA** (Exponential Moving Average)
![image](https://github.com/user-attachments/assets/af37512b-3305-420e-86ef-2606e03f5dba)

- **RSI** (Relative Strength Index)
![image](https://github.com/user-attachments/assets/848d8845-ec53-44b8-924f-df9ff40e5684)

- **OBV** (On-balance Volume)
![image](https://github.com/user-attachments/assets/6b50b82d-1e39-41b4-8fbc-6a7e7f806ca1)

- **MACD** (Moving Average Convergence Divergence)
![image](https://github.com/user-attachments/assets/89dd4d2d-8572-417e-a128-d44aef20d0d3)

- **Bollinger Bands**
![image](https://github.com/user-attachments/assets/eb0f431d-224a-4b36-ab3f-817bdf249b04)

- **ATR** (Average True Range)
![image](https://github.com/user-attachments/assets/3bc0836e-8e37-42a9-bf1e-cd52edfcda59)

- **Momentum**


![image](https://github.com/user-attachments/assets/f28d0021-964f-44e8-8dad-2c0d823c8696)

- **Rate of Change**


![image](https://github.com/user-attachments/assets/6a72b998-5521-4ddd-865f-b6df01f3921c)

- **Accumulation/Distribution Line (ADL)**
![image](https://github.com/user-attachments/assets/1b432af0-fd7b-4776-bb8c-1dda40b0c148)

- **Chaikin Money Flow**
![image](https://github.com/user-attachments/assets/641e4223-4084-4ee8-8f21-846aee9af046)




**SQL File**:
- `sql/calculated_metrics.sql`: Contains the SQL queries for calculating advanced metrics.

## SQL Queries

Four SQL files were created during this project:

1. **create_schema.sql**: Contains table creation queries and relationships.
2. **insert_data.sql**: Handles the insertion of processed data into the PostgreSQL tables.
3. **basic_calculated_metrics.sql**: Calculates various basic financial indicators.
4. **calculated_metrics.sql**: Calculates various advanced financial indicators.
5. **stock_market_analysis_queries.sql**: Contains some some summary views such as sector performance and volatility analysis.
6. **EDA_queries.sql**:  Contains extensive summary views, used for building the Tableau dashboard.


## Tableau Dashboards

The final step of this project involved creating dynamic dashboards in Tableau, connecting directly to the PostgreSQL database. The following key dashboards were created:

1. **S&P 500 Performance Dashboard**: Comprehensive performance dashboard that compiles all the aforementioned sheets into one dynamic dashboard.
![image](https://github.com/user-attachments/assets/4da66e14-4f2e-4662-84b1-fca38ee85058)

3. **Stock Performance Overview**: Line chart visualizing stock price trends and trading volume over time.
4. **Stock Risk and Volatility Analysis**: Focused on analyzing high volatility and price outliers.
5. **High Volatility Flag**: Stacked column bar chart indicating the top 50 performing companies' volatility.
6. **Momentum, RSI, and MACD**: Key financial indicators for selected companies, including price change, volume change, and advanced metrics such as MACD and RSI.
7. **Price Change KPI**: Showing price changes in daily, weekly, and monthly format.

The Tableau workbook is available in the `visualizations/` folder.

## Technologies Used

- **Python**: For the ETL pipeline and data transformation (Pandas, NumPy).
- **PostgreSQL**: For data storage and querying.
- **SQL**: For schema creation, data manipulation, and summary views.
- **Tableau**: For building dynamic, interactive dashboards.
- **GitHub**: For version control and project management.

## How to Run the Project

### Prerequisites:
1. PostgreSQL installed locally or accessible remotely.
2. Tableau installed to view the dashboards.
3. Python environment with required libraries (Pandas, NumPy, psycopg2).

### Steps:
1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/stock-market-analysis.git
    cd stock-market-analysis
    ```
2. **Run the ETL Pipeline**:
   - Open and run the Jupyter notebooks in the `etl_pipeline/` folder.
   - `compiling_stock_data.ipynb`: Compiles the data.
   - `load_to_postgresql.ipynb`: Loads the data into PostgreSQL.

3. **Set up PostgreSQL**:
   - Use `create_schema.sql` and `insert_data.sql` in the `sql/` folder to create tables and insert data.
   - Run the `calculate_metrics.sql` to generate financial metrics.
   
4. **Connect Tableau**:
   - Connect Tableau to your PostgreSQL database and load the views or tables.
   - Open the `.twbx` files in the `visualizations/` folder to view the dashboards.

## Conclusions

This project demonstrates a full-stack data pipeline workflow, from raw data processing to dynamic dashboards. It highlights strong **SQL**, **data engineering**, and **visualization** skills using modern tools like PostgreSQL and Tableau. The final output is a dynamic dashboard that can assist in financial decision-making and stock performance analysis. One way to improve this project would be to incorporate a real time ETL pipeline that updates every quarter or even every day, depending on the users' needs.

---

