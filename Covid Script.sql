Select * 
FROM coviddeathsdata_clean
Where continent is not null
order by 3,4;

## Select * 
##FROM covid_vaccinations
##order by 3,4;

##Select the data that we are going to be using

Select Location,date,total_cases,new_cases,total_deaths,population
FROM coviddeathsdata_clean
Where continent is not null
order by 1,2;

#Looking at the total cases vs total deaths
#Shows likelihood of dying if you contract covid in your country
Select Location,date,total_cases,total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM coviddeathsdata_clean
Where location like "United States"
order by 1,2;

#Looking at Total Cases vs Population
#Shows what percentage of population got Covid
Select Location,date,total_cases,population, (total_cases/population) * 100 AS 'Percent population affected'
FROM coviddeathsdata_clean
Where location like "United States"
order by 1,2;

#Looking at countries with highest infection rate compared to populaton
Select Location,Population, MAX(total_cases) AS HighestInfectionCount,MAX(total_cases/population) * 100 AS 
PercentPopulationInfected
FROM coviddeathsdata_clean
Group by Location, Population
order by PercentPopulationInfected desc;

#Showing countries with highest death count per population
#Unsigned changes the death column to an int
Select Location, MAX(cast(total_deaths as UNSIGNED)) AS TotalDeathCount
FROM coviddeathsdata_clean
Where continent is not null
Group by Location
order by TotalDeathCount desc;

#Let's break things down by continent
#Showing the continents with the highest death count
Select continent, MAX(cast(total_deaths as UNSIGNED)) AS TotalDeathCount
FROM coviddeathsdata_clean
Where continent is not null
Group by continent
order by TotalDeathCount desc;

#Global Numbers
Select SUM(new_cases) AS totalcases, SUM(new_deaths) AS totaldeaths, SUM(new_deaths) / SUM(new_cases) * 100 
AS DeathPercentage
FROM coviddeathsdata_clean
#Where location like "United States"
Where continent is not null
#Group By date
order by 1,2;

#Looking at Total Population vs Vaccinations
#Calculates rolling count of new vaccinations in country by date
#USE CTE
With PopvsVac (continent,location,date,population, new_vaccinations, RollingPeopleVaccinated)
as (
Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM coviddeathsdata_clean dea
JOIN covid_vaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
##order by 2,3
)
Select * , (RollingPeopleVaccinated/Population) * 100
FROM PopvsVac;

#TempTable

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
Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.date) AS RollingPeopleVaccinated
FROM coviddeathsdata_clean dea
JOIN covid_vaccinations vac
ON dea.location = vac.location
and dea.date = vac.date;
##Where dea.continent is not null
##order by 2,3


Select * , (RollingPeopleVaccinated/Population) * 100
FROM PercentPopulationVaccinated;

#Creating view to store data for later visualizations


#Create view of table above
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
)t;

#Open view - 
Select * from mpercentpopulationvaccinated;



