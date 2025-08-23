#1.

Select SUM(new_cases) AS totalcases,
       SUM(new_deaths) AS totaldeaths,
       SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM coviddeathsdata_clean
Where continent is not null
order by 1,2;


#2.
Select location, SUM(cast(new_deaths as SIGNED)) as TotalDeathCount
From coviddeathsdata_clean
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;

#3. 

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population)) * 100
as PercentPopulationInfected
FROM coviddeathsdata_clean
Group by Location, Population
order by PercentPopulationInfected desc;

#4. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population)) * 100
as PercentPopulationInfected
FROM coviddeathsdata_clean
Group by Location, Population, date
order by PercentPopulationInfected desc;

