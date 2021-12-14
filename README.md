# Covid-Analysis-using-MYSQL

We have imported Covid deaths and Vacination to analysis....

Queries performed....

To find the table information....
>>>>Select *From CovidAnalysis..CovidDeaths order by 3,4

>>>>>Select * From CovidAnalysis..CovidVacciantion order by 3,4

-- Selected Data that we are going to be starting with

 >>>>SELECT location, date, total_cases, new_cases, total_deaths, population 
    From CovidAnalysis..CovidDeaths
    order by 1,2
 
 -- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

 >>>>> Select location, date, total_cases,total_deaths, (total_deaths/total_cases) From covidproject.coviddeaths2 order by 1,2
 >>>>> SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
       From CovidAnalysis..CovidDeaths
       order by 1,2
 
  -- Shows likelihood of dying if you contract covid in your country
      >>>SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
      From CovidAnalysis..CovidDeaths
      where location like '%States%' OR where location like '%IND%'
      order by 1,2
 
 --Looking at the total Cases vs Population
 --Shows what percentage of populations got covid

    >>>SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulation
    From CovidAnalysis..CovidDeaths
    where location like '%IND%'
    order by 1,2
    
    
