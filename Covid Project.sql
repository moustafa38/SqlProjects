select * from CovidProject..CovidDeaths
	order by 3,4

select * from CovidProject..CovidVaccination
	order by 3,4


-- Select Data that we are going to work with it

Select location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeaths
Where continent is not null 
order by 1,2

-- change type of total_cases from nvarchar(50) to float

alter table CovidDeaths
alter column total_cases float; 

-- Total Cases vs Total Deaths
-- Shows DeathPercentage in our country (Egypt)

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
From CovidProject..CovidDeath
Where continent is not null and location like 'Egy%'
order by 1,2

-- Countries with Highest Infection by Population

Select Location, population, MAX(total_cases) as HighestInfectionCount,  Max(total_cases/population)*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
Group by Location, population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- continent with Highest Death Count per Population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From CovidProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global numer untill now

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
where continent is not null 
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
with popubyvacc(continent ,location, date,population ,new_vaccinations,RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(convert(int, v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths d
Join CovidProject..CovidVaccination v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from popubyvacc 

-- Creating View to store data for later visualizations

Create View PercentofPopulationVaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths d
Join CovidProject..CovidVaccination v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 

select * from PercentofPopulationVaccinated