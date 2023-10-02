
--Select*
--from [covid_proj.db]..covid_vacines
--order by 3,4

Select*
from [covid_proj.db]..covid_deaths
order by 3,4

--Select data we are going to be using
Select location, date, new_cases, total_cases,total_deaths, population
from [covid_proj.db]..covid_deaths
order by 1,2

--Looking at total_cases versus total_deaths
Select
  Location,
  date,
  total_deaths,
  total_cases,
  Try_cast(total_deaths as int) as conv_total_deaths,
  Try_cast(total_cases as  int) as conv_total_cases,
  Case
   when total_cases = 0 Then Null
   Else Try_cast(total_deaths as  int) / Try_cast(total_cases as int)*100 
  End as death_case_ratio
From [covid_proj.db]..covid_deaths
Order by 1, 2;

--Looking at particular countries
Select
  Location,
  date,
  total_deaths,
  total_cases,
  Try_cast(total_deaths as int) as conv_total_deaths,
  Try_cast(total_cases as int) as conv_total_cases,
  Case
   when total_cases = 0 Then Null
   Else TRY_CAST(total_deaths as int) / TRY_CAST(total_cases as int)*100 
  End as death_case_ratio
From [covid_proj.db]..covid_deaths
where location like '%Nigeria%'
Order by 1, 2;

--Looking at total_cases vs Population
--shows the percentage of the population with Covid

Select
  Location,
  date,
  population,
  total_cases,
  (total_cases/population)*100 as pop_infected
  From [covid_proj.db]..covid_deaths
where location like '%Nigeria%'
Order by 1, 2;


--countries with the higest infection Rate as compared to population

Select
  Location,date,population,Max(total_cases) as highest_infection_count, 
  Max((total_cases)/population)*100 as percentage_pop_infected
  From [covid_proj.db]..covid_deaths
--where location like '%Nigeria%'
group by Location, population,date
Order by percentage_pop_infected desc

--countries with the highest death count per population

Select
  Location,Max(Try_cast(total_deaths as int)) as total_deathcount
  From [covid_proj.db]..covid_deaths
--where location like '%Nigeria%'
where continent is not Null
group by Location,date 
Order by total_deathcount desc

--Going down to continents
Select
  continent,Max(Try_cast(total_deaths as int)) as total_deathcount
  From [covid_proj.db]..covid_deaths
--where location like '%Nigeria%'
where continent is not Null
group by continent,date 
Order by total_deathcount desc

Select
  location,Max(Try_cast(total_deaths as int)) as total_deathcount
  From [covid_proj.db]..covid_deaths
--where location like '%Nigeria%'
where continent is  Null
group by location,date 
Order by total_deathcount desc

--showing continents with the highest death count per population
Select
  continent,Max(Try_cast(total_deaths as int)) as total_deathcount
  From [covid_proj.db]..covid_deaths
--where location like '%Nigeria%'
where continent is not Null
group by location,date,continent 
Order by total_deathcount desc

--Global Numbers
SELECT 
    date,
    SUM(TRY_CAST(new_cases AS INT)) AS total_new_cases,
    TRY_CAST(SUM(TRY_CAST(new_cases AS INT)) AS INT) AS conv_new_cases,
    TRY_CAST(SUM(TRY_CAST(total_deaths AS INT)) AS INT) AS conv_total_deaths,
    TRY_CAST(SUM(TRY_CAST(total_cases AS INT)) AS INT) AS conv_total_cases,
    CASE
        WHEN SUM(TRY_CAST(new_cases AS INT)) = 0 THEN NULL
        WHEN SUM(TRY_CAST(total_cases AS INT)) = 0 THEN NULL
        WHEN SUM(TRY_CAST(total_deaths AS INT)) = 0 THEN NULL
        ELSE TRY_CAST(SUM(TRY_CAST(total_deaths AS INT)) AS INT) / TRY_CAST(SUM(TRY_CAST(total_cases AS INT)) AS INT) * 100
    END AS death_rate_ratio
FROM [covid_proj.db]..covid_deaths
-- WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

--Global numbers 2
Select date, sum(new_cases), Sum(cast(new_deaths as int))--total_new_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate_ratio
FROM [covid_proj.db]..covid_deaths
-- WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--Daily Global death percentages
SELECT 
    date,
    SUM(CAST(new_cases AS INT)) AS total_new_cases,
    SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS INT)) = 0 THEN NULL
        ELSE (SUM(CAST(new_deaths AS INT)) * 100.0) / NULLIF(SUM(CAST(new_cases AS INT)), 0)
    END AS deathpercentage
FROM [covid_proj.db]..covid_deaths
-- WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--new cases,new deaths percentages Globally
SELECT 
    SUM(CAST(new_cases AS INT)) AS total_new_cases,
    SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS INT)) = 0 THEN NULL
        ELSE (SUM(CAST(new_deaths AS INT)) * 100.0) / NULLIF(SUM(CAST(new_cases AS INT)), 0)
    END AS deathpercentage
FROM [covid_proj.db]..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Total population vs Vaccinations
---joining tables and exploring tables
Select*
From [covid_proj.db]..covid_deaths dea
join [covid_proj.db]..covid_vacines vac
    on dea.location = vac.location
	and dea.date = vac.date
-

--case1

	Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
From [covid_proj.db]..covid_deaths dea
join [covid_proj.db]..covid_vacines vac
    on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	order by 1,2,3Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
From [covid_proj.db]..covid_deaths dea
join [covid_proj.db]..covid_vacines vac
    on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	order by 1,2,3

	---case2

	Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
From [covid_proj.db]..covid_deaths dea
join [covid_proj.db]..covid_vacines vac
    on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	order by 1,2,3Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
From [covid_proj.db]..covid_deaths dea
join [covid_proj.db]..covid_vacines vac
    on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	order by 2,3

SELECT
    dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea.date)
	AS Rolling_people_vaccinated
FROM [covid_proj.db]..covid_deaths dea
JOIN [covid_proj.db]..covid_vacines vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--USE CTE
with popvsVacc (continent, Location,Date, Population,new_vaccinations, Rolling_people_vaccinated)
as
(
SELECT
    dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea.date)
	AS Rolling_people_vaccinated
FROM [covid_proj.db]..covid_deaths dea
JOIN [covid_proj.db]..covid_vacines vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
Select*, (Rolling_people_vaccinated/Population)*100
From popvsVacc

--Temp Table

Drop Table if exists #percentofpopulationVaccinated
Create Table #percentofpopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date  datetime,
Population numeric,
New_vaccinations numeric,
Rolling_people_vaccinated numeric
)
 Insert into #percentofpopulationVaccinated
 SELECT
    dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations))OVER (PARTITION BY dea.location Order by dea.location, dea.date)
	AS Rolling_people_vaccinated
FROM [covid_proj.db]..covid_deaths dea
JOIN [covid_proj.db]..covid_vacines vac
    ON dea.location = vac.location
    AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
Select*, (Rolling_people_vaccinated/Population)*100
From #percentofpopulationVaccinated

--Creating views to store data for later visualization
 
Create view percentofpopulationVaccinated as
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations))OVER (PARTITION BY dea.location Order by dea.location, dea.date)
	AS Rolling_people_vaccinated
FROM [covid_proj.db]..covid_deaths dea
JOIN [covid_proj.db]..covid_vacines vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

Select* 
From percentofpopulationVaccinated



















