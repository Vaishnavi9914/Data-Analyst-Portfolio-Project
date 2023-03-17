Select * from CovidDeaths
where continent is not null
Order by location, date

Select * from CovidVaccinations
where continent is not null
Order by location, date

Select location, date, total_cases, new_cases, total_deaths, population 
from CovidDeaths
where continent is not null
Order by 1, 2

--Total Cases Vs Total Deaths

Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from CovidDeaths
where location='India'
and continent is not null
Order by 1, 2

--Total Cases Vs Population
--Percentage of population infected by covid

Select location, date, total_cases, population, (total_cases/ population)*100 as InfectedPopulation
from CovidDeaths
Order by 1, 2

--Countries with Highest infection rate

Select location, population, MAX(total_cases) as HighestInfectedCount, MAX(total_cases/ population)*100 as InfectedPercentage
from CovidDeaths
Group by location, population
Order by InfectedPercentage DESC

--Countries with Highest Deaths Count per Population

Select location, population, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by location, population
Order by TotalDeathCount DESC

--Continents with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount DESC

--Shows total cases, total deaths and death percentage all over the world

Select SUM(new_cases) as Totalcases, SUM((new_deaths))as Totaldeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null

--Percentage of People vaccinated throughout continent

Select d.continent, d.location, SUM(d.population) as TotalPopulation, SUM(cast(v.total_vaccinations as bigint))as TotalVaccinationsAvailable, SUM(cast(v.people_vaccinated as bigint))as TotalPeopleVaccinated, SUM(cast(v.people_vaccinated as float))/SUM(cast(v.total_vaccinations as float))*100 as PercentageOfPeopleVaccinated
from CovidDeaths d Join CovidVaccinations v
on d.location=v.location
where d.continent is not null
group by d.location, d.continent
order by 1, 2;

Drop table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
TotalPopulation float,
TotalVaccinationsAvailable bigint,
TotalPeopleVaccinated bigint,
PercentageOfPeopleVaccinated float
)

insert into PercentPopulationVaccinated
Select d.continent, d.location, SUM(d.population) as TotalPopulation, SUM(cast(v.total_vaccinations as bigint))as TotalVaccinationsAvailable, SUM(cast(v.people_vaccinated as bigint))as TotalPeopleVaccinated, SUM(cast(v.people_vaccinated as float))/SUM(cast(v.total_vaccinations as float))*100 as PercentageOfPeopleVaccinated
from CovidDeaths d Join CovidVaccinations v
on d.location=v.location
where d.continent is not null
group by d.location, d.continent
order by 1, 2;

select * from PercentPopulationVaccinated;

--Data Vizualization 

--1

Select SUM(new_cases) as Totalcases, SUM((new_deaths))as Totaldeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null

--2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'High income', 'Upper middle income','Lower middle income','European Union','Low income')
Group by location
order by TotalDeathCount desc

--3

Select location, population, MAX(total_cases) as HighestInfectedCount, MAX(total_cases/ population)*100 as InfectedPercentage
from CovidDeaths
Group by location, population
Order by InfectedPercentage DESC

--4

Select location, population, date, MAX(total_cases) as HighestInfectedCount, MAX(total_cases/ population)*100 as InfectedPercentage
from CovidDeaths
Group by location, population, date
Order by InfectedPercentage DESC