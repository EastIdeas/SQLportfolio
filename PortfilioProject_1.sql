-- Analysis on a COVID within the Balkan counties.
-- Dataset was imported and used from https://ourworldindata.org/covid-deaths
-- Timeline starts from Feb2020 until Feb2022



Select *
From PortfolioProject..Deaths
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..Deaths
order by 1,2



-- Change date format

Select date, CONVERT(Date, date) 
From PortfolioProject..Deaths

ALTER TABLE PortfolioProject..Deaths
Add DateConverted Date

Update PortfolioProject..Deaths
Set DateConverted = CONVERT(Date, date)


Select date, CONVERT(Date, date) 
From PortfolioProject..Vaccination

ALTER TABLE PortfolioProject..Vaccination
Add DateConverted Date

Update PortfolioProject..Vaccination
Set DateConverted = CONVERT(Date, date)


-- Calculation total cases against total deaths

Select location, DateConverted, total_cases, total_deaths, (CAST(total_deaths AS float))/(CAST(total_cases AS float))*100 as DeathPercentage
From PortfolioProject..Deaths
--Where location like 'Serbia'
order by 1,2


-- Calc Total cases vs Population (percentage of how many people got infected in Serbia)

Select location, DateConverted, total_cases, population, (CAST(total_cases AS float))/(CAST(population AS float))*100 as InfectPercentage
From PortfolioProject..Deaths
Where location like 'Serbia'
order by 1,2


-- Highest infection rate vs population (Balkan region)

Select location, population, MAX(total_cases) as HighInfCount, MAX((CAST(total_cases AS float))/(CAST(population AS float)))*100 as InfectPercentage
From PortfolioProject..Deaths
Group by population, location
order by InfectPercentage desc


-- Balkan countries with highest death rate per population

Select location, MAX(CAST(total_deaths as float)) as TotalDeathCount
From PortfolioProject..Deaths
Group by location
order by TotalDeathCount desc


-- Compare Population and Vaccination

Select dea.location, dea.DateConverted, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS float)) OVER (Partition by dea.location Order by dea.date) as VaccNumbers
From PortfolioProject..Deaths dea
Join PortfolioProject..Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Order by 1,2








-- Work Tables

Create View NumCasesVsDeaths as 
Select location, DateConverted, total_cases, total_deaths, (CAST(total_deaths AS float))/(CAST(total_cases AS float))*100 as DeathPercentage
From PortfolioProject..Deaths
--Where location like 'Serbia'
--order by 1,2

Create View TotalDeathBalkan as
Select location, MAX(CAST(total_deaths as float)) as TotalDeathCount
From PortfolioProject..Deaths
Group by location
--order by TotalDeathCount desc


Create View SerbiaInfPercent as
Select location, DateConverted, total_cases, population, (CAST(total_cases AS float))/(CAST(population AS float))*100 as InfectPercentage
From PortfolioProject..Deaths
Where location like 'Serbia'


Create View PopulationVaccinated as 
Select dea.location, dea.DateConverted, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS float)) OVER (Partition by dea.location Order by dea.date) as VaccNumbers
From PortfolioProject..Deaths dea
Join PortfolioProject..Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--Order by 1,2

Select *
From NumCasesVsDeaths
