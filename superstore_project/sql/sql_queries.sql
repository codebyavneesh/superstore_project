USE superStoreDB;

-- =====================================================================================================================
-- 1. Top 10 states identify karo jinhone sabse zyada revenue generate kiya hai. Saath me total orders, total profit aur average order value bhi dikhao.
-- =====================================================================================================================
SELECT  
    State,
    SUM(Quantity*Sales) AS revenue,
    COUNT(*) AS total_orders,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Quantity*Sales)/COUNT(*), 2) AS avg_order_value
FROM sales
GROUP BY State 
ORDER BY revenue DESC
LIMIT 10;

-- =====================================================================================================================
-- 2. Aise products identify karo jinka total sales positive hai lekin overall profit negative hai. Loss amount aur total quantity bhi show karo.
-- =====================================================================================================================
WITH product_report AS (
    SELECT
        Product_Name,
        SUM(Sales) AS total_sales,
        SUM(Quantity) AS total_quantity,
        COUNT(*) AS total_orders,
        ROUND(SUM(Profit), 2) AS total_profit
    FROM sales 
    GROUP BY Product_Name
)
SELECT
    Product_Name,
    total_sales,
    total_quantity,
    total_orders,
    ABS(total_profit) AS loss_amount
FROM product_report
WHERE total_sales>0 AND total_profit<0;

-- ============================================================
-- 3. Har customer ke liye calculate karo:
-- 
-- Total Orders
-- Total Revenue
-- Total Profit
-- Average Order Value
-- First Order Date
-- Last Order Date
-- Customer Lifetime (days)
-- Revenue ke basis par Top 20 customers dikhao.
-- ============================================================
WITH customer_report AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS revenue,
        COUNT(*) AS total_orders,
        ROUND(SUM(Sales)/COUNT(*), 2) AS avg_order_value,
        MIN(Order_Date) AS first_order_date,
        MAX(Order_Date) AS last_order_date,
        DATEDIFF(MAX(Order_Date), MIN(Order_Date)) AS customer_lifetime_days
    FROM sales 
    GROUP BY Customer_ID,
        Customer_Name
)

SELECT
    Customer_ID,
    Customer_Name,
    revenue,
    total_orders,
    avg_order_value,
    first_order_date,
    last_order_date,
    customer_lifetime_days
FROM customer_report
ORDER BY revenue DESC
LIMIT 20;

-- ============================================================
-- 4. Shipping Performance Analysis

-- Har Ship Mode ke liye calculate karo:

-- Average Shipping Days
-- Total Orders
-- Delayed Orders (>5 days)
-- Delay Percentage
-- ============================================================
SELECT
    Ship_Mode,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 2) AS avg_shipping_days,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN DATEDIFF(Ship_Date, Order_Date) > 5 THEN 1
            ELSE 0
        END
    ) AS delayed_orders,
    ROUND(
        SUM(
            CASE
                WHEN DATEDIFF(Ship_Date, Order_Date) > 5 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS delay_percentage
FROM sales 
GROUP BY Ship_Mode
ORDER BY delay_percentage DESC;

-- ==========================================
-- 5. Monthly Sales Trend
-- Har month ke liye calculate karo:
-- Revenue
-- Profit
-- Number of Orders
-- Previous Month Revenue
-- Revenue Growth %
-- Running Total Revenue
-- ==========================================
WITH monthly_revenue AS (
    SELECT
        Order_Month,
        SUM(Sales) AS revenue,
        ROUND(SUM(Profit),2) AS profit,
        COUNT(*) AS number_of_orders
    FROM sales
    GROUP BY Order_Month
),
report AS (
    SELECT
        *,
        LAG(revenue) OVER(ORDER BY Order_Month) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    Order_Month,
    revenue,
    profit,
    number_of_orders,
    previous_month_revenue,
    ROUND(
        (
            revenue - previous_month_revenue
        ) * 100.0
        / previous_month_revenue,
        2
    ) AS growth_percentage,
    SUM(revenue) OVER(ORDER BY Order_Month) AS running_total_revenue
FROM report;

-- ==========================================
-- 6. Category Contribution Analysis

-- Har Category ke liye calculate karo:
-- Revenue
-- Profit
-- Revenue %
-- Contribution
-- Profit % Contribution
-- ==========================================
WITH category_revenue AS (
    SELECT
        Category,
        SUM(Sales) AS revenue,
        ROUND(
            SUM(Profit),
            2
         ) AS profit
    FROM sales
    GROUP BY Category
),
report AS (
    SELECT
        Category,
        revenue,
        profit,
        ROUND(
            (
                revenue * 100.0
            ) / SUM(revenue) OVER(),
            2
        ) AS revenue_percentage,
        ROUND(
            (
                revenue * 100.0
            ) / SUM(revenue) OVER(),
            2
        ) AS revenue_contribution,
        ROUND(
            (
                profit * 100.0
            ) / SUM(profit) OVER(),
            2
        ) AS profit_contribution
    FROM category_revenue
)

SELECT
    Category,
    revenue,
    profit,
    revenue_percentage,
    revenue_contribution,
    profit_contribution
FROM report
ORDER BY revenue DESC;

-- ===========================================================================
-- 7. Top Products Within Each Category

-- Har Category ke andar revenue ke basis par Top 5 products identify karo.
-- ===========================================================================
WITH product_revenue AS (
    SELECT
        Category,
        Product_Name,
        SUM(Sales) AS revenue
    FROM sales
    GROUP BY Category,
            Product_Name
),
cat_in_prod AS (
    SELECT
        Category,
        Product_Name,
        revenue,
        ROW_NUMBER() OVER(PARTITION BY Category ORDER BY revenue DESC) AS top_products 
    FROM product_revenue
)

SELECT
    Category,
    Product_Name,
    revenue,
    top_products
FROM cat_in_prod
WHERE top_products <= 5
ORDER BY
    Category,
    top_products;

-- ===========================================================================
-- 8. High Discount Impact

-- Aise products identify karo:
-- Average Discount > Overall Average Discount
-- Profit Negative
-- ===========================================================================
WITH product_discount AS (
    SELECT
        Product_Name,
        ROUND(
            AVG(Discount),
            2
         ) AS avg_discount,
        ROUND(SUM(Profit), 2) AS profit
    FROM sales  
    GROUP BY Product_Name
),
discount_impact AS (
    SELECT
        Product_Name,
        avg_discount,
        ROUND(
            AVG(avg_discount) OVER(),
            2
         ) AS overall_avg_discount,
        profit
    FROM product_discount
)

SELECT
    Product_Name,
    avg_discount,
    overall_avg_discount,
    profit
FROM discount_impact
WHERE avg_discount>overall_avg_discount AND profit<0;

-- ==========================================
-- 9. Regional Performance Dashboard

-- Har Region ke liye calculate karo:
-- Revenue
-- Profit
-- Profit Margin %
-- Average Shipping Days
-- Distinct Customers
-- ==========================================
WITH region_revenue AS (
    SELECT
        Region,
        SUM(Sales) AS revenue,
        ROUND(
            SUM(Profit),
            2
         ) AS profit,
        ROUND(
            AVG(
                DATEDIFF(Ship_Date, Order_Date)
            ),
            2
        ) AS avg_shipping_days,
        COUNT(DISTINCT Customer_ID) AS distinct_customers
    FROM sales 
    GROUP BY Region
),
report AS (
    SELECT
        *,
        ROUND(
            (profit * 100.0) / revenue
        ) AS profit_margin_percentage
    FROM region_revenue
)
SELECT
    Region,
    revenue,
    profit,
    profit_margin_percentage,
    avg_shipping_days,
    distinct_customers
FROM report
ORDER BY revenue DESC;

-- ==================================================
-- 10. Repeat Customer Analysis

-- Sirf un customers ko show karo:
-- Jinhone 5 ya usse zyada orders kiye hain.
-- Average Order Value overall average se zyada ho.
-- Profit positive ho.
-- ==================================================
WITH customer_revenue AS (
    SELECT  
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS total_revenue,
        COUNT(DISTINCT Order_ID) AS total_orders,
        ROUND(
            SUM(Sales) / COUNT(DISTINCT Order_ID),
            2
        ) AS avg_order_value,
        ROUND(
            SUM(Profit),
            2
        ) AS profit
    FROM sales 
    GROUP BY Customer_ID,
        Customer_Name
),
report AS(
    SELECT
        *,
        ROUND(
            AVG(avg_order_value) OVER(),
            2
        ) AS overall_average_value
    FROM customer_revenue
)

SELECT
    Customer_ID,
    Customer_Name,
    total_revenue,
    total_orders,
    avg_order_value,
    profit,
    overall_average_value
FROM report
WHERE avg_order_value > overall_average_value AND profit > 0;

-- ===============================================================================================
-- 11. Pareto Analysis (80/20 Rule)

-- Identify karo ki kaun se products total revenue ka approximately 80% contribute karte hain.
-- ===============================================================================================
WITH product_revenue AS (
    SELECT
        Product_Name,
        SUM(Sales) AS revenue
    FROM sales 
    GROUP BY Product_Name
),
product_running_revenue AS (
    SELECT
        Product_Name,
        revenue,
        SUM(revenue) OVER(ORDER BY revenue DESC) AS running_revenue,
        SUM(revenue) OVER() AS total_revenue,
        ROUND(
            (
                SUM(revenue) OVER(ORDER BY revenue DESC) * 100.0
            ) / SUM(revenue) OVER(),
            2
        ) AS revenue_percentage
    FROM product_revenue
)

SELECT
    Product_Name,
    revenue,
    running_revenue,
    total_revenue,
    revenue_percentage
FROM product_running_revenue
WHERE revenue_percentage<=80;

-- ==================================================
-- 12. Year-over-Year Sales Growth

-- Har Year ke liye calculate karo:
-- Revenue
-- Previous Year Revenue
-- Growth %
-- Profit Growth %
-- ==================================================
WITH order_year_revenue AS (
    SELECT
        Order_Year,
        SUM(Sales) AS revenue,
        ROUND(
            SUM(Profit),
            2
         ) AS profit
    FROM sales 
    GROUP BY Order_Year
),
report AS (
    SELECT
        Order_Year,
        revenue,
        LAG(revenue) OVER(ORDER BY Order_Year) AS previous_year_revenue,
        ROUND(
            (
                revenue - LAG(revenue) OVER(ORDER BY Order_Year)
            ) * 100.0 / LAG(revenue) OVER(ORDER BY Order_Year),
            2
        ) AS growth_percentage,
        LAG(profit) OVER(ORDER BY Order_Year) AS previous_year_profit,
        ROUND(
            (
                profit - LAG(profit) OVER(ORDER BY Order_Year)
            ) * 100.0 / LAG(profit) OVER(ORDER BY Order_Year),
            2
        ) AS profit_growth_percentage
    FROM order_year_revenue
)

SELECT
    Order_Year,
    revenue,
    previous_year_revenue,
    previous_year_profit,
    growth_percentage,
    profit_growth_percentage
FROM report;

-- =================================================================================
-- 13. Profit Margin Ranking

-- Har Category ke andar products ko Profit Margin (%) ke basis par rank karo.
-- =================================================================================
WITH product_profit AS (
    SELECT
        Category,
        Product_Name,
        SUM(Sales) AS total_revenue,
        ROUND(
            SUM(Profit),
            2
         ) AS total_profit
    FROM sales 
    GROUP BY Category,
            Product_Name
),
profit_margin AS(
    SELECT  
        Category,
        Product_Name,
        total_revenue,
        total_profit,
        ROUND(
            (
                total_profit
            ) * 100.0 / total_revenue,
            2
        ) AS profit_margin
    FROM product_profit
)
SELECT
    Category,
    Product_Name,
    total_revenue,
    total_profit,
    profit_margin,
    RANK() OVER(PARTITION BY Category ORDER BY profit_margin DESC) AS rnk 
FROM profit_margin;

-- ===========================================================================
-- 14. State-wise Best Selling Category

-- Har State me kaunsi Category sabse zyada revenue generate karti hai?
-- Sirf highest revenue category return karo.
-- ===========================================================================
WITH state_wise_best_selling_category AS (
    SELECT
        State,
        Category,
        SUM(Sales) AS revenue
    FROM sales 
    GROUP BY State,
            Category
),
highest_revenue AS(
    SELECT
        State,
        Category,
        revenue,
        ROW_NUMBER() OVER(PARTITION BY State ORDER BY revenue DESC) AS rnk 
    FROM state_wise_best_selling_category
)

SELECT
    State,
    Category,
    revenue,
    rnk 
FROM highest_revenue
WHERE rnk=1;

-- ============================================
-- 15. Order Size Analysis

-- Orders ko classify karo:
-- Small
-- Medium
-- Large

-- Sales amount ke basis par.

-- Phir har category ka:
-- Order Count
-- Revenue
-- Profit
-- Average Shipping Days
-- ============================================
WITH order_revenue AS (
    SELECT 
        Order_ID,
        SUM(Sales) AS revenue,
        ROUND(
            SUM(Profit),
            2
         ) AS total_profit,
        ROUND(
            AVG(
                DATEDIFF(Ship_Date, Order_Date)
            ),
            2
        ) AS avg_shipping_day
    FROM sales 
    GROUP BY Order_ID
),
orders_segment AS (
    SELECT
        Order_ID,
        revenue,
        CASE 
            WHEN revenue > 1000 THEN 'Large'
            WHEN revenue > 500 THEN 'Medium'
            ELSE 'Small'
        END AS order_segment,
        total_profit,
        avg_shipping_day
    FROM order_revenue
),
segment_report AS (
    SELECT
        order_segment,
        COUNT(*) AS order_count,
        SUM(revenue) AS total_revenue,
        SUM(total_profit) AS total_profit,
        ROUND(
            AVG(avg_shipping_day),
            2
        ) AS avg_shipping_days
    FROM orders_segment
    GROUP BY order_segment
)

SELECT
    order_segment,
    order_count,
    total_revenue,
    total_profit,
    avg_shipping_days
FROM segment_report;

-- ====================================================================================
-- 16. Customer Purchase Gap

-- Har customer ke consecutive orders ke beech kitne din ka gap hai calculate karo.
-- Fir identify karo:
-- Customers jinka average purchase gap 60 days se zyada hai.
-- ====================================================================================
WITH consecutive_orders AS (
    SELECT DISTINCT
        Customer_ID,
        Customer_Name,
        Order_Date
    FROM sales 
),
day_gap AS (
    SELECT
        Customer_ID,
        Customer_Name,
        Order_Date,
        LAG(Order_Date) OVER(PARTITION BY Customer_ID ORDER BY Order_Date) AS previous_order_date,
        DATEDIFF(Order_Date, LAG(Order_Date) OVER(PARTITION BY Customer_ID ORDER BY Order_Date)) AS gap 
    FROM consecutive_orders
),
avg_gap_day AS (
    SELECT
        Customer_ID,
        Customer_Name,
        ROUND(
            AVG(gap),
            2
        ) AS avg_gap_days
    FROM day_gap
    GROUP BY Customer_ID,
        Customer_Name
)

SELECT
    Customer_ID,
    Customer_Name,
    avg_gap_days
FROM avg_gap_day
WHERE avg_gap_days > 60;

-- ============================================
-- 17. Revenue Concentration

-- Top 10 customers total revenue ka kitna percentage contribute karte hain?
-- ============================================
WITH top_10_customers AS (
    SELECT 
        SUM(revenue) AS top_10_revenue
    FROM
    (
        SELECT
            Customer_ID,
            SUM(Sales) AS revenue
        FROM sales 
        GROUP BY Customer_ID
        ORDER BY revenue DESC 
        LIMIT 10
    ) AS x 
)
SELECT
    ROUND(
        (
            top_10_revenue * 100.0
        ) / (
                SELECT SUM(Sales) FROM sales
            ),
        2
    )
FROM top_10_customers;

-- ============================================
-- 18. Consistently Loss-Making States

-- Aise States identify karo:
-- Jahan har year profit negative raha ho.
-- Total Revenue bhi show karo.
-- ============================================
WITH year_wise_profit AS (
    SELECT
        State,
        Order_Year,
        SUM(Sales) AS revenue,
        SUM(Profit) AS total_profit
    FROM sales
    GROUP BY
        State,
        Order_Year
)

SELECT
    State,
    SUM(revenue) AS total_revenue,
    ROUND(
        total_profit,
        2
    ) AS total_profit
FROM year_wise_profit
GROUP BY State
HAVING MAX(total_profit) < 0;

-- ================================================
-- 19. Discount Effectiveness

-- Discount Category ke hisab se compare karo:
-- Revenue
-- Profit
-- Profit Margin
-- Average Quantity
-- Order Count
-- ================================================
WITH discount_effectiveness AS (
    SELECT
        Discount_Category,
        SUM(Sales) AS revenue,
        ROUND(
            SUM(Profit),
            2
        ) AS profit,
        ROUND(
            AVG(Quantity),
            2
        ) AS avg_qty,
        COUNT(*) AS total_orders
    FROM sales 
    GROUP BY Discount_Category
)
SELECT
    Discount_Category,
    revenue,
    profit,
    avg_qty,
    total_orders,
    ROUND(
        (
            profit
        ) * 100.0 / revenue,
        2
    ) AS profit_margin
FROM discount_effectiveness;

-- =============================================================
-- 20. Executive Business Report

-- Ek final SQL query banao jo har Region ke liye ye KPIs de:
-- Revenue
-- Profit
-- Profit Margin %
-- Distinct Customers
-- Distinct Products
-- Average Shipping Days
-- Top Selling Category
-- Top Performing State
-- ==============================================================
WITH region_kpi AS (
    SELECT
        Region,
        SUM(Sales) AS revenue,
        ROUND(
            SUM(Profit),
            2
        ) AS profit,
        ROUND(
            (
                SUM(Profit)
            ) * 100.0 / SUM(Sales),
            2
        ) AS profit_margin,
        COUNT(DISTINCT Customer_ID) AS distinct_customers,
        COUNT(DISTINCT Product_ID) AS distinct_products,
        ROUND(
            AVG(Shipping_Days),
            2
        ) AS avg_shipping_days
    FROM sales 
    GROUP BY Region
),
top_selling_category AS (
    SELECT 
        Region,
        Category,
        rn 
    FROM
    (
        SELECT
            Region,
            Category,
            ROW_NUMBER() OVER(PARTITION BY Region ORDER BY revenue DESC) AS rn 
        FROM
        (
            SELECT
                Region,
                Category,
                SUM(Sales) AS revenue
            FROM sales 
            GROUP BY Region,
                Category
        ) AS t
    ) AS x 
    WHERE rn=1
),
top_performing_state AS (
    SELECT 
        Region,
        State,
        rnk 
    FROM
    (
        SELECT 
            Region,
            State,
            ROW_NUMBER() OVER(PARTITION BY Region ORDER BY revenue DESC) AS rnk 
        FROM
        (
            SELECT 
                Region,
                State,
                SUM(Sales) AS revenue
            FROM sales 
            GROUP BY Region,
                State
        ) AS t
    ) AS x
    WHERE rnk=1
)

SELECT
    rk.Region,
    rk.revenue,
    rk.profit,
    rk.profit_margin,
    rk.distinct_customers,
    rk.distinct_products,
    rk.avg_shipping_days,
    tsc.Category,
    tsc.rn,
    tps.State,
    tps.rnk
FROM region_kpi rk 
JOIN top_selling_category tsc 
ON rk.Region=tsc.Region 
JOIN top_performing_state tps 
ON tsc.Region=tps.Region  