Select *
From CovidAnalysis..CovidDeaths
where continent is not null
order by 3,4


--Select *
--From CovidAnalysis..CovidVacciantion
--order by 3,4

--#Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population 
From CovidAnalysis..CovidDeaths
order by 1,2

--Looking at the total cases VS total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidAnalysis..CovidDeaths
order by 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidAnalysis..CovidDeaths
where location like '%IND%'
order by 1,2

----Looking at the total Cases vs Population
----Shows what percentage of populations got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From CovidAnalysis..CovidDeaths
where location like '%IND%'
and continent is not null
order by 1,2

----Looking at Countries with the highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From CovidAnalysis..CovidDeaths
--where location like '%IND%'
Group by Location, Population
order by PercentPopulationInfected desc
where continent is not null
--order by 1,2

-- Countries with Highest Death Count per Population
 
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM CovidAnalysis..CovidDeaths
where continent is not null
GROUP by location
order by TotalDeathsCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM CovidAnalysis..CovidDeaths
where continent is not null
GROUP by continent
order by TotalDeathsCount desc

---Global Numbers

SELECT date, SUM(new_cases) as New_Cases, SUM(cast(new_deaths as int)) as New_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
---total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidAnalysis..CovidDeaths
--where location like '%IND%'
where continent is not null
group by date
order by 1,2

--Overall Global numbers

SELECT SUM(new_cases) as New_Cases, SUM(cast(new_deaths as int)) as New_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
---total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidAnalysis..CovidDeaths
--where location like '%IND%'
where continent is not null
--group by date
order by 1,2

--Let's explore the Vaccination Files

SELECT *
FROM CovidAnalysis..CovidVacciantion

--Let's JOIN two table CovidDeaths and CovidVaccination

SELECT *
FROM CovidAnalysis..CovidDeaths dea
JOIN CovidAnalysis..CovidVacciantion as vac
on dea.location = vac.location
and dea.date = vac.date

--Looking at Total Population VS Total Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, new_vaccinations
FROM CovidAnalysis..CovidDeaths dea
JOIN CovidAnalysis..CovidVacciantion as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinated
--, (RollingPeopleVacinated/population)*100
FROM CovidAnalysis..CovidDeaths dea
JOIN CovidAnalysis..CovidVacciantion as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinated
--, (RollingPeopleVacinated/population)*100
FROM CovidAnalysis..CovidDeaths dea
JOIN CovidAnalysis..CovidVacciantion as vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
SELECT * 
FROM PopvsVac

---We got things that wanted for further calculation and let's calculate the Percentage of RollingPeopleVaccinates by Populations

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidAnalysis..CovidDeaths dea
Join CovidAnalysis..CovidVacciantion vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentageOfRollingPeopleVaccinated
From PopvsVac


---LET'S CREATE A TEMP TABLE...

DROP Table if exists #FinalPercentPopulationVaccinated
Create Table #FinalPercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #FinalPercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidAnalysis..CovidDeaths dea
Join CovidAnalysis..CovidVacciantion vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as PercentageOfRollingPeopleVaccinated
From #FinalPercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View FinalPercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidAnalysis..CovidDeaths dea
Join CovidAnalysis..CovidVacciantion vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

SELECT *
FROM FinalPercentPopulationVaccinated