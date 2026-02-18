-- =============================================
-- SALES PERFORMANCE ANALYSIS
-- =============================================

-- Create Sales Table
CREATE TABLE sales (
    transaction_id   INT PRIMARY KEY,
    sale_date        DATE,
    customer_id      INT,
    region           VARCHAR(50),
    product_category VARCHAR(50),
    revenue          DECIMAL(10,2),
    units_sold       INT
);


-- 1. YoY GROWTH BY REGION

WITH yearly_revenue AS (
    SELECT
        region,
        YEAR(sale_date)                        AS sale_year,
        SUM(revenue)                           AS total_revenue
    FROM sales
    GROUP BY region, YEAR(sale_date)
)
SELECT
    curr.region,
    curr.sale_year,
    curr.total_revenue                         AS current_revenue,
    prev.total_revenue                         AS previous_revenue,
    ROUND(
        (curr.total_revenue - prev.total_revenue) 
        / prev.total_revenue * 100, 2
    )                                          AS yoy_growth_pct
FROM yearly_revenue curr
LEFT JOIN yearly_revenue prev
    ON curr.region = prev.region
    AND curr.sale_year = prev.sale_year + 1
ORDER BY curr.region, curr.sale_year;


-- =============================================
-- 2. 3-MONTH MOVING AVERAGE BY PRODUCT CATEGORY
-- =============================================
WITH monthly_revenue AS (
    SELECT
        product_category,
        DATE_FORMAT(sale_date, '%Y-%m')        AS sale_month,
        SUM(revenue)                           AS total_revenue
    FROM sales
    GROUP BY product_category, DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    product_category,
    sale_month,
    total_revenue,
    ROUND(
        AVG(total_revenue) OVER (
            PARTITION BY product_category
            ORDER BY sale_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    )                                          AS moving_avg_3m
FROM monthly_revenue
ORDER BY product_category, sale_month;


-- =============================================
-- 3. CUSTOMER RETENTION RATE
-- =============================================
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(YEAR(sale_date))                   AS first_year
    FROM sales
    GROUP BY customer_id
),
returning_customers AS (
    SELECT
        f.first_year,
        COUNT(DISTINCT s.customer_id)          AS retained_customers
    FROM first_purchase f
    JOIN sales s
        ON f.customer_id = s.customer_id
        AND YEAR(s.sale_date) = f.first_year + 1
    GROUP BY f.first_year
),
total_customers AS (
    SELECT
        first_year,
        COUNT(DISTINCT customer_id)            AS total_customers
    FROM first_purchase
    GROUP BY first_year
)
SELECT
    t.first_year,
    t.total_customers,
    r.retained_customers,
    ROUND(
        r.retained_customers / t.total_customers * 100, 2
    )                                          AS retention_rate_pct
FROM total_customers t
LEFT JOIN returning_customers r
    ON t.first_year = r.first_year
ORDER BY t.first_year;


-- =============================================
-- 4. UNDERPERFORMING REGIONS (BELOW AVG REVENUE)
-- =============================================
WITH region_revenue AS (
    SELECT
        region,
        SUM(revenue)                           AS total_revenue
    FROM sales
    GROUP BY region
)
SELECT
    region,
    total_revenue,
    ROUND(AVG(total_revenue) OVER (), 2)       AS avg_revenue,
    ROUND(
        total_revenue - AVG(total_revenue) OVER (), 2
    )                                          AS variance_from_avg
FROM region_revenue
ORDER BY total_revenue ASC;


-- =============================================
-- 5. STORED PROCEDURE — MONTHLY KPI REPORT
-- =============================================
DELIMITER $$

CREATE PROCEDURE GetMonthlyKPIReport(IN report_year INT)
BEGIN
    SELECT
        region,
        product_category,
        MONTH(sale_date)                       AS sale_month,
        SUM(revenue)                           AS total_revenue,
        SUM(units_sold)                        AS total_units,
        COUNT(DISTINCT customer_id)            AS unique_customers,
        ROUND(SUM(revenue) / SUM(units_sold), 2) AS avg_revenue_per_unit
    FROM sales
    WHERE YEAR(sale_date) = report_year
    GROUP BY region, product_category, MONTH(sale_date)
    ORDER BY sale_month, region, product_category;
END$$

DELIMITER ;

-- Call the procedure
CALL GetMonthlyKPIReport(2025);
