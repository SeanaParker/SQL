# US Household Income Project (Exploratory Data Analysis)

-- Display the top 10 states with the largest land area.
SELECT
    State_Name,
    SUM(ALand) AS Total_Land_Area,
    SUM(AWater) AS Total_Water_Area
FROM US_Household_Income
GROUP BY State_Name
ORDER BY Total_Water_Area DESC
LIMIT 10
;
-- Insight: The top 3 states with the largest water areas are Michigan, Florida, and Wisconsin.

-- Display the top 5 states with the lowest average income.
SELECT 
    u.State_Name,
    ROUND(AVG(Mean), 1) AS Avg_Income_Mean,
    ROUND(AVG(Median), 1) AS Avg_Income_Median
FROM US_Household_Income u
INNER JOIN US_Household_Income_Statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Income_Mean
LIMIT 5
;
-- Insight: Mississippi, West Virginia, and Arkansas consistently rank among the lowest for both mean and median income, possibly reflecting economic challenges tied to rural employment.

-- Display the top 10 states with the highest average income.
SELECT 
    u.State_Name,
    ROUND(AVG(Mean), 1) AS Avg_Income_Mean,
    ROUND(AVG(Median), 1) AS Avg_Income_Median
FROM US_Household_Income u
INNER JOIN US_Household_Income_Statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Income_Mean DESC
LIMIT 10
;
-- Insight: Washington D.C., Connecticut, and New Jersey show the highest average household income.

-- Display the top 10 states with the lowest median income.
SELECT 
    u.State_Name,
    ROUND(AVG(Mean), 1) AS Avg_Income_Mean,
    ROUND(AVG(Median), 1) AS Avg_Income_Median
FROM US_Household_Income u
INNER JOIN US_Household_Income_Statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Income_Median
LIMIT 10
;
-- Insight: Arkansas, Mississippi, and Louisiana lead in states with the lowest median income.

-- Display the top 10 states with the highest median income.
SELECT 
    u.State_Name,
    ROUND(AVG(Mean), 1) AS Avg_Income_Mean,
    ROUND(AVG(Median), 1) AS Avg_Income_Median
FROM US_Household_Income u
INNER JOIN US_Household_Income_Statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Income_Median DESC
LIMIT 10
;
-- Insight: New Jersey, Connecticut, and Massachusetts have the highest median income, reflecting a wealthier population and higher cost of living.

-- Display the top 20 Types based on the highest average Mean income.
-- Filter out low outliers by ensuring the count of each Type is greater than 100.
SELECT 
    Type,
    COUNT(Type) AS Type_Count,
    ROUND(AVG(Mean), 1) AS Avg_Income_Mean,
    ROUND(AVG(Median), 1) AS Avg_Income_Median
FROM US_Household_Income u
INNER JOIN US_Household_Income_Statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY Avg_Income_Median DESC
LIMIT 20
;
-- Insight: CDPs have the highest median income, likely reflecting affluent suburban or residential communities, while towns and cities tend to have a broader income range, leading to lower median incomes.

-- Explore average Mean and Median income by State and City.
-- Order results by the highest average Mean and Median income.
SELECT
    u.State_name, 
    City, 
    ROUND(AVG(Mean), 1) AS Avg_Income_Mean, 
    ROUND(AVG(Median), 1) AS Avg_Income_Median
FROM US_Household_Income u
INNER JOIN US_Household_Income_Statistics us
    ON u.id = us.id
GROUP BY u.State_name, City
ORDER BY Avg_Income_Mean DESC, Avg_Income_Median DESC
LIMIT 5
;
-- Insight: Delta Junction, AK, Short Hills, NJ, and Narberth, PA, have some of the highest average and median incomes, indicating these areas are likely home to affluent professionals or specialized industries.
