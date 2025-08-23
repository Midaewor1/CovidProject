# 📊 COVID-19 Data Exploration with SQL

## 📌 Project Overview
This project explores global COVID-19 data using SQL queries in **MySQL Workbench**.  
The goal is to showcase my ability to:
- Clean and structure real-world datasets
- Write efficient SQL queries
- Perform analytical calculations
- Present insights that answer meaningful business/health questions

Data comes from publicly available COVID-19 datasets (e.g., Our World in Data).

---

## ⚙️ Tools & Technologies
- **Database**: MySQL  
- **IDE**: MySQL Workbench  
- **Language**: SQL  
- **Dataset**: COVID deaths and vaccination data  

---

## 🧾 Queries & Insights

### 1️⃣ Global Totals and Mortality Rate
```sql
Select SUM(new_cases) AS totalcases,
       SUM(new_deaths) AS totaldeaths,
       SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM coviddeathsdata_clean
Where continent is not null
order by 1,2;
Purpose:
Calculates worldwide totals of cases and deaths, plus the overall mortality rate (% of cases that resulted in death).
Insight:
Helps understand the global severity of COVID-19.
2️⃣ Countries Ranked by Total Deaths
Select location, SUM(cast(new_deaths as SIGNED)) as TotalDeathCount
From coviddeathsdata_clean
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;
Purpose:
Ranks individual countries by their cumulative death counts (excludes aggregate rows like World or European Union).
Insight:
Identifies the countries most heavily impacted in terms of raw death counts.
3️⃣ Countries Ranked by Infection Rate
Select Location, Population, MAX(total_cases) as HighestInfectionCount, 
       MAX((total_cases / population)) * 100 as PercentPopulationInfected
FROM coviddeathsdata_clean
Group by Location, Population
order by PercentPopulationInfected desc;
Purpose:
Compares the total number of cases to each country’s population, showing % of population infected at the peak.
Insight:
Reveals countries with the highest infection penetration relative to their population size.
4️⃣ Infection Rate Over Time
Select Location, Population, date, 
       MAX(total_cases) as HighestInfectionCount, 
       MAX((total_cases / population)) * 100 as PercentPopulationInfected
FROM coviddeathsdata_clean
Group by Location, Population, date
order by PercentPopulationInfected desc;
Purpose:
Extends the infection rate analysis to include dates, giving a timeline of peak infection rates per country.
Insight:
Shows when each country experienced its worst outbreaks, providing a historical progression.
🚀 Key Skills Demonstrated
Using aggregate functions (SUM, MAX) for analytics
Applying window functions for rolling calculations
Handling data cleaning (CAST, filtering out NULL/aggregate rows)
Performing comparative analysis across countries and continents
Organizing queries for clear, business-focused insights
📈 Next Steps
Add visualizations (e.g., Tableau/Power BI dashboards) to make trends more accessible
Incorporate vaccination data to compare infection rates vs. vaccination progress
Automate ETL (Extract, Transform, Load) for updated COVID datasets
🙋 About Me
I am building a strong foundation in data analytics and SQL development, with the goal of applying my skills to solve real-world problems. This project demonstrates my ability to explore raw data, clean it, and extract insights valuable for decision-making.
👉 If you’d like to connect, check out my LinkedIn or reach out directly!
