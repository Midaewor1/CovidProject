# 📊 COVID-19 Data Exploration with SQL

## 📌 Project Overview
This project explores **global COVID-19 data** using SQL queries in **MySQL Workbench**.  
The goal is to showcase my ability to:
- Clean and structure real-world datasets  
- Write efficient SQL queries  
- Perform analytical calculations  
- Present insights that answer meaningful business/health questions  

Data source: *Our World in Data (OWID) — COVID-19 dataset*

---

## ⚙️ Tools & Technologies
- **Database**: MySQL  
- **IDE**: MySQL Workbench  
- **Language**: SQL  
- **Dataset**: COVID deaths & vaccination data  

---

## 🧾 Queries & Insights

### 1️⃣ Global Totals and Mortality Rate
```sql
SELECT SUM(new_cases) AS totalcases,
       SUM(new_deaths) AS totaldeaths,
       SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM coviddeathsdata_clean
WHERE continent IS NOT NULL
ORDER BY 1,2;


2️⃣ Countries Ranked by Total Deaths
SELECT location, SUM(CAST(new_deaths AS SIGNED)) AS TotalDeathCount
FROM coviddeathsdata_clean
WHERE continent IS NULL
  AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;
Insight: Ranks countries by cumulative death count while excluding world/region aggregates.



3️⃣ Countries Ranked by Infection Rate
SELECT Location, Population, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM coviddeathsdata_clean
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;
Insight: Compares cases vs. population to show the percentage of the population infected at peak levels.


4️⃣ Infection Rate Over Time
SELECT Location, Population, date, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM coviddeathsdata_clean
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;
Insight: Tracks infection rate by country and date, showing peak infection levels over time.


🚀 Key Skills Demonstrated
Aggregate functions (SUM, MAX)
Data cleaning (CAST, filtering NULLs, excluding aggregates)
Comparative analysis across countries and continents
Producing clear, business-relevant insights from raw data


📈 Next Steps
Add visualizations (Tableau/Power BI)
Extend analysis with vaccination progress vs. infection rates
Build an ETL pipeline for automated updates


🙋 About Me
I am building strong skills in SQL, data analytics, and business intelligence.
This project demonstrates my ability to work with real-world data, write optimized queries, and derive actionable insights.
👉 Connect with me on LinkedIn or check out more of my work here on GitHub!















