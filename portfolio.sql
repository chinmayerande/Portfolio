use covid;
select * from coviddeaths;


SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    coviddeaths
WHERE
    continent != ''
ORDER BY location , date ASC;

-- Ratio of total deaths to total cases

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population,
    (total_deaths / total_cases) * 100 AS Death_Percentage
FROM
    coviddeaths
WHERE
    continent!=' '
ORDER BY location , date ASC;


-- Total cases vs population
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS Infection_rate
FROM
    coviddeaths
WHERE
   continent !=' '
ORDER BY location , date ASC;



-- Finding Highest Infection rate

SELECT 
    location,
    population,
    MAX(total_cases) AS max_total_cases,
    MAX(total_cases / population) * 100 AS infection_rate_by_country
FROM
    coviddeaths
WHERE
    continent != ''
GROUP BY location , population
ORDER BY Infection_rate_by_country DESC;

-- Faeroe Islands have had the highest percentage infection

-- Finding highest total deaths


SELECT 
    location, population, MAX(total_deaths) AS deaths
FROM
    coviddeaths
WHERE
    continent != ''
GROUP BY location , population
ORDER BY deaths DESC;

-- US has the max total deaths

-- continent wise


SELECT 
    continent, SUM(new_deaths) AS deaths
FROM
    coviddeaths
GROUP BY continent
ORDER BY deaths ASC;


-- Global Numbers
-- Death Percentage on a given day 
SELECT 
    date,
    SUM(new_cases) AS total_cases_on_that_day,
    SUM(new_deaths) AS total_deaths_on_that_day,
    SUM(new_deaths) / SUM(new_cases) * 100 AS death_percentage
FROM
    coviddeaths
WHERE
    continent != ''
GROUP BY date
ORDER BY death_percentage desc;

-- Total death percentage


SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS death_percentage
FROM
    coviddeaths
WHERE
    continent != '';
    
-- no of people vaccinated
select cd.continent, cd.location,cd.date,cd.population,c.new_vaccinations ,
sum(new_vaccinations) over(partition by location order by date asc) as rolling_total
from covid_vaccinations
c join 
coviddeaths cd
on c.date=cd.date
and
c.location=cd.location
where cd.continent!='';

-- percentage of population vaccinated

create view vaccination as 

(select cd.continent, cd.location,cd.date,cd.population,c.new_vaccinations ,
sum(new_vaccinations) over(partition by location order by date asc) as rolling_total
from covid_vaccinations
c join 
coviddeaths cd
on c.date=cd.date
and
c.location=cd.location
where cd.continent!='');

SELECT 
    continent,
    location,
    population,
    MAX(rolling_total) AS vaccines_administered,
    MAX(rolling_total) / population AS no_of_vaccines_per_capita
FROM
    vaccination
GROUP BY continent , location , population
ORDER BY continent , location;


