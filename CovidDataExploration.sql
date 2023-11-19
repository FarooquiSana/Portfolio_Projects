create database portfolio_projects;
use portfolio_projects;
select * from CovidDeaths;

select * from covidvaccinations;

#looking at the total cases vs total deaths
#shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location = 'India';

#looking at total cases vs population
# shows what percentage of population got Covid
select location, date, population, total_cases, (total_cases/population)*100 as PopPercentage
from coviddeaths;
#where location like '%india%';

#looking at the country with higest infection rate compared to population
select location, population, max(total_cases) as HighestInfectionCount, 
max((total_cases/population))*100 as PercentagePopulationInfected
from coviddeaths
group by location, population
order by PercentagePopulationInfected desc;  

#showing countries with highest death count per population
select location, max(total_deaths) as HighestDeathCount
from coviddeaths
where continent is not null
group by location
order by HighestDeathCount desc; 

#break down things by continent
#showing continent with highest death count per population
select continent, max(total_deaths) as HighestDeathCount
from coviddeaths
where continent is not null
group by continent
order by HighestDeathCount desc; 

#looking at global new cases and new deaths by date 
select date, sum(new_cases) as totalcases, sum(new_deaths)as totaldeaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null
group by date
order by date desc;

#looking at global new cases and new deaths
select sum(new_cases) as totalcases, sum(new_deaths)as totaldeaths,
sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null;

#showing total population vs total vaccinations
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(cv.new_vaccinations) over (partition by cd.location order by cd.location,cd.date) 
as RollingPeopleVaccinated
from coviddeaths cd
join covidvaccinations cv 
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
order by cd.location, cd.date;

#use CTE
with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as ( select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(cv.new_vaccinations) over (partition by cd.location order by cd.location,cd.date) 
as RollingPeopleVaccinated
from coviddeaths cd
join covidvaccinations cv 
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
)
select * , (RollingPeopleVaccinated/population) * 100 as VaccinePercentage from popvsvac;


