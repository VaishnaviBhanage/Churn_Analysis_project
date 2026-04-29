SELECT TOP 5 * FROM saas.customer_churn

GO
CREATE VIEW Overview AS(
SELECT COUNT(customer_id) AS Total_Customers,
SUM(CASE WHEN churned = 0 THEN 1 ELSE 0 END) AS Active_Users,
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS Churned_Users,
ROUND(CAST(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END )AS float)/COUNT(*)*100,2) AS Churn_Rate,
ROUND(SUM(effective_mrr),2) AS Total_Revenue,
ROUND(SUM(CASE WHEN churned = 1 THEN effective_mrr ELSE 0 END),2) AS Revenue_Lost,
ROUND(AVG(effective_mrr),2) AS ARPU
FROM saas.customer_churn)
 
 GO
 CREATE VIEW Monthly_Trend AS(
SELECT DATETRUNC(MONTH , churn_date) AS Month,
ROUND(SUM(effective_mrr),2) AS MRR_Trend,
COUNT(*) AS Churn FROM saas.customer_churn
WHERE churned = 1
GROUP BY DATETRUNC(MONTH , churn_date))

GO
CREATE VIEW New_vs_ChurnedUsers AS(
SELECT Month,
SUM(New_Users)AS New_Customers,
SUM(Churned_Users) AS Churned_Customers FROM(
SELECT DATETRUNC(MONTH, signup_date) AS Month,
1 AS New_Users,
0 AS Churned_Users FROM saas.customer_churn
UNION ALL
SELECT DATETRUNC(MONTH, signup_date) AS Month,
1 AS Churned_Users,
0 AS New_Users FROM saas.customer_churn
WHERE churned = 1)t GROUP BY Month)

GO
CREATE VIEW Plan_Metrics AS(
SELECT [plan], COUNT(*) AS CustomersbyPlan,
ROUND(SUM(CASE WHEN churned = 0 THEN effective_mrr ELSE 0 END),2) AS MRRbyPlan,
ROUND(CAST(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END )AS float)/COUNT(*)*100,2) AS Churn_RatebyPlan
FROM saas.customer_churn GROUP BY [plan])

GO
CREATE VIEW Country_Metrics AS(
SELECT country,COUNT(*) AS Customers_by_Country,
ROUND(SUM(CASE WHEN churned = 0 THEN effective_mrr ELSE 0 END),0) AS MRRbyCountry 
FROM saas.customer_churn GROUP BY country)

GO
CREATE VIEW Industry_Metrics AS(
SELECT industry, COUNT(*) AS CustomersbyIndustry,
ROUND(CAST(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END )AS float)/COUNT(*)*100,2) AS Churn_RatebyIndustry
FROM saas.customer_churn GROUP BY industry)

GO
CREATE VIEW Referral_Metrics AS(
SELECT referral_source, COUNT(*) AS CustomersbyReferral,
ROUND(SUM(CASE WHEN churned = 0 THEN effective_mrr ELSE 0 END),2) AS MRRbyReferral,
ROUND(CAST(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS float)/COUNT(*)*100,2) AS Churn_RatebyReferrals
FROM saas.customer_churn GROUP BY referral_source)

GO
CREATE VIEW Churn_analysis AS

SELECT  
    'Engagement' AS metric_type,
    Engagement AS segment,
    ROUND(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM (
    SELECT churned,
        CASE 
            WHEN logins_per_week <= 1 THEN '0-1'
            WHEN logins_per_week <= 3 THEN '2-3'
            WHEN logins_per_week <= 6 THEN '4-6'
            ELSE '7+'
        END AS Engagement
    FROM saas.customer_churn
) t
GROUP BY Engagement

UNION ALL

SELECT  
    'NPS',
    nps_category,
    ROUND(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM (
    SELECT churned,
        CASE 
            WHEN nps_score >= 9 THEN 'High Satisfaction'
            WHEN nps_score >= 7 THEN 'Moderate Satisfaction'
            ELSE 'Low Satisfaction'
        END AS nps_category
    FROM saas.customer_churn
) t
GROUP BY nps_category

UNION ALL

SELECT  
    'Support',
    Ticket_level,
    ROUND(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM (
    SELECT churned,
        CASE 
            WHEN support_tickets_last_90d = 0 THEN 'None'
            WHEN support_tickets_last_90d <= 2 THEN 'Low'
            WHEN support_tickets_last_90d <= 4 THEN 'Medium'
            ELSE 'High'
        END AS Ticket_level
    FROM saas.customer_churn
) t
GROUP BY Ticket_level

UNION ALL

SELECT  
    'Tenure',
    Tenure_group,
    ROUND(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM (
    SELECT churned,
        CASE 
            WHEN tenure_months <= 6 THEN 'Early (0-6m)'
            WHEN tenure_months <= 12 THEN 'Mid (7-12m)'
            WHEN tenure_months <= 24 THEN 'Established (13-24m)'
            ELSE 'Loyal (24m+)'
        END AS Tenure_group
    FROM saas.customer_churn
) t
GROUP BY Tenure_group;


GO
CREATE VIEW Risk AS
WITH risk_scored AS (
    SELECT churned, effective_mrr,
        CASE
            WHEN logins_per_week < 3 THEN 1 ELSE 0 END
          + CASE WHEN features_used <= 3 THEN 1 ELSE 0 END
          + CASE WHEN support_tickets_last_90d >= 3 THEN 1 ELSE 0 END
          + CASE WHEN nps_score <= 5 THEN 1 ELSE 0 END
          + CASE WHEN DATEDIFF(day, last_activity_date, '2024-12-31') > 30 THEN 1 ELSE 0 END
        AS risk_score
    FROM saas.customer_churn
),

risk_labeled AS (
    SELECT churned, effective_mrr,
        CASE
            WHEN risk_score <= 1 THEN 'Healthy'
            WHEN risk_score <= 3 THEN 'At Risk'
            ELSE 'High Risk'
        END AS risk_level
    FROM risk_scored
)

SELECT
 risk_level, COUNT(*) AS customer_count,
 ROUND(CAST(SUM(CASE WHEN churned= 1 THEN 1 ELSE 0 END) AS float)/COUNT(*)*100,2) AS churn_rate,

  ROUND( SUM(CASE WHEN churned = 0 THEN effective_mrr ELSE 0 END), 2) AS active_mrr,

  ROUND(SUM(CASE WHEN churned = 0 THEN effective_mrr ELSE 0 END) * 100.0 /
  SUM(SUM(CASE WHEN churned = 0 THEN effective_mrr ELSE 0 END)) OVER(),2) AS pct_revenue
FROM risk_labeled
GROUP BY risk_level;