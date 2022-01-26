select *
from PortfolioProject..['Covid Deaths']
where continent is not null
order by 3,4

--select *
--from PortfolioProject..['Covid Vaccinaions']
--order by location, date

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..['Covid Deaths']
where continent is not null
order by 1,2

-- Total Cases vs Total Deaths and the Death Percentage in United States
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..['Covid Deaths']
where location like '%state%'
and continent is not null
--and total_deaths is not null
order by 1,2

-- Total Cases vs Population
select location, date, total_cases, population, (total_cases/population)*100 as CovidPercentage
from PortfolioProject..['Covid Deaths']
where location like '%state%'
and  continent is not null
--and total_deaths is not null
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

select location, population, max(total_cases) "Highest Infection Count", max((total_cases/population))*100 as "Infected Percentage"
from PortfolioProject..['Covid Deaths']
--where location like '%state%'
--and total_deaths is not null
where continent is not null
Group by location, population
order by 4 desc

-- Countries with Highest Mortality Rate per Populaion

select location, max(cast(total_deaths as int)) as DeathCount
from PortfolioProject..['Covid Deaths']
--where location like '%state%'
where continent is not null
Group by location
order by DeathCount desc

-- Breakdown by Continent
select continent, max(cast(total_deaths as int)) as DeathCount
from PortfolioProject..['Covid Deaths']
--where location like '%state%'
where continent is not null
Group by continent
order by DeathCount desc

--GLOBAL NUMBERS BY DATE
select date, sum(new_cases) "Total Cases"  , sum(cast(new_deaths as int)) "Total Deaths", sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..['Covid Deaths']
where continent is not null
 group by date
order by 1,2

--GLOBAL NUMBER
select  sum(new_cases) "Total Cases"  , sum(cast(new_deaths as int)) "Total Deaths", sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..['Covid Deaths']
where continent is not null
order by 1,2


Select *
from PortfolioProject..['Covid Vaccinaions']

-- Joining Covid Deaths and Covid Vaccinations table
-- Looking at Total Vaccination vs Total population

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) "Rolling People Vaccinated"
from PortfolioProject..['Covid Vaccinaions'] vac
Join PortfolioProject..['Covid Deaths'] dea
   On dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
Order by 2,3

-- CTE
with PopVac (continent,location,date,population,new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
from PortfolioProject..['Covid Vaccinaions'] vac
Join PortfolioProject..['Covid Deaths'] dea
   On dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopVac

--TEMP TABLE
Drop table if exists PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated decimal)

INSERT INTO PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
from PortfolioProject..['Covid Vaccinaions'] vac
Join PortfolioProject..['Covid Deaths'] dea
   On dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--Order by 2,3)

select *, (RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated

--Creating View to store data for later visualization
Create View PercentPopVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
from PortfolioProject..['Covid Vaccinaions'] vac
Join PortfolioProject..['Covid Deaths'] dea
   On dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--Order by 2,3)

select * from PercentPopVaccinated