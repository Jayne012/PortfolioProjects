-- Data Cleaning 

select * 
from layoffs;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways


create table layoffs_staging
like layoffs;

SELECT *
FROM layoffs_staging;

insert layoffs_staging
select *
from layoffs;

-- 1. check for duplicates and remove any

SELECT *,
Row_number() over(
PARTITION BY company, industry, total_laid_off, percentage_laid_off,`date`) AS row_num
FROM layoffs_staging;


with duplicate_CTE as 
(
	SELECT *,
	Row_number() over(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging
)
select *
from duplicate_CTE
where row_num >1;

SELECT *
FROM layoffs_staging
where company ='Ola';


with duplicate_CTE as 
(
	SELECT *,
	Row_number() over(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging
)
select *
from duplicate_CTE
where row_num >1;


CREATE TABLE `layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT default null,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int default null,
row_num INT
);



SELECT *
FROM layoffs_staging2;

insert into layoffs_staging2
SELECT *,
	Row_number() over(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging;


SELECT *
FROM layoffs_staging2
where row_num >1;

delete 
FROM layoffs_staging2
where row_num > 1;

SELECT *
FROM layoffs_staging2
where row_num >1;

SELECT *
FROM layoffs_staging2;

-- standardizing data

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2;
-- I also noticed the Crypto has multiple different variations.
SELECT *
FROM layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry ='crypto'
where industry like 'crypto%';

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United state%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter table layoffs_staging2
modify column `date` DATE;

SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
where total_laid_off is  NULL
and percentage_laid_off is 	NULL;

SELECT *
FROM layoffs_staging2
where industry is null
or industry = ''; 

SELECT *
FROM layoffs_staging2
where company = 'Airbnb';

-- Trying to populate null or blank cell
SELECT *
FROM layoffs_staging2
where company = ' Airbnb' ;


SELECT *
FROM layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
where (t1.industry is null or t1.industry = ' ')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

update layoffs_staging2
set industry = 'Travel'
where company = 'Airbnb';




UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

select *
from layoffs_staging2
where location = 'Providence' 
;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';

 -- remove unwanted columns and rows 

select *
from layoffs_staging2;

 SELECT *
FROM layoffs_staging2
where total_laid_off is  NULL
and percentage_laid_off is 	NULL;

Delete 
FROM layoffs_staging2
where total_laid_off is  NULL
and percentage_laid_off is 	NULL;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;






