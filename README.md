# SaaS Customer Churn & Revenue Analytics

> **End-to-end analytics project on 5,000 SaaS customers ($557.9K MRR) 
identifying churn drivers, flagging 439 at-risk accounts representing 
$59.8K in revenue exposure, built on a Python → SQL Server → Power BI pipeline.**

---

# Project Overview

This project analyzes customer churn behavior and revenue trends in a SaaS business environment to identify retention risks, revenue leakage, and customer engagement patterns.

The dashboard is designed to simulate a real-world SaaS analytics solution used by business and customer success teams to monitor customer health and improve retention strategies.

| Metric             | Value     |
| ------------------ | --------- |
| Total Customers    | 5,000     |
| Churned Customers  | 1,213     |
| Overall Churn Rate | 24.26%    |
| Total MRR          | $557.90K  |
| Revenue Lost       | $153.08K  |
| ARPU               | $142      |

---

# Tools & Techniques

* **Python (pandas)** — Data generation and cleaning pipeline
* **SQL Server** — Data storage, KPI extraction, T-SQL views
* **Power BI** — Interactive dashboard development
* **DAX** — Churn calculations, revenue metrics, segmentation logic
* **Customer Segmentation** — Risk, engagement, NPS, tenure analysis
* **Business Intelligence** — KPI design and executive reporting

---

# Dashboard Pages

## 1. Executive Overview

Focuses on high-level SaaS performance metrics and revenue trends.

### Includes:

* Total Customers
* Churned Customers
* Churn Rate
* Monthly Recurring Revenue (MRR)
* Revenue Lost
* Monthly Revenue & Churn Trends
* New vs Churned Customers over time
* Global Customer Distribution
* Service Plan Performance

---

## 2. Churn Risk Analysis

Focuses on customer retention behavior and churn segmentation.

### Includes:

* Churn Rate by Industry
* Churn Rate by Service Plan
* Active Customer Risk Breakdown
* Segment-based Churn Analysis
* Engagement Analysis
* NPS / Satisfaction Analysis
* Tenure-based Retention Analysis

---

# Key Findings

## 1. Service Plan Retention Patterns

Customer churn decreases significantly as customers move toward higher-tier plans.

| Service Plan | Churn Rate |
| ------------ | ---------- |
| Starter      | 26.82%     |
| Growth       | 24.02%     |
| Pro          | 23.31%     |
| Enterprise   | 18.99%     |

> **Insight:** Enterprise customers demonstrate significantly stronger retention compared to lower-tier plans, suggesting higher engagement and long-term product adoption among premium users.

**Recommendations:**

* Improve onboarding experience for Starter users
* Introduce retention incentives for lower-tier customers
* Focus upselling efforts toward Growth and Pro customers

---

## 2. Revenue & Churn Trends

Monthly analysis reveals fluctuations in both revenue growth and customer churn.

* Revenue and customer acquisition increase during certain periods
* Churn spikes contribute directly to revenue loss
* Customer growth does not always translate into retention stability

> **Insight:** Sustained revenue growth depends not only on acquiring customers but also on reducing churn among existing users.

**Recommendations:**

* Monitor churn spikes proactively
* Launch retention campaigns during high-risk periods
* Improve customer lifecycle engagement

---

## 3. Customer Risk Segmentation

Customers were segmented into Healthy, At Risk, and High Risk based on a composite score of five behavioral signals: login frequency, feature adoption, support ticket volume, NPS score, and days since last activity.

| Risk Level | Customers | Active MRR   | Revenue % |
| ---------- | --------- | ------------ | --------- |
| Healthy    | 3,348     | $492,426.75  | 88.26%    |
| At Risk    | 404       | $59,893.65   | 10.74%    |
| High Risk  | 35        | $5,581.20    | 1.00%     |

**Risk Score Logic:**

| Signal | Condition | Score |
| --- | --- | --- |
| Login frequency | < 3 logins/week | +1 |
| Feature adoption | ≤ 3 features used | +1 |
| Support tickets | ≥ 3 tickets in 90 days | +1 |
| NPS score | ≤ 5 | +1 |
| Inactivity | No activity in 30+ days | +1 |

Score 0–1 → Healthy | Score 2–3 → At Risk | Score 4–5 → High Risk

> **Insight:** A relatively small group of high-risk customers can still contribute meaningful revenue impact if churn is not addressed early.

**Recommendations:**

* Implement proactive customer success outreach for At Risk accounts
* Track behavioral warning signals continuously
* Prioritize retention of high-value at-risk accounts

---

## 4. Industry-Wise Churn Analysis

Churn behavior varies significantly across industries.

| Industry            | Observation        |
| ------------------- | ------------------ |
| Media               | Highest churn rate |
| E-commerce & Retail | Elevated churn     |
| Education           | Lowest churn rate  |

> **Insight:** Certain industries may face lower product stickiness or stronger competitive alternatives, increasing churn probability.

**Recommendations:**

* Customize retention strategies by industry
* Analyze industry-specific customer pain points
* Develop targeted engagement campaigns

---

## 5. Engagement & Satisfaction Analysis

Customer engagement and satisfaction show strong correlation with retention.

### Key Observations:

* Low engagement customers (0–1 logins/week) exhibit the highest churn
* Lower NPS groups show elevated churn behavior
* High-engagement users (7+ logins/week) demonstrate the strongest retention

> **Insight:** Login frequency is the single strongest predictor of churn. Customer activity and satisfaction are strong leading indicators of churn risk.

**Recommendations:**

* Increase product engagement initiatives
* Monitor customer usage patterns
* Improve customer support and onboarding experience

---

## 6. Tenure-Based Churn Analysis

Customer retention improves significantly with tenure.

| Tenure Group         | Observation    |
| -------------------- | -------------- |
| Early (0–6m)         | Highest churn  |
| Mid (7–12m)          | Moderate churn |
| Established (13–24m) | Lower churn    |
| Loyal (24m+)         | Minimal churn  |

> **Insight:** Early-stage customers represent the most vulnerable segment in the customer lifecycle. The first 6 months are the most critical period for retention.

**Recommendations:**

* Strengthen onboarding process
* Provide early-stage support and education
* Track first 90-day engagement closely

---

# Conclusion

The dashboard reveals that churn risk is heavily influenced by:

* Service plan tier
* Customer engagement
* Satisfaction levels
* Customer tenure
* Industry type

While the business demonstrates strong recurring revenue generation, reducing churn among early-stage and low-engagement customers represents the largest opportunity for improving long-term SaaS growth and profitability.

---

# Skills Demonstrated

* Python Data Cleaning (pandas)
* SQL Server & T-SQL View Development
* Power BI Dashboard Development
* DAX Calculations
* Customer Churn Analysis
* SaaS KPI Analysis
* Risk Segmentation
* Business Intelligence Reporting
* Data Storytelling
* Executive Dashboard Design

---

# Future Improvements

Potential future enhancements include:

* Predictive churn modeling using Machine Learning
* Customer Lifetime Value (CLV) analysis
* Cohort retention analysis
* Automated churn prediction alerts
* Subscription upgrade/downgrade tracking
* Retention recommendation engine

---

# File Structure

```text
SaaS_Churn_Analytics/
┣ saas_churn_dataset.csv       # Raw synthetic dataset — 5,000 rows, 19 columns
┣ saas_churn_cleaned.csv       # Cleaned dataset loaded into SQL Server
┣ clean_saas_data.py           # Python cleaning script
┣ sql_queries.sql              # All T-SQL views and KPI logic
┣ dashboard.pbix               # Power BI dashboard file
┗ README.md                    # Project documentation
```
