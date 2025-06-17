SELECT *
FROM [Portofolio Project]..CovidDeaths
WHERE continent is not null
ORDER BY 3,4;

SELECT *
FROM [Portofolio Project].. CovidVaccinations ;

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM [Portofolio Project]..CovidDeaths 
WHERE continent is not null
ORDER BY 1,2
;

--Looking at Total Cases vs Total Deaths
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM [Portofolio Project]..CovidDeaths 
WHERE location like '%states%'
AND continent is not null
ORDER BY 1,2
;


--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

SELECT location,date,population,total_cases, (total_cases/population) * 100 as PercentagePopulationInfected
FROM [Portofolio Project]..CovidDeaths 
--WHERE location like '%states%'
ORDER BY 1,2
;

--Looking at Countries with Highest Infection rate compared to population

SELECT location,population,MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) * 100 as 
PercentagePopulationInfected
FROM [Portofolio Project]..CovidDeaths 
--WHERE location like '%states%'
GROUP BY location,population
ORDER BY PercentagePopulationInfected desc
;

--Showing Countries with Highest Death Count per Population

SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portofolio Project]..CovidDeaths 
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc
;

--LET'S BREAK THINGS DOWN BY CONTINENT

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portofolio Project]..CovidDeaths 
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc
;


--LETS BREAK THINGS DOWN BY CONTINENT
--Showing continent with the Highest death count per population

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portofolio Project]..CovidDeaths 
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc
;


--GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int)) / SUM(new_cases)
* 100 as DeathPercentage
FROM [Portofolio Project]..CovidDeaths 
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2
;




--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,dea.Date) 
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
FROM [Portofolio Project]..CovidDeaths as dea
JOIN [Portofolio Project]..CovidVaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.continent is not null
ORDER BY 2,3
;

--USE CTE

WITH PopvsVac (continent,location,date,population,New_Vaccinations,RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,dea.Date) 
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
FROM [Portofolio Project]..CovidDeaths as dea
JOIN [Portofolio Project]..CovidVaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.continent is not null
--ORDER BY 2,3
)

SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopvsVac 
;


--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)


INSERT INTO #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,dea.Date) 
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
FROM [Portofolio Project]..CovidDeaths as dea
JOIN [Portofolio Project]..CovidVaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated 
;



--Creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,dea.Date) 
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
FROM [Portofolio Project]..CovidDeaths as dea
JOIN [Portofolio Project]..CovidVaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated 
;
