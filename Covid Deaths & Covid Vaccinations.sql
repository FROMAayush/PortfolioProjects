								-- Exploring Covid Deaths and Covid Vaccinations around the world From 2020-01-05 till 2024-08-04

SELECT*
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

SELECT*
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

 --Select Data that we are going to be using

SELECT date, location, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 2, 1

 -- Looking at Total Cases Vs Total Deaths

 SELECT date, location, total_cases,
 CASE
	WHEN total_cases = 0  THEN  '0'
	ELSE CAST (total_deaths AS FLOAT)/ total_cases * 100
END AS death_rate_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY 2, 1

-- Shows the likelihood of dying if you contract Covid in Canada
 SELECT date, location, total_cases,
 CASE
 	WHEN total_cases = 0  THEN  '0' 	
	ELSE CAST (total_deaths AS FLOAT)/ total_cases * 100
END AS death_rate_percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Canada'
ORDER BY 2, 1

-- Looking at Total Cases Vs Population
-- Shows what percentage of population got Covid in Canada
 SELECT date, location, population, total_cases,
 CASE
 	WHEN total_cases = 0  THEN  '0'
	ELSE CAST (total_cases AS FLOAT)/ population * 100
END AS Covid_infection_percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Canada'
ORDER BY 2, 1

--Shows countries with highest infection rate compared to population

 SELECT location, population,  MAX (total_cases) AS HighestInfectionCount,
 CASE
	WHEN MAX(total_cases) = 0  THEN  '0'
	ELSE CAST (MAX(total_cases) AS FLOAT)/ population * 100
END AS Covid_infection_percentage
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
 --WHERE location = 'Canada'
ORDER BY 4 DESC


-- Shows Covid infection percentage in Canada
 SELECT location, population,  MAX(total_cases) AS HighestInfectionCount,
 CASE
	WHEN MAX(total_cases) = 0  THEN  '0'
	ELSE CAST (MAX(total_cases) AS FLOAT)/ population * 100
END AS Covid_infection_percentage
  FROM PortfolioProject..CovidDeaths
  WHERE location = 'Canada'
    GROUP BY location, population

-- Shows Countries with Highest Death Count per population
SELECT location, population, MAX (CAST (total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 3 DESC

-- Shows Continent with Highest Death Count per population
-- Represent the Max death count of the country of that continent, but excludes World etc.. 
SELECT continent, MAX (CAST (total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS  NOT NULL
GROUP BY continent
ORDER BY 2 DESC

--Represents the Max Death count of the actual contient. Its because of the data arrangement in the original table
SELECT location, MAX (CAST (total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS  NULL
GROUP BY location
ORDER BY 2 DESC

--Global Numbers

--Total Cases, Total Deaths & Death Percentage each day from 2020-01-01 until 2024-08-14
SELECT  date, 
	SUM(CAST(new_cases AS FLOAT)) AS Total_New_Cases, 
	SUM(CAST(new_deaths AS FLOAT)) AS Total_New_Deaths, 
	CASE
	WHEN new_cases = 0 THEN 0
	ELSE
	(SUM (CAST(new_deaths AS FLOAT))/SUM(CAST(new_cases AS FLOAT))) *100 
	END AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date,new_cases, new_deaths
ORDER BY 1

--Total Cases, Total Deaths & Death Percentage from 2020-01-01 until 2024-08-14
SELECT  
	SUM(CAST(new_cases AS FLOAT)) AS Total_Cases, 
	SUM(CAST(new_deaths AS FLOAT)) AS Total_Deaths, 
	CASE
	WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0
	ELSE
	(SUM (CAST(new_deaths AS FLOAT))/SUM(CAST(new_cases AS FLOAT))) *100 
	END AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL


--Joining Covid Vaccinations table with Covid Deaths table

SELECT *
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date

-- Comparing Total Population Vs Total Vaccinations
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2,3
----------------------------------------------------
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, 
SUM (CAST(CV.new_vaccinations AS FLOAT)) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) 
AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2,3

--Now to calculate the percentage of Population of Country Vs total people vaccinated in that country,
--we need to create Temp Table or CTEs (we cant use new table in arthimetic calculations)

-- Using CTEs

WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, 
SUM (CAST(CV.new_vaccinations AS FLOAT)) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) 
AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
)

SELECT*, 
(RollingPeopleVaccinated/Population)*100
FROM PopVsVac;

--Using TEMP TABLE

CREATE TABLE #PercentagePopulationVaccinated
(Continent NVARCHAR (255),
Location NVARCHAR (255),
Date DATETIME,
Population NUMERIC,
New_Vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentagePopulationVaccinated
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, 
SUM (CAST(CV.new_vaccinations AS FLOAT)) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) -- 

AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL

SELECT*,
(RollingPeopleVaccinated/Population)*100
FROM #PercentagePopulationVaccinated;

-- Using DROP TABLE

DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(Continent NVARCHAR (255),
Location NVARCHAR (255),
Date DATETIME,
Population NUMERIC,
New_Vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentagePopulationVaccinated
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, 
SUM (CAST(CV.new_vaccinations AS FLOAT)) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) 

AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NULL

SELECT*,
(RollingPeopleVaccinated/Population)*100
FROM #PercentagePopulationVaccinated;

-- Creating View to store data for later visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, 
SUM (CAST(CV.new_vaccinations AS FLOAT)) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) 
AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated