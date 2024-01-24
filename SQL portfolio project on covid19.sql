use project
select* 
from project..CovidDeaths$
where continent is not null
order by 3,4

select * from project..CovidVaccinations$
order by 3,4


select location,date,total_cases,total_deaths,new_cases,population
from project..CovidDeaths$
order by 1,2

--looking for total_deaths vs total_cases
--shows liklehood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from project..CovidDeaths$
where location like '%india%'
order by 1,2

--looking at total_cases vs population

select location,date,total_cases,population,(total_cases/population)*100 as 
percentpopulationinfected
from project..CovidDeaths$
--where location like '%india%'
order by 1,2

--looking at countries with highest infection rate compared to popultion

select location,population,max(total_cases)as highestinfectioncount ,max(total_cases/population)*100 as 
percentpopulationinfected
from project..CovidDeaths$
--where location like '%india%'
group by location,population
order by percentpopulationinfected desc

--showing countries with higesht total death counts

select location,max(cast(total_deaths as int))as totaldeathcount
from project..CovidDeaths$
--where location like '%india%'
where continent is not null
group by location
order by totaldeathcount desc

select location,max(cast(total_deaths as int))as totaldeathcount
from project..CovidDeaths$
--where location like '%india%'
where continent is  null
group by location
order by totaldeathcount desc

--global numbers

select date,sum(new_cases)as total_cases,sum(cast(new_deaths as int))as total_deaths,sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage
from project..CovidDeaths$
--where location like '%india%'
where continent is not null
group by date
order by 1,2

--looking at total population vs total deaths
select *
from project..CovidDeaths$ dea
join project..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date

--use cte
 with popvsvac(continent,Location,date,Population,New_vaccinations,rollingpeoplevaccinated
 as
 (
select dea.location,dea.date, dea.population ,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order
by dea.location , dea.date) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from project..CovidDeaths$ dea
join project..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select * ,(rollingpeoplevaccinated/population)*100
from popvsvac

--temp table
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rollingpeeoplevaccinated numeric
)

insert  into #percentpopulationvaccinated
select dea.location,dea.date, dea.population ,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order
by dea.location , dea.date) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from project..CovidDeaths$ dea
join project..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * ,(rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated

--creating view for later use
create view percentpopulationvaccinated as
select dea.location,dea.date, dea.population ,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order
by dea.location , dea.date) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from project..CovidDeaths$ dea
join project..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select * from percentpopulationvaccinated