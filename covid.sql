

--Death percantage (total_deaths vs death percentage)
--It shows you what's the possibilty of death if you got infected
select location , date , population, total_cases , total_deaths, (total_deaths/total_cases)*100 as death_percentage
from CovidDeaths
--where location = 'egypt';

--Highest infection rate, by country 
--It shows you what's the possibility of infected in the country
select  location ,  population, max(total_cases) highest_total_cases ,(max(total_cases)/population)*100 as Infection_rate
from CovidDeaths
group by location ,  population
order by Infection_rate desc

--showing highest death count by country
select location, max(cast(total_deaths as int)) as count_deaths --we added cast cause the real data type was nvarchar 
from CovidDeaths
where continent is not null  --we noteced that the continent cells was null in some columns 
group by location
order by count_deaths desc


--showing highest death count by continent
select continent, max(cast(total_deaths as int)) as count_deaths --we added cast cause the real data type was nvarchar 
from CovidDeaths
where continent is not null  --we noteced that the continent cells was null in some columns 
group by continent
order by count_deaths desc
;


--global records
select sum(new_cases)totalcases,sum(cast(new_deaths as int))totaldeaths,cast( (sum(cast(new_deaths as int))/sum(new_cases))*100 as decimal (10,4)) deathpercentage
from CovidDeaths
where continent is not null


--population vs vaccination
with vcte --we created the cte cause we can't devide the ellice name by the population
as
(
select de.continent,de.location, de.date,de.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int)) over(partition by de.location order by de.location,de.date) rolling_of_vaccs--the ellice
from CovidDeaths de join Covidvaccinations vac
on de.location=vac.location
and de.date=vac.date
where de.continent is not null
)
select*,(rolling_of_vaccs/population)*100 PercenageOfVaccinated
from vcte


