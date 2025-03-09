# US Household Income Project (Data Cleaning)
-- For this SQL project, I analyzed a dataset called "US Household Income," which includes tables for income data, geographic locations, and area types. 
-- The focus was on cleaning the data, addressing duplicates, standardizing formats, and correcting errors.

    
-- Explore the datasets
SELECT * 
FROM US_Household_Income
LIMIT 100
;

SELECT * 
FROM US_Household_Income_Statistics
LIMIT 100
;

-- Identify duplicate records based on 'id'
SELECT
    id,
    COUNT(id) AS duplicate_count
FROM US_Household_Income
GROUP BY id
HAVING COUNT(id) > 1
;

-- Remove duplicate records by retaining only the first occurrence
DELETE FROM US_Household_Income
WHERE 
    row_id IN (
    SELECT row_id
    FROM (
        SELECT 
            row_id, 
            id,
            ROW_NUMBER() OVER (
                PARTITION BY id
                ORDER BY id) AS row_num
        FROM US_Household_Income
    ) duplicates
    WHERE row_num > 1
)
;

-- Fix data quality issues: correct typos and standardize text formats
UPDATE US_Household_Income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia' -- Fix typo in state name
;

UPDATE US_Household_Income
SET County = UPPER(County) -- Standardize county names to uppercase
;

UPDATE US_Household_Income
SET City = UPPER(City) -- Standardize city names to uppercase
;

UPDATE US_Household_Income
SET Place = UPPER(Place) -- Standardize place names to uppercase
;

UPDATE US_Household_Income
SET State_Name = UPPER(State_Name) -- Standardize state names to uppercase
;

-- Standardize 'Type' field values for consistency
UPDATE US_Household_Income
SET `Type` = 'CDP'
WHERE `Type` = 'CPD'
;

UPDATE US_Household_Income
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs'
;

-- Validate 'ALand' and 'AWater' fields to identify problematic rows
SELECT 
    ALand, 
    AWater
FROM US_Household_Income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
    AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;
