# Part 9 – Logic Explanations

---

## 1. Why Validation Happens Before Revenue Calculation

Validation runs first because revenue is a number that has to be trusted.
If you skip validation and jump straight into calculating revenue, bad data
sneaks into your result and nobody knows it.

Here is a real example from the dataset. Order 18 has a quantity of `-1`.
If you multiply that by the price, you get a **negative number**. That number
gets added to the revenue total, which means the total goes *down* instead of up.
That is not a data error that stays hidden - it quietly corrupts the final number
that a business might use to make decisions.

Order 17 has a quantity of `0` and Order 20 has a price of `0`. Both of these
produce a `total_amount` of `0`. They do not break the calculation, but they are
meaningless records - there was no real transaction. Including them in averages
and counts gives you wrong statistics.

The rule is simple: **validate first, calculate second**. Only after the bad records
are separated do you run `clean_order()` on the clean ones. This way every
number in the report has a clean foundation underneath it.

---

## 2. How Status Normalization Works

The raw dataset had three different ways of writing the same thing:

| Raw value   | Meaning        |
|-------------|----------------|
| `Completed` | Order finished |
| `complete`  | Order finished |
| `completed` | Order finished |

These are the same status written three different ways. If you leave them as they
are, a loop looking for `"completed"` will miss the orders that say `"Completed"`
or `"complete"`, so they never get counted as revenue.

The fix is defined in `normalize_status()` and applied during cleaning inside `clean_order()`:

```python
def normalize_status(status):
    if status in ["Completed", "complete", "completed"]:
        return "completed"
    return status
```

This checks the status string of each order. The moment it finds a status that says
`"Completed"` or `"complete"`, it returns the lowercase `"completed"`.
After this step runs on all records, all three variations are gone and only `"completed"` exists.
Every other piece of code that checks for completed orders now works correctly
because there is only one version of the word to look for.

The same pattern is used for the other fields too:
- `normalize_city(city)` maps `"Prishtine"` to `"Prishtina"`.
- `normalize_category(category)` maps `"accessories"` to `"Accessories"`.
- `normalize_channel(channel)` maps `"Online"` to `"online"`.

Each normalization is isolated in its own helper function, making them reusable and easy to test.

---

## 3. Why Only Completed Orders Count as Revenue

Revenue means money that was actually received. An order can exist in the system
without money ever changing hands. Here is what each non-completed status means
in real life:

- **pending** — The customer placed the order but payment has not been confirmed yet. You do not have the money.
- **cancelled** — The order was called off before it shipped. Nothing was sold.
- **returned** — The product was sent back. You may have refunded the money.

Counting any of these as revenue would be a lie. Imagine a sales report that says
the company made 50,000 this month, but 15,000 of that is from pending orders
that might never pay and returned orders that already got refunded. The business
thinks it has more money than it does and makes decisions based on that wrong number.

The code enforces this with a single condition inside `get_completed_orders()`:

```python
for order in clean_orders:
    if order["status"] == "completed":
        completed.append(order)
```

Only when the status is exactly `"completed"` does the order get added to
completed orders. Everything else is excluded from the revenue total. This is
not just a technical choice — it is the only definition of revenue that makes
real-world sense.

---

## 4. How count_by_field Works Step by Step

The function is defined as `count_by_field(records, field_name)`. It accepts a list
of orders, and the name of a field you want to count by (for example `"status"` or `"city"`).

```python
def count_by_field(records, field_name):
    counts = {}

    for order in records:
        value = order[field_name]

        if value not in counts:
            counts[value] = 0

        counts[value] += 1

    return counts
```

Here is exactly what happens, one step at a time:

**Step 1 - Start with an empty dictionary.**
`counts = {}` creates a blank dictionary. Nothing is in it yet. This dictionary
will fill up as the loop runs.

**Step 2 - Loop through every order.**
The `for` loop picks up each order one at a time from the list.

**Step 3 - Read the value for the chosen field.**
`value = order[field_name]` looks inside the current order and pulls out the
value for whichever field was requested. If `field_name` is `"status"`, it
reads `order["status"]` and gets something like `"completed"`.

**Step 4 - Check if this value already exists in the dictionary.**
`if value not in counts` asks: have we seen this value before?
- If **no** - it runs `counts[value] = 0` to add a brand new entry with a starting count of zero.
- If **yes** - it skips that line entirely because the key already exists.

**Step 5 - Add 1 to the count.**
`counts[value] += 1` always runs after step 4. It adds 1 to whatever number
is stored under that value.

**Step 6 - Return the finished dictionary.**
Once every order has been processed, the function returns the dictionary.

**Example in action:**
If three orders have status `"completed"` and two have `"pending"`, the result is:
```python
{"completed": 3, "pending": 2}
```

---

## 5. How sum_revenue_by_field Works Step by Step

This function groups completed revenue by a chosen field.

```python
def sum_revenue_by_field(records, field_name):
    revenues = {}

    for order in records:
        if order.get("status") == "completed":
            value = order.get(field_name)
            revenue = order.get("total_amount")

            if revenue is None:
                continue

            if value not in revenues:
                revenues[value] = 0

            revenues[value] += revenue

    return revenues
```

**Step 1 - Start with an empty dictionary.**
`revenues = {}` will hold each group name as a key and the running revenue total as the value.

**Step 2 - Loop through every order.**
The `for` loop goes through all records in the list.

**Step 3 - Gate: only proceed if the order is completed.**
`if order.get("status") == "completed"` acts as a filter. If the status is anything
else, Python skips the rest of the block and moves to the next order.

**Step 4 - Read the field value and the revenue.**
`value = order.get(field_name)` pulls the group key (e.g. city name like `"Prishtina"`).
`revenue = order.get("total_amount")` reads the pre-calculated total for that order.

**Step 5 - Skip if revenue is missing.**
`if revenue is None: continue` handles orders where `total_amount` was never set.
`continue` tells Python to skip this order and move on to the next one immediately.

**Step 6 - Create the group key if it is new.**
`if value not in revenues: revenues[value] = 0` works exactly like in `count_by_field`.
First time a city appears, it gets a zero balance. After that, it already exists.

**Step 7 - Add the revenue to the group total.**
`revenues[value] += revenue` adds the current order's amount to the running total
for that group.

**Step 8 - Return the finished dictionary.**
The result might look like: `{"Prishtina": 849, "Vushtrri": 790}`.

---

## 6. How Sorting Is Used to Find Top Records

Sorting puts all the data in order from biggest to smallest, and then the top
records are just the ones at the front of the list.

**For top orders** — `get_top_orders_by_total_amount()`:

```python
completed_orders.sort(
    key=lambda order: order["total_amount"],
    reverse=True
)
return completed_orders[:limit]
```

The `.sort()` method rearranges the list in place. The `key=lambda order: order["total_amount"]`
part tells it what to sort by — in this case, the `total_amount` of each order.
`reverse=True` flips the order so the highest amount comes first.
After sorting, `[:limit]` takes only the first `limit` items from the front of the list.

**For top groups by revenue** — inside helper functions:

```python
sorted_groups = sorted(
    grouped_revenue.values(),
    key=lambda item: item["revenue"],
    reverse=True
)
return sorted_groups[:3]
```

Here `sorted()` works the same way but returns a new list instead of modifying
the original. Each item in `grouped_revenue` is a dictionary with `"name"` and
`"revenue"` keys. The sort compares the `"revenue"` values and puts the highest
at the front. Then `[:3]` grabs the first three.

The core logic is the same in both cases: sort high-to-low, then slice from the front.
Python's sort is reliable and very readable with the `key=` argument.

---

## 7. What main() Does and Why It Improves Script Structure

`main()` is the function that calls all the other functions in the correct order.
Without it, all that code would sit at the top level of the file with nothing organizing it.

Here is why having `main()` matters:

**It gives the script a clear starting point.**
Every function in this file does one specific thing. `main()` is the one function
that knows the full sequence — run validation first, write validation reports,
clean records, print metrics, run dynamic aggregations, and write the business report.
Without it, that order would be scattered across the file and hard to follow.

**It separates definition from execution.**
Every function above `main()` just defines what to do. None of them run automatically
when the file loads. `main()` is the one place where things actually run. This means
you can import this file in another script and use the individual functions without
accidentally triggering the whole analysis.

**The `if __name__ == "__main__"` guard** is the final piece:

```python
if __name__ == "__main__":
    main()
```

This line checks whether the file is being run directly by the user. If yes,
it calls `main()`. If this file is imported by another script, this block is
skipped entirely. It is a standard Python convention that makes scripts safe
to reuse as modules.

**It makes debugging easier.**
If something breaks, you can comment out one function call in `main()` and
the rest still works. Every part of the pipeline is isolated.

---

## 8. Deep Dive: How the Code Calculates Total Completed Revenue

The metric chosen is **Total Completed Revenue**, which is computed using
`calculate_completed_revenue()` and appears in the terminal and in the business report.

Here is the exact sequence the code follows, traced from raw data to final number:

### Step 1 - Validation filters out bad records

`split_valid_and_invalid_orders()` calls `validate_order()` for each raw record
to separate empty names, zero/negative quantities, and zero/negative prices.
This isolates the 4 invalid records.

### Step 2 - Cleaning produces a safe working copy

For each valid record, `clean_order()` creates a copy using `.copy()`.
This ensures the raw dataset imported from `order_data.py` remains unmodified.

### Step 3 - Normalization fixes inconsistent values

Inside `clean_order()`, status values are normalized via `normalize_status()`
(converting variations like `"Completed"` and `"complete"` to `"completed"`).
Spelling corrections for cities, categories, and channels are also applied.

### Step 4 - total_amount is calculated for each clean order

Inside `clean_order()`, `calculate_total_amount()` is called to set the
`"total_amount"` field as:

```python
order["total_amount"] = order["quantity"] * order["price"]
```

If quantity or price is missing (set to `None` due to invalid input),
`total_amount` is set to `None` to prevent calculation errors.

### Step 5 - Completed orders are filtered and summed

`calculate_completed_revenue()` is called with the list of clean valid orders.
It runs `get_completed_orders()` to isolate records where `status` is exactly
`"completed"`, then loops through them to add up their `"total_amount"` values:

```python
revenue = 0
for order in completed:
    val = order.get("total_amount")
    if val is not None:
        revenue += val
```

This ensures only completed, valid, and fully-cleaned transactions contribute
to the revenue total.

### Step 6 - The result is printed and written to the report

The final metric of `2764` is printed to the terminal and written into
`output/business_report.txt` by `write_business_report()`.

---

*Written for Part 9 of the data engineering training sprint.*
