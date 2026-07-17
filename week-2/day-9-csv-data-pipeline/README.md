# Day 9 - CSV Data Pipeline: From Raw Data to Clean Reports.

Hey there! This is my project for Day 9. Here is an explanation of what I did, how it works, and what I learned.

## Project Goal
The main goal of this practice is to build a complete, end-to-end data pipeline using only pure Python (no external libraries like Pandas). In this exercise, I took messy raw CSV files containing customers, products, and order transactions, and loaded, validated, cleaned, and aggregated them to produce trustable datasets and business intelligence reports.

## Understanding the Data Layers (Medallion Architecture)
In data engineering, we organize pipelines into stages called Bronze, Silver, and Gold. Here is what they mean in this project:

- **Bronze Layer (Raw landing zone)**: This is our landing spot. The raw files (`customers_raw.csv`, `products_raw.csv`, and `orders_raw.csv`) are loaded directly into Python memory as dictionaries. They are kept exactly as they came, with all their typos, missing dates, and invalid negative quantities, serving as a historical log.
- **Silver Layer (Cleaned & Validated data)**: This is our conformed, clean data zone. I wrote code to validate the raw orders against strict rules (checking for missing data, valid IDs, positive quantities, and allowed channels). 
  - Valid and enriched records are written to `orders_clean.csv`.
  - Invalid records are separated and written to `invalid_orders.csv` with a clear explanation of what went wrong.
- **Gold Layer (Aggregated Business reports)**: This is our analytics-ready zone. Using the clean Silver data, the pipeline performs aggregations to generate key business insights like total completed revenue, top customers, top products, and summaries by city, category, and sales channel. These are compiled into `business_summary.txt`.

## Files and Folders Included
Here is the layout of the folders and files for this day's practice:
```
day-9-csv-data-pipeline/
│
├── data/                       # Contains our raw input CSV files
│   ├── customers_raw.csv
│   ├── products_raw.csv
│   └── orders_raw.csv
│
├── output/                     # Generated files produced by the pipeline
│   ├── orders_clean.csv        # Validated and enriched clean orders
│   ├── invalid_orders.csv      # Rejected orders with error reasons
│   ├── data_quality_report.txt # Operational audit report of the pipeline run
│   └── business_summary.txt    # Gold layer business insights and recommendations
│
├── csv_pipeline.py             # The main Python script that runs the entire pipeline
├── pipeline_explanation.md     # Detailed architectural design and rules document
└── README.md                   # This project documentation file
```

## How to Run the Pipeline
To run the pipeline script, open your terminal and run the command from the root of the project:

```bash
python week-2/day-9-csv-data-pipeline/csv_pipeline.py
```

Or you can move inside the folder and run it:

```bash
cd week-2/day-9-csv-data-pipeline
python csv_pipeline.py
```

## Generated Output Files
Once the script executes, it creates/updates these files in the `output/` directory:
1. **`orders_clean.csv`**: Holds only valid orders, enriched with customer names, cities, product names, categories, prices, and computed total amounts.
2. **`invalid_orders.csv`**: Stores all rejected raw rows alongside a `reason` column explaining why the row failed validation.
3. **`data_quality_report.txt`**: A text report detailing how many orders were processed, how many passed/failed, and an inventory of quality issues.
4. **`business_summary.txt`**: A business-facing dashboard report featuring total completed revenue, sales by channel/category, and high-value customer insights.

## Why No Pandas?
We deliberately built this entire pipeline using only standard Python libraries (like the `csv` module) and basic programming constructs like `for` loops, `if-else` blocks, and standard list/dictionary operations. 

Doing it manually matters because:
1. **Understanding what happens under the hood**: It forces us to understand how file reading, memory buffering, dictionary lookups, and validations work logically, instead of just running a magic `.read_csv()` function.
2. **Algorithmic thinking**: Implementing operations like lookup tables and selection sort for ranking teaches us the algorithmic foundations of data manipulation.
3. **Control and flexibility**: We learn to handle corrupt data gracefully at the line-level, building custom error messages that can be lost in heavy abstractions.
