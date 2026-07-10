# Presentation Notes

Group: 1

Students: Urim Avdiu and Ensar Aliu

---

**1. What dataset did we analyze?**

We analyzed a dataset of 15 customer orders from different cities in Kosovo. Each order had information like the customer name, the city they are from, the product they ordered, the category, the quantity, the price, the status of the order, and the date. We built the dataset ourselves by creating a CSV file and a SQL table with real-looking order data.

---

**2. What did we do in Python?**

Urim worked on the Python part. He wrote a script that reads the orders from a CSV file and answers business questions using code. The script counts the total number of orders, filters only completed ones, calculates the total revenue, finds the most expensive product by price and by total value, and counts orders by city and category. Everything was done using loops, conditions, and dictionaries.

---

**3. What did we do in SQL?**

Ensar worked on the SQL part. He wrote queries to answer the same business questions using a database. He used WHERE to filter orders by status, SUM to calculate total revenue, GROUP BY to count orders by city and category, and ORDER BY with LIMIT to find the top orders. SQL made it possible to get answers in just a few lines instead of writing long code.

---

**4. What was our most important business insight?**

The most important insight is that only 3,950 EUR out of a possible 5,235 EUR was confirmed revenue. That means 1,285 EUR is either still uncertain or already lost because of pending, processing, and cancelled orders. The business needs to pay attention to why orders are being cancelled and follow up on the ones that are still pending.

---

**5. What was difficult?**

In Python, the hardest part was sorting the orders to find the most valuable one, because we had to compare values manually using loops without any built-in sorting shortcuts. In SQL, the hardest part was understanding when to use GROUP BY and how to combine it with COUNT correctly.

---

**6. What would we improve if we had more time?**

If we had more time we would add more orders to the dataset to make it more realistic. We would also look at trends over time, for example which days had the most sales, and which products are getting cancelled the most. That kind of information would help a business make better decisions every week.

---

Speaker 1 - Urim Avdiu will explain:

Urim will present the Python analysis. He will explain how the script works, how he loaded the CSV file, how he used loops to go through each order, and what results came out of the Python code. He will also explain the difference between the most expensive order by unit price and the most valuable order by total amount.

---

Speaker 2 - Ensar Aliu will explain:

Ensar will present the SQL analysis and the business insights. He will explain how the SQL queries answered the same questions as Python but in a simpler way. He will then walk through the most important business insight about confirmed versus potential revenue, and give the business recommendation about focusing on Electronics and following up on pending orders.
