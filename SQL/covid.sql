-- This project uses two datasets: Covid Vaccination and Covid death tables. We use this data sets to answer the given questions.

SELECT * FROM dbo.covidDeaths ORDER BY 3,4;

---know about the table
exec sp_help CovidDeaths;



--how many continents to we have data for
SELECT *
from dbo.covidDeaths 
where continent is not null
order by 3,4 ;


select distinct continent
from dbo.covidDeaths;


select distinct continent
from dbo.covidDeaths
where continent is not null; 




--possibility of dying from covid
Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from dbo.covidDeaths 
where location like '%united kingdom%'
and continent is not null
order by 1,2 DESC;



--percentage of population infected with covid
Select Location, date, total_cases, population, (CONVERT(float, total_cases) / population)*100 as Percentage_of_people_infected
from dbo.covidDeaths 
where location like '%united kingdom%'
and continent is not null
order by 1,2;



--countries with the highest infection
Select Location, population, max (total_cases)as highestInfectionsCount, Max(total_cases)/population*100 as PercentagePopulationInfected
from dbo.covidDeaths 
group by location,population
order by PercentagePopulationInfected desc;

--countries has the highest death per population
Select Location, max (cast (total_deaths as  int))as TotalDeathcount
from dbo.covidDeaths
where continent is not null
group by location
order by TotalDeathcount desc;



--continents with highest  covid deaths
Select continent, max (cast (total_deaths as  int))as TotalDeathcount
from dbo.covidDeaths
where continent is not null
group by continent
order by TotalDeathcount desc;


 select * from covidDeaths
-- total covid cases, total covid death, deaths percentage
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/ sum(new_cases)*100 as DeathPercentage
from dbo.covidDeaths
where continent is not null
order by 1,2;

--number of people vaccinated against covid with atleast one vaccine
select cd.continent, cd.date,cd.population,cv.new_vaccinations,
 sum(convert(bigint,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location,cd.date) as RollingPeopleVaccinated
from covid_data..covidDeaths cd
join covid_data..covidVaccinations cv
   on cd.location = cv.location
   and cd.date = cv.date
where cd.continent is not null
order by 2,3


--using cte in sql
with cte_population_vaccinated(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
 sum(convert(bigint,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location,cd.date) as RollingPeopleVaccinated
from covid_data..covidDeaths cd
join covid_data..covidVaccinations cv
   on cd.location = cv.location
   and cd.date = cv.date
where cd.continent is not null
--order by 2,3
)
Select *
From cte_population_vaccinated


--using temporary tables

Drop table if exists #percent_population_vaccinated

create table percent_population_vaccinated
(
	continent nvarchar(355),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	rollingpeopleVaccinated numeric
)

insert into percent_population_vaccinated
select cd.continent, cd.location, cd.date,cd.population,cv.new_vaccinations,
 sum(convert(bigint,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location,cd.date) as RollingPeopleVaccinated
from covid_data..covidDeaths cd
join covid_data..covidVaccinations cv
   on cd.location = cv.location
   and cd.date = cv.date
where cd.continent is not null
order by 2,3


select *, (RollingPeopleVaccinated/population)*100 as percentagevaccinated
from percent_population_vaccinated;

--using views 
create view percent_population_vaccinated1 as
select cd.continent, cd.location, cd.date,cd.population,cv.new_vaccinations,
 sum(convert(bigint,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location,cd.date) as RollingPeopleVaccinated
from covid_data..covidDeaths cd
join covid_data..covidVaccinations cv
   on cd.location = cv.location
   and cd.date = cv.date
where cd.continent is not null


SELECT * FROM percent_population_vaccinated1 ORDER BY 3,4;
