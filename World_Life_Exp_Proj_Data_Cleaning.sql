# World Life Expectancy Project (Data Cleaning)

-- Explore the dataset.
SELECT * 
FROM world_life_expectancy
LIMIT 100;

-- Identify duplicate rows based on 'Country' and 'Year'.
SELECT 
    Country, 
    Year, 
    COUNT(*) AS duplicate_count
FROM world_life_expectancy
GROUP BY Country, Year
HAVING COUNT(*) > 1;

-- Identify Row_ID of duplicate rows for removal.
SELECT *
FROM (
    SELECT 
        Row_ID,
        ROW_NUMBER() OVER(PARTITION BY Country, Year ORDER BY Row_ID) AS row_num
    FROM world_life_expectancy
) AS duplicates
WHERE row_num > 1;

-- Delete duplicates by Row_ID.
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
    SELECT Row_ID
    FROM (
        SELECT 
            Row_ID,
            ROW_NUMBER() OVER(PARTITION BY Country, Year ORDER BY Row_ID) AS row_num
        FROM world_life_expectancy
    ) AS duplicates
    WHERE row_num > 1
);

-- Identify rows with blank or NULL 'Status'.
SELECT * 
FROM world_life_expectancy
WHERE Status = '' OR Status IS NULL;

-- Verify distinct non-empty 'Status' values.
SELECT DISTINCT Status
FROM world_life_expectancy
WHERE Status <> '';

-- Update blank 'Status' to 'Developing' based on matching rows.
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = '' AND t2.Status = 'Developing';

-- Update blank 'Status' to 'Developed' similarly.
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = '' AND t2.Status = 'Developed';

-- Confirm no blank 'Status' remains.
SELECT DISTINCT Status
FROM world_life_expectancy;

-- Identify rows with blank 'Lifeexpectancy'.
SELECT * 
FROM world_life_expectancy
WHERE Lifeexpectancy = '';

-- Calculate average 'Lifeexpectancy' from adjacent years.
SELECT 
    t1.Country, 
    t1.Year, 
    ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2, 1) AS avg_lifeexp
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country AND t1.Year = t3.Year + 1
WHERE t1.Lifeexpectancy = '';

-- Update blank 'Lifeexpectancy' values.
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country AND t1.Year = t3.Year + 1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2, 1)
WHERE t1.Lifeexpectancy = '';

-- Verify no blank 'Lifeexpectancy' remains.
SELECT * 
FROM world_life_expectancy
WHERE Lifeexpectancy = '';
