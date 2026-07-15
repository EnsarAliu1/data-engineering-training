# Day 8 - Python Data Logic Sprint Heavy Version

---

## Business Scenario

A small e-commerce company keeps a list of customer orders. Each order has a
customer name, a product, a city, a sales channel, a category, a quantity, a price,
and a status that shows whether the order was completed, pending, cancelled, or returned.

The problem is that the raw data is messy. Some orders have no customer name.
Some have zero or negative quantities. Some have prices of zero. Status values are
spelled in different ways across different records. The city name "Prishtine" appears
instead of "Prishtina". Category and channel values have inconsistent capitalization.

The goal of this sprint was to build a full data pipeline in Python that cleans this
raw data, validates it, calculates real business metrics, and writes professional
output reports — all without using any external libraries. Everything is done with
plain Python: loops, dictionaries, lists, functions, and file writing.

---

## Files and Folders

```
day-8-python-data-logic-sprint-heavy/
│
├── python_data_analysis.py     # Main script — runs the full pipeline
├── order_data.py               # Raw order data stored as a Python list of dictionaries
├── logic_explanations.md       # Part 9 — written explanations of key logic decisions
├── daily_report.txt            # Daily progress notes
├── README.md                   # This file
│
└── output/                     # Generated reports (created when the script runs)
    ├── invalid_records.txt     # List of removed records and why they were invalid
    ├── validation_report.txt   # Full validation summary with raw value inventory
    └── business_report.txt     # Revenue totals, top orders, and final recommendation
```

---

## How to Run

Make sure you are in the root of the project folder, then run:

```bash
python week-2/day-8-python-data-logic-sprint-heavy/python_data_analysis.py
```

Or if you are already inside the `day-8-python-data-logic-sprint-heavy` folder:

```bash
python python_data_analysis.py
```

> Python 3 is required. No third-party libraries are needed. Everything uses the
> Python standard library only.

The script will print all results to the terminal and automatically write three
output files into the `output/` folder.

---

## Output Files Generated

| File | What it contains |
|------|-----------------|
| `output/invalid_records.txt` | One line per invalid record showing the order ID, customer name, and the reason it was rejected |
| `output/validation_report.txt` | Full summary: total records, valid count, invalid count, each rejection reason, and all unique raw values before cleaning |
| `output/business_report.txt` | Total completed revenue, revenue broken down by city, category and channel, top 5 orders by value, repeat customers, and a final data quality recommendation |

---

## Main Python Concepts Practiced

- **Functions** — Every logical step is wrapped in its own function so the code stays
  organized and easy to test piece by piece.

- **Loops** — `for` loops are used throughout to iterate over orders, build counts,
  accumulate revenue totals, and write file output line by line.

- **Dictionaries** — Used to group and count data dynamically. A key is created the
  first time a value appears, then incremented on every following match.

- **List operations** — Filtering into valid and invalid lists, copying lists to avoid
  mutating the original data, and slicing with `[:5]` and `[:3]` to get top records.

- **String methods** — `.join()` to combine reason messages, `.split()` to extract
  parts of a string, and f-strings to format every printed and written line.

- **File writing** — `open()`, `.write()`, and `.close()` used to produce three
  separate output files with structured, readable content.

- **Sorting with a key** — `list.sort()` and `sorted()` used with `key=lambda` to
  rank orders and groups by revenue, then sliced to get the top results.

- **Data validation logic** — Checking for empty strings, zero values, and negative
  numbers before any calculation runs, and separating clean records from bad ones.

- **Normalization** — Detecting inconsistent spellings and casing across status, city,
  category, and channel fields, then standardizing them to a single agreed format.

- **The `main()` function with `if __name__ == "__main__"`** — Keeping the full
  execution flow in one place and protecting it from running when the file is imported.

---

## What Was Difficult

The hardest part was managing the order in which things had to happen. It is easy to
write each function individually, but making sure validation runs before cleaning,
cleaning runs before `total_amount` is calculated, and calculation runs before
revenue is summed — all of that had to stay in the right sequence inside `main()`.
One wrong order and the numbers would be wrong or the script would crash. On top of
that, keeping the original `orders` list untouched while working on a cleaned copy
took careful thinking. Early on it felt like everything was connected to everything
else, and changing one piece could quietly break something three steps later. Getting
comfortable with that kind of dependency chain — where each step feeds the next — was
the real lesson of this sprint.

---

*Part of the Data Engineering Training — Week 2, Day 8.*
