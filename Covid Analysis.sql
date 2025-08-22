# ------------------------------------------------------------
# Pull all COVID death records by country (ignoring aggregate rows 
# like "World" or "International") and sort them by date.
# ------------------------------------------------------------
Select * 
FROM coviddeathsdata_clean
Where continent is not null
order by 3,4;

# ------------------------------------------------------------
# Preview all vaccination records by country and date.
# (Commented out in case you only need it for testing)
# ------------------------------------------------------------
## Select * 
##FROM covid_vaccinations
##order by 3,4;

# ------------------------------------------------------------
# Select the key fields we will use for analysis:
# Country, date, cases, deaths, and population.
# ------------------------------------------------------------
Select Location,date,total_cases,new_cases,total_deaths,population
FROM coviddeathsdata_clean
Where continent is not null
order by 1,2;

# ------------------------------------------------------------
# Compare total cases vs. total deaths in the U.S.
# Calculates "Death Percentage" → likelihood of dying if infected.
# ------------------------------------------------------------
Select Location,date,total_cases,total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM coviddeathsdata_clean
Where location like "United States"
order by 1,2;

# ------------------------------------------------------------
# Compare total cases vs. population in the U.S.
# Calculates "Percent population affected" → how widespread COVID was.
# ------------------------------------------------------------
Select Location,date,total_cases,population, (total_cases/population) * 100 AS 'Percent population affected'
FROM coviddeathsdata_clean
Where location like "United States"
order by 1,2;

# ------------------------------------------------------------
# Rank countries by infection rate relative to their population.
# Shows max cases and percent of the population infected.
# ------------------------------------------------------------
Select Location,Population, MAX(total_cases) AS HighestInfectionCount,
       MAX(total_cases/population) * 100 AS PercentPopulationInfected
FROM coviddeathsdata_clean
Group by Location, Population
order by PercentPopulationInfected desc;

# ------------------------------------------------------------
# Rank countries by highest death count overall.
# CAST converts death counts from text to integer values.
# ------------------------------------------------------------
Select Location, MAX(cast(total_deaths as UNSIGNED)) AS TotalDeathCount
FROM coviddeathsdata_clean
Where continent is not null
Group by Location
order by TotalDeathCount desc;

# ------------------------------------------------------------
# Rank continents by total deaths to compare across regions.
# ------------------------------------------------------------
Select continent, MAX(cast(total_deaths as UNSIGNED)) AS TotalDeathCount
FROM coviddeathsdata_clean
Where continent is not null
Group by continent
order by TotalDeathCount desc;

# ------------------------------------------------------------
# Calculate global totals: new cases, new deaths, and global death %.
# ------------------------------------------------------------
Select SUM(new_cases) AS totalcases,
       SUM(new_deaths) AS totaldeaths,
       SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM coviddeathsdata_clean
Where continent is not null
order by 1,2;

# ------------------------------------------------------------
# Analyze population vs. vaccinations using a CTE.
# For each country and date, calculate the rolling (cumulative) number
# of vaccinations, then compute vaccination percentage of population.
# ------------------------------------------------------------
With PopvsVac (continent,location,date,population, new_vaccinations, RollingPeopleVaccinated) as (
    Select dea.continent,
           dea.location,
           dea.date,
           dea.population,
           vac.new_vaccinations,
           SUM(vac.new_vaccinations) OVER (
               Partition by dea.location Order by dea.location, dea.date
           ) AS RollingPeopleVaccinated
    FROM coviddeathsdata_clean dea
    JOIN covid_vaccinations vac
      ON dea.location = vac.location
     AND dea.date = vac.date
    Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population) * 100
FROM PopvsVac;

# ------------------------------------------------------------
# TEMP TABLE: Store vaccination progress for later analysis.
# Creates a table with population, daily vaccinations,
# and rolling vaccination totals per country/date.
# ------------------------------------------------------------
Drop Table if exists PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
    continent VARCHAR(255) CHARACTER SET utf8mb4,
    location  VARCHAR(255) CHARACTER SET utf8mb4,
    date DATETIME,
    population DECIMAL(18,2),
    new_vaccinations DECIMAL(18,2),
    RollingPeopleVaccinated DECIMAL(18,2)
);

Insert into PercentPopulationVaccinated
Select dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       SUM(vac.new_vaccinations) OVER (
           Partition by dea.location Order by dea.date
       ) AS RollingPeopleVaccinated
FROM coviddeathsdata_clean dea
JOIN covid_vaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date;

# Preview the temp table with vaccination % of population.
Select *, (RollingPeopleVaccinated/Population) * 100
FROM PercentPopulationVaccinated;

# ------------------------------------------------------------
# CREATE VIEW: Save the same logic as a reusable view for visualization.
# This allows BI tools (like Tableau or Power BI) to easily connect
# without recalculating the logic each time.
# ------------------------------------------------------------
CREATE VIEW MPercentPopulationVaccinated AS
SELECT t.continent,
       t.location,
       t.date,
       t.population,
       t.new_vaccinations,
       t.RollingPeopleVaccinated
FROM (
    SELECT dea.continent,
           dea.location,
           dea.date,
           dea.population,
           vac.new_vaccinations,
           SUM(vac.new_vaccinations) OVER (
               PARTITION BY dea.location 
               ORDER BY dea.date
           ) AS RollingPeopleVaccinated
    FROM coviddeathsdata_clean dea
    JOIN covid_vaccinations vac
      ON dea.location = vac.location
     AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
) t;

# ------------------------------------------------------------
# Query the created view to verify results.
# ------------------------------------------------------------
Select * from mpercentpopulationvaccinated;
