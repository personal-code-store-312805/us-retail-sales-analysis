# Retail & Food Services Sales Analysis

## Introduction
This repository contains an exploratory data analysis (EDA) project focusing on the US retail and food services sector. By leveraging advanced SQL techniques, this project examines multi-year retail performance, seasonal sales fluctuations, market share distribution, and growth trajectories across various commercial categories. 

The primary objective is to transform raw retail records into actionable commercial insights by answering critical business questions regarding revenue performance, market shifts, and consumer demand patterns.

---

## Data Source & Preprocessing
* **Primary Source:** The underlying data originates from the **Monthly Retail Trade Survey (MRTS)** report published by the **United States Census Bureau**.
* **Access Platform:** Sourced via Kaggle as a curated retail sales dataset.
* **Data Wrangling:** Prior to database ingestion, the raw government records were cleaned, restructured, and wrangled into a standardised tabular format containing time dimensions (`year`, `month`), industry classifications (`naics_code`, `kind_of_business`, `industry`), and trade figures (`sales`).

---

## Technical Approach & SQL Concepts
The analysis was executed using **PostgreSQL**, employing a structured querying approach to solve complex business scenarios:

* **Common Table Expressions (CTEs):** Used to modularise multi-step calculations, such as nested aggregation and market share contribution calculations.
* **Window Functions (`RANK()`, `LAG()`, `LEAD()`):** Employed for time-series comparisons, ranking market leaders within partitions, calculating growth percentages, and identifying statistical anomalies.
* **Conditional Aggregation (`CASE WHEN` inside `SUM()`):** Utilised to pivot and contrast distinct sub-segments (e.g., Men's vs Women's apparel) within single queries.
* **Subqueries & Joins (Self-Joins, Cross Joins):** Applied to compute Year-over-Year (YoY) metrics and market-wide percentage contributions.
* **Defensive Division (`NULLIF`):** Implemented to guard against zero-division exceptions during ratio computations across sparse time series.

---

## Key Findings & Insights
The analysis script systematically addresses 13 core business inquiries:

1. **Top Industry Identification (2019–2022):** Determined the highest-grossing industries on a monthly basis for four consecutive years using window-based ranking (`RANK()`).
2. **Business Contribution Across Sectors:** Analysed which specific types of commercial establishments generate the highest cumulative sales volume.
3. **Industry Seasonality Analysis:** Mapped monthly sales cycles per industry to identify peak quarters and seasonal demand shifts.
4. **NAICS Code Revenue Distribution:** Evaluated sales concentration across standardised North American Industry Classification System groupings.
5. **Sales Outlier & Anomaly Detection:** Identified sudden surges or drops where monthly sales deviated by more than 50% relative to adjacent months using `LAG()` and `LEAD()` functions.
6. **High-Volume Enterprise Filtering:** Isolated high-performing retail categories boasting an all-time average monthly sale exceeding $10 billion.
7. **Automotive Market Segment Breakdown (2022):** Identified the leading automotive sub-sectors by annual revenue.
8. **Automotive Market Share Contribution:** Computed the exact percentage share contributed by each automotive business type toward total industry revenue.
9. **Year-over-Year (YoY) Industry Growth:** Calculated annual industry growth rates using both self-join CTEs and window-partitioned offsets.
10. **Gender Apparel Market Comparison:** Contrasted total annual revenue between women's clothing stores and men's clothing stores via conditional aggregation.
11. **Apparel Sales Ratio Analysis:** Evaluated the annual spending ratio between women's and men's retail clothing lines.
12. **Cumulative Year-to-Date (YTD) Revenue Tracking:** Built a running YTD sales metric across months (2019–2022) using correlated subqueries.
13. **Month-over-Month (MoM) Apparel Volatility (2022):** Tracked short-term growth percentage shifts in women's apparel retail.

> **Note:** The exported tabular outputs and CSV data for these analytical queries are archived in the [`query_results/`](./query_results/) directory.

---
