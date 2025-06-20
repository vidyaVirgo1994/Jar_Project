CREATE TABLE table1
     (
       Month_of_order_date  DATE,
       Catogory             VARCHAR(20),
       Target               INT
     );
SELECT * FROM table1

---

CREATE TABLE table2
     (
       Order_ID	     VARCHAR(20),
	   Amount	     INT,
	   Profit        INT,
	   Quantity	     INT,
	   Category      VARCHAR(20),
	   Sub_Category  VARCHAR(20)
      );  
SELECT * FROM table2

---

CREATE TABLE table3
       (
          Order_ID        VARCHAR(20),
		  Order_date      DATE,
		  CustomerName    VARCHAR(30),
		  state           VARCHAR(30),
		  City            VARCHAR(30)
	    );
SELECT * FROM table3

---

/* Q1: Sales Analysis:
Part1: Sales and Profitability Analysis
        Merge the List of Orders and Order Details datasets on the basis of Order ID.
        Calculate the total sales (Amount) for each category across all orders. */

SELECT 
    o.category,
    SUM(o.amount) AS total_sales
FROM 
    table2 o
JOIN 
    table3 od
    ON o.order_id = od.order_id
GROUP BY 
    o.category
ORDER BY 
    total_sales DESC;

/* For each category, calculate the average profit per order and total profit margin
  (profit as a percentage of Amount). */

SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS total_orders,
    AVG(Profit) AS avg_profit_per_order,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Amount), 0), 2) AS total_profit_margin_percent
FROM
    table2
GROUP BY
    Category
ORDER BY
    Category;

/*Identify the top-performing and underperforming categories based on these
metrics. Also, suggest reasons for their performance differences.*/

SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS total_orders,
    AVG(Profit) AS avg_profit_per_order,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Amount), 0), 2) AS total_profit_margin_percent
FROM
    table2
GROUP BY
    Category
ORDER BY
    avg_profit_per_order DESC;


/*Part 2: Target Achievement Analysis
Using the Sales Target dataset, calculate the percentage change in target sales
for the Furniture category month-over-month.*/

SELECT
    Month_of_order_date,
    Target AS current_month_target,
    LAG(Target) OVER (ORDER BY Month_of_order_date) AS previous_month_target,
    ROUND(
        (Target - LAG(Target) OVER (ORDER BY Month_of_order_date)) * 100.0 /
        NULLIF(LAG(Target) OVER (ORDER BY Month_of_order_date), 0), 2
    ) AS percentage_change
FROM
    table1
WHERE
    Catogory = 'Furniture'
ORDER BY
    Month_of_order_date;


/*Analyse the trends to identify months with significant target fluctuations.
Suggest strategies for aligning target expectations with actual performance
trends.*/

SELECT
    Month_of_order_date,
    Target AS current_target,
    LAG(Target) OVER (ORDER BY Month_of_order_date) AS previous_target,
    ROUND(
        (Target - LAG(Target) OVER (ORDER BY Month_of_order_date)) * 100.0 /
        NULLIF(LAG(Target) OVER (ORDER BY Month_of_order_date), 0), 2
    ) AS percentage_change
FROM
    table1
WHERE
    Catogory = 'Furniture'
ORDER BY
    Month_of_order_date;	


/*Part 3: Regional Performance Insights
From the List of Orders dataset, identify the top 5 states with the highest order
count. For each of these states, calculate the total sales and average profit. */

SELECT
	t3.state ,
    COUNT(DISTINCT t3.order_id) AS order_count,
    SUM(t2.amount) AS total_sales,
    ROUND(AVG(t2.profit), 2) AS avg_profit
FROM
    table3 t3
JOIN
    table2 t2
    ON t3.order_id = t2.order_id
GROUP BY
    t3.state
ORDER BY
    order_count DESC
LIMIT 5;

/* Highlight any regional disparities in sales or profitability. Suggest regions or cities
that should be prioritized for improvement. */

SELECT
    t3.city,
    COUNT(DISTINCT t3.order_id) AS order_count,
    SUM(t2.amount) AS total_sales,
    ROUND(AVG(t2.profit), 2) AS avg_profit
FROM
    table3 t3
JOIN
    table2 t2
    ON t3.order_id = t2.order_id
GROUP BY
    t3.city
ORDER BY
    total_sales ASC  