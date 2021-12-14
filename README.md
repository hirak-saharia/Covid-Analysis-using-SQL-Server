# Covid-Analysis-using-MYSQL

We have imported Covid deaths and Vacination to analysis....

Queries performed....

To find the table information....
>>>>Select * From covidproject.coviddeaths2 Where continent is not null order by 3,4
    OR >>>SELECT * FROM covidproject.coviddeaths2;

-- Selected Data that we are going to be starting with

 >>>>SELECT location, date, total_cases, new_cases, total_deaths, population From covidproject.coviddeaths2 Where continent is not null order by 1,2
 
 -- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

 >>>>> Select location, date, total_cases,total_deaths, (total_deaths/total_cases) From covidproject.coviddeaths2 order by 1,2
 >>>>> Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From covidproject.coviddeaths2
where location like '%states%'
order by 1,2
