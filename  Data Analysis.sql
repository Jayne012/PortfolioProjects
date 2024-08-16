-- EXploring layoffs data for Data Analysis


select *
from layoffs_staging2
;

SELECT MAX(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

-- Company with high layoffs
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

 
select min(`date`), max(`date`)
from layoffs_staging2;

-- industry/country with the biggest layoffs 
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;


select *
from layoffs_staging2;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select YEAR(`DATE`), sum(total_laid_off)
from layoffs_staging2
group by YEAR(`DATE`)
order by 1 desc;

-- Stage of the compnay 
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- progression of layoffs 
SELECT SUBSTRING(date,1,7) as `MONTH`, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL 
GROUP BY `MONTH`
ORDER BY 1 ASC;


-- ROlling Total of laid_off
WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) as `MONTH`, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, Total_laid_off,SUM(Total_laid_off) OVER (ORDER BY `MONTH`) as rolling_total_layoffs
FROM Rolling_Total;


-- Companies lay_offs per year 

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

 SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
  order by company asc;
  
-- year with bigger layoff
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  where total_laid_off is not null
  GROUP BY company, YEAR(`date`)
  order by 3 asc;

WITH Company_Year (Company, Years, Total_laid_off) as
(
  SELECT company, YEAR(`date`), SUM(total_laid_off) 
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
)
select*
from company_year;


WITH Company_Year (Company, Years, Total_laid_off) as
(
  SELECT company, YEAR(`date`), SUM(total_laid_off) 
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
)
select*
from company_year;

-- partition and ranking to see which company laid off the most employee in a year.

WITH Company_Year (Company, Years, Total_laid_off) as
(
  SELECT company, YEAR(`date`), SUM(total_laid_off) 
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
),Company_Year_Rank AS 
(
select*, Dense_rank() over(Partition by years order by total_laid_off desc) As Ranking
from company_year
where years is not null
)
select *
from Company_Year_Rank
where Ranking <=5
order by years desc
;

SELECT *
FROM layoffs_staging2;

-- Seeing Company with highest number of lay_off by location 

SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- Company,country and industry with lay_off above or equal to 200
select country, industry,company,sum(total_laid_off) as Total_laid_off
from layoffs_staging2
where  Total_laid_off is not null
group by country, industry,company
having  Total_laid_off >= 200
order by 2 desc
limit 50;










