Select *
From Portfolio..CovidDeaths$
order by 3,4

Select *
From Portfolio..CovidVaccination$
order by 3,4

--Daily cases  and total cases
Select location, date, total_cases, new_cases, total_deaths, population
From Portfolio..CovidDeaths$
Order by location, date

--Looking at total cases vs total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths$
Order by location, date

--Looking at total cases vs total deaths in India

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths$
where location like '%india%'
Order by location, date

--Looking at Total Cases vs population

Select location, date, total_cases,total_deaths, population, (total_deaths/population)*100 as DeathPercentage
From Portfolio..CovidDeaths$
Order by location, date

--Looking at Total Cases vs population in India

Select location, date, total_cases,total_deaths, population, (total_deaths/population)*100 as DeathPercentage
From Portfolio..CovidDeaths$
where location like '%india%'
Order by location, date

--Looking at the countries with the highest infection rate

Select location,  MAX(total_cases) as total_cases, population, MAX((total_cases/population))*100 as InfectionRate
From Portfolio..CovidDeaths$
where continent is not null
Group By location, population
Order by total_cases desc

--Total cases vs InfectionRate in India

Select location,  MAX(total_cases) as total_cases, population, MAX((total_cases/population))*100 as InfectionRate
From Portfolio..CovidDeaths$
where location like '%india%'
Group By location, population
Order by total_cases desc

--Looking at the countries with the highest Deaths

Select location,  MAX(cast(total_deaths as int) ) as TotalDeathCount
From Portfolio..CovidDeaths$
where continent is not null
Group by location
Order by TotalDeathCount desc

--Total DeathCount in India

Select location,  MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths$
where location like '%india%'
Group By location, population

--Looking at the continent with the highest Deaths

Select location, max(cast(total_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths$
Where continent is null
group by location
Order by TotalDeathCount Desc

--Global Numbers
--New Cases Each Day
Select date, SUM(new_cases) as Total_Cases
FROM Portfolio..CovidDeaths$
group by date
order by 1, 2

--New deaths Each Day

Select date, SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int))as Total_Deaths
FRom Portfolio..CovidDeaths$
Group by date
order by 1,2,3

--Deaths % to cases Each day Across the World

Select date, SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths$
Where continent is not null
Group by date
order by 1,2

--Total Cases and Death Percentage in the world

Select  SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths$
Where continent is not null
order by 1,2

--Total Cases and Death Percentage in India

Select  SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths$
Where location like '%india%'
order by 1,2

--Vaccination Table

Select *
From Portfolio..CovidVaccination$

--Joining the table

Select *
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date

-- Looking at the Vaccination around the world

Select Dea.location, Dea.continent, Dea.date, Dea.population, Vac.new_vaccinations
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where Dea.continent is not null
order by 1,3

--Total Vaccination in india

Select Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, Vac.total_vaccinations
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where Dea.location = 'India'
order by 1,3

-- Total Vaccination in the United States

Select Dea.location, Dea.continent, Dea.date, Dea.population, Vac.new_vaccinations, (Vac.total_vaccinations)
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where Dea.location = 'United States'
order by 1,3

--Every Day vaccination vs Total Vaccination

Select Dea.location, Dea.continent, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinations
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where Dea.continent is not null
order by 1,3


-- Population VS Vaccination
--Using CTE

With PopVSvac (continent, location, date, population, new_vaccination, rolling_vaccinations)
as
(
Select Dea.location, Dea.continent, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinations
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where Dea.continent is not null
)
select *,(Rolling_vaccinations/ population)*100 as PeopleVaccinated
From PopVSvac

--Total Population vs Vaccinations in India

select dea.location, dea.population,  max(cast(Vac.total_vaccinations as int)) as Total_Vaccination, max(cast(vac.total_vaccinations as int)
)/Dea.population*100 as VaccinationRate
from Portfolio..CovidVaccination$ Vac
	join Portfolio..CovidDeaths$ Dea
	on Dea.location = Vac.location
where dea.location like '%india%'
group by Dea.location, dea.population

--Temp Table 
Create table #PercentPVaccinated
(
Location nvarchar(255),
Continent nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
Rolling_Vaccinations numeric
)
Insert into #PercentPVaccinated
Select Dea.location, Dea.continent, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinations
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where Dea.continent is not null
order by location, date

select location, max(Rolling_Vaccinations/Population)*100 as RollingVaccinationRate
From #PercentPVaccinated
group by Location
order by Location

-- Dropping the temp table

--drop table if exists #PercentPVaccinated

--Create view to store for later use
create view PercentPVaccinated 
Select Dea.location, Dea.continent, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinations
From Portfolio..CovidDeaths$ Dea
	join Portfolio..CovidVaccination$ Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where Dea.continent is not null
