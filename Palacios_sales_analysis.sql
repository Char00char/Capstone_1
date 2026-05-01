-- Northeast, Michael Jarvis, Massachusetts, Bo Heap 
-- My sales mananger, Bo Heap, asked me a series of question in order to analyze the data for the Massachusetts sales territory which is within the Northeast region

USE sample_sales;

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?
SELECT ROUND(SUM(ss.Sale_Amount), 2) AS "Total Revenue", MIN(ss.Transaction_Date) AS "Start Date" , MAX(ss.Transaction_Date) AS "End Date" 
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreId
WHERE sl.State = "Massachusetts"; 

-- What is the month by month revenue breakdown for the sales territory?
SELECT DATE_FORMAT(ss.Transaction_Date, '%m/%Y') AS "Date", ROUND(SUM(ss.Sale_Amount), 2) AS "Total Revenue"
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreId
WHERE sl.State = "Massachusetts"
GROUP BY 1
ORDER BY "Date";

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
SELECT * 
FROM
(
SELECT ROUND(SUM(Sale_Amount), 2) AS "Massachusetts Total Revenue"
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreId
WHERE sl.State = "Massachusetts"
) m
CROSS JOIN
(
SELECT ROUND(SUM(ss.Sale_Amount), 2) AS "Northeastern Total Revenue"
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreId
JOIN management mng
ON sl.State = mng.State
WHERE mng.Region = "Northeast"
) n;

-- What is the number of transactions per month and average transaction size by product category for the sales territory?
SELECT DATE_FORMAT(ss.Transaction_Date, '%Y/%m') AS "Date", COUNT(*) AS "Number of Transactions", ROUND(AVG(ss.Sale_Amount), 2) AS "Average Transaction Size", ic.Category
FROM store_sales ss
JOIN products p
ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
ON p.Categoryid = ic.Categoryid
JOIN store_locations sl
ON ss.Store_ID = sl.StoreId
WHERE sl.State = "Massachusetts"
GROUP BY DATE_FORMAT(ss.Transaction_Date, '%Y/%m') , ic.Category
ORDER BY DATE_FORMAT(ss.Transaction_Date, '%Y/%m'), ic.Category;

-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
SELECT sl.StoreID AS "Store ID", sl.StoreLocation AS "Store Location", ROUND(SUM(ss.Sale_Amount), 2) AS "Total Revenue"
FROM store_locations sl
JOIN store_sales ss
ON sl.StoreID = ss.Store_ID
WHERE sl.State = "Massachusetts"
GROUP BY sl.StoreID
ORDER BY 3 DESC;

-- What is your recommendation for where to focus sales attention in the next quarter?
-- I would recommend focusing on why Worcester (Store 817) is so far ahead compared to the other stores. They have $250k more revenue than the 2nd top performing store, which is an issue. The other stores are close in terms of revenue so I believe if we figure out why Worcester is so far ahead, we can close that $250k gap. Whether it be market conditions, product mix, or execution at the store level, Worchester is making it happen. We need our other stores to follow in their footsteps and get on the same level if we want to see growth in the next quarter.