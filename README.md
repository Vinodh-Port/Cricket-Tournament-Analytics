# Cricket Performance Analytics Dashboard

An end-to-end sports data analytics and business intelligence project evaluating international cricket player performance metrics. This repository showcases the conversion of complex match statistics into interactive management frameworks using multi-variable DAX formulas, dimensional modeling, and professional layout design.

---

## 📊 Dashboard Insights & Performance Metrics

The analytical dashboard extracts key performance metrics from the cricket statistics dataset across various components:

### 1. High-Level Dataset KPIs
* **Total Players Profiled:** 60 unique international players tracked.
* **Strategic Cohorts:** Custom performance flags categorizing tactical impact, such as **Rohit Sharma (High Strikerate)** and **David Warner (Low Strikerate)**.

### 2. Match Win Distributions (MatchWinner Analysis)
* **India:** 15 total match wins (30%)
* **England:** 14 total match wins (28%)
* **Pakisthan:** 11 total match wins (22%)
* **Australia:** 10 total match wins (20%)
* *Insight: The captured dataset showcases a highly competitive matrix, with India leading the leaderboard at 30% of total recorded match wins.*

### 3. Advanced Batting & Bowling Metrics
* **Boundary Percentage Leaders:** Tracks players with the highest efficiency in boundary run reliance:
  * **Ben Stokes:** 80.52% boundary reliance.
  * **Glenn Maxwell:** 80.43% boundary reliance.
  * **David Willey:** 80.24% boundary reliance.
* **Bowling Rate Aggregations:** Evaluates overall tactical bowling efficiency:
  * **Mark Wood:** 27.72 bowling rate score.
  * **Adam Zampa:** 27.31 bowling rate score.
  * **Ravindra Jadeja:** 27.00 bowling rate score.

### 4. Granular 4s, 6s, & Wickets Breakdown
Clustered horizontal data mapping reveals exact performance stats per player (Blue = Fours, Yellow = Sixes, Orange = Wickets):
* **David Willey:** Accumulates **175 Fours**, **83 Sixes**, and **26 Wickets**.
* **KL Rahul:** Accumulates **170 Fours** and **76 Sixes**.
* **Mohammad Rizwan:** Accumulates **169 Fours** and **76 Sixes**.
* **Hardik Pandya:** Accumulates **167 Fours**, **77 Sixes**, and **27 Wickets**.
* **Moeen Ali:** Accumulates **167 Fours**, **76 Sixes**, and **26 Wickets**.
* **Rohit Sharma:** Accumulates **167 Fours** and **75 Sixes**.

---

## 🛠️ Tech Stack & Analytical Ecosystem

* **Data Cleaning & Pipeline Management:** Python (Pandas) utilized as the primary preprocessing engine to parse records, clean missing rows.
* **Relational Database Server:** Microsoft SQL Server (SSMS) used for data warehousing, managing strict data constraints, and schema structuring.
* **Business Intelligence Tool:** Power BI Desktop for star-schema analytical modeling, DAX measure creation, and custom visualization delivery.
* **ETL Ingestion Architecture:** Scalable processing of large sports analytics matrices delivered via Microsoft Excel sheets and raw CSV tables.
