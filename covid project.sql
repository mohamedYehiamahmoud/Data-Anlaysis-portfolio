



select *
from CovidDeaths
where continent is not NULL
order by 3,4

--select *
--from CovidVaccinations
--where continent is not NULL
--order by 3,4
--selectbthe data we are using
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where continent is not NULL
order by 1,2
--Looking to total cases VS Total deathes
select location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2
--Looking to total cases VS population
--Shows the percentage of population that got Covid
select location,date, population, total_cases,(total_cases/population) * 100 as InfectionPercentage
from CovidDeaths
where location like '%states%'
order by 1,2
--Looking to countries with Highest infection rate comoared to population
select location, population, Max(total_cases) as HighestInfectionCount,Max((total_cases/population)) * 100 as InfectionPercentage
from CovidDeaths
--where location like '%states%'
Group by location, population
order by InfectionPercentage DESC
--Showing Countries with Highest Death count per population
select location, Max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
--where location like '%states%'
where continent is not NULL
Group by location
order by totaldeathcount DESC
--Let's Break Data by continent

--Showing continent with Highest Death count per population
select continent, Max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
--where location like '%states%'
where continent is  not NULL
Group by continent
order by totaldeathcount DESC

--GLOBAL NUMBERS
select SUM(new_cases) AS TOTAL_CASES ,SUM(CAST(new_deaths AS INT)) AS TOTAL_DEATHS,SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 as DeathPercentage
from CovidDeaths
--where location like '%states%'
where continent is  not NULL
--GROUP BY date
order by 1,2

--LOOKING TO TOTAL Vaccinations VS POPULATION

--USING CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
ON dea.location=vac.location
AND dea.date = vac.date
where DEA.continent is  not NULL
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population) * 100
from PopvsVac

--Using Temp tables
drop table if exists #percentpopulationVaccinated
create table #percentpopulationVaccinated
(

continent nvarchar(255)
,location nvarchar(255)
,date datetime
,population numeric
,new_vaccinations bigint
,RollingPeopleVaccinated bigint
)
insert into #percentpopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
ON dea.location=vac.location
AND dea.date = vac.date
--where DEA.continent is  not NULL
--order by 2,3
select *,(RollingPeopleVaccinated/Population) * 100
from #percentpopulationVaccinated
-- Creating view
Create view percentpopulationVaccinated
as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
ON dea.location=vac.location
AND dea.date = vac.date
where DEA.continent is  not NULL
--order by 2,3
select *
from percentpopulationVaccinated








