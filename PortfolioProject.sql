Select location, date, total_cases, new_cases, total_deaths, population
From ProjectPortfolio..['CovidData']
order by 1,2


-- Selecting the data that will be used for the analysis
-- Looking at total cases vs total deaths
-- Shows the likelihood of dieing if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From ProjectPortfolio..['CovidData']
where location like ('%nigeria%')
order by 1,2

-- Looking at total cases vs population
-- Shows what percentage of population have got covid
Select location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
From ProjectPortfolio..['CovidData']
where location like ('%nigeria%')
order by 1,2


--looking at countries with the highest infection rates in comparison to their population
Select location, population, Max(total_cases) as CountriesWithMaximumInfections,  Max((total_cases/population))*100 as CountriesWithHighPercentage
From ProjectPortfolio..['CovidData']
Group by Location, Population
Order by CountriesWithHighPercentage desc

--Showing the countries with the highest death count due to covid
Select location, Max(Cast(total_deaths as int)) as MaximumDeathCount
From ProjectPortfolio..['CovidData']
Where continent is not Null
Group by Location
Order by MaximumDeathCount desc

--Adding continent to the queries
Select continent, Max(Cast(total_deaths as int)) as MaximumDeathCount
From ProjectPortfolio..['CovidData']
Where continent is not Null
Group by Continent
Order by MaximumDeathCount desc

--Showing continents with the highest death percentage per population
Select continent, Cast(total_deaths as int), population, (total_deaths/population)*100 as DeathPercentagePerContinent 
From ProjectPortfolio..['CovidData']
Where continent is not null
--Group by continent
Order by DeathPercentagePerContinent desc

--Querying for the global numbers of cases and deaths
Select SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) as total_deaths, (SUM(new_cases)/SUM(CAST(new_deaths as int)))*100 as GlobalDeathPercentage
From ProjectPortfolio..['CovidData']
Order by GlobalDeathPercentage desc

Select dea.population, dea.date, dea.continent, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingTotalVaccinations
From ProjectPortfolio..['CovidData'] dea
Join ProjectPortfolio..['CovidVaccinations'] vac
	on dea.location=vac.location
	and dea.date=vac.date
Order by 2,3

--Creating View to Store Data For Later

Create View PercentagePopulationVaccinated as
Select dea.population, dea.date, dea.continent, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingTotalVaccinations
From ProjectPortfolio..['CovidData'] dea
Join ProjectPortfolio..['CovidVaccinations'] vac
	on dea.location=vac.location
	and dea.date=vac.date
--Order by 2,3





