# World Life Expectancy Project (Exploratory Data Analysis)

-- Identify countries with the largest increase in life expectancy over the past 15 years.
SELECT 
	Country,
    MIN(Lifeexpectancy) as min,
    MAX(Lifeexpectancy) as max,
    ROUND(MAX(Lifeexpectancy)-MIN(Lifeexpectancy),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0
	AND MAX(Lifeexpectancy) <> 0
ORDER BY Life_Increase_15_Years DESC
;
-- Insight: Haiti shows the highest improvement in life expectancy (28.7 years), followed by Zimbabwe and Eritrea.

-- Calculate global average life expectancy for each year to observe overall trends.
SELECT 
	Year,
    ROUND(AVG(Lifeexpectancy),2)
FROM world_life_expectancy
WHERE Lifeexpectancy <> 0
GROUP BY Year 
ORDER BY Year
;
-- Insight: Over 15 years, global average life expectancy rose from 66.75 to 71.62, growing by ~7.5%. This indicates steady progress in global health.

-- Analyze the relationship between GDP and life expectancy for all countries.
SELECT 
	Country, 
    ROUND(AVG(Lifeexpectancy),1) as Life_Exp, 
    ROUND(AVG(GDP),1) as GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;
-- Insight: Countries with lower GDPs tend to have below-average life expectancy, suggesting a potential link between economic wealth and health outcomes.

-- Compare average life expectancy for high and low GDP countries using a threshold of 1750, the approximate median GDP value in the dataset.
SELECT 
SUM(CASE WHEN GDP >= 1750 THEN 1 ELSE 0 END) AS High_GDP_Count,
AVG(CASE WHEN GDP >= 1750 THEN Lifeexpectancy ELSE NULL END) AS High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1750 THEN 1 ELSE 0 END) AS Low_GDP_Count,
AVG(CASE WHEN GDP <= 1750 THEN Lifeexpectancy ELSE NULL END) AS Low_GDP_Life_Expectancy
FROM world_life_expectancy
;
-- Insight: High GDP countries average ~74 years in life expectancy, while low GDP countries average ~65 years. This highlights disparities in health outcomes linked to economic status.

-- Compare life expectancy for developed and developing countries, including the number of countries in each category.
SELECT 
	Status,
    ROUND(AVG(Lifeexpectancy),1),
    COUNT(DISTINCT Country)
FROM world_life_expectancy
GROUP BY Status
;
-- Insight: Developed countries have a higher average life expectancy (~79 years) than developing countries (~67 years). However, the dataset is dominated by developing countries (161 vs. 32), which may skew global trends.

-- Explore the relationship between BMI and life expectancy across countries using BMI categories.
WITH CountryStats AS (
SELECT 
	Country, 
    ROUND(AVG(Lifeexpectancy),1) as Life_Exp, 
    ROUND(AVG(BMI),1) as BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
	AND BMI > 0
ORDER BY Life_Exp DESC
),

LifeExp_w_Avg AS (
SELECT 
	Country,
    Life_Exp,
    BMI,
    ROUND(AVG(Life_Exp) OVER(),1) AS Total_Avg_Life_Exp
FROM CountryStats
ORDER BY Life_Exp DESC)

SELECT
	*,
    CASE
		WHEN Life_Exp > Total_Avg_Life_Exp THEN 'Above Average'
        WHEN Life_Exp = Total_Avg_Life_Exp THEN 'Average'
        ELSE 'Below Average'
	END AS Life_Exp_Avg_Status,
    CASE
		WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal BMI'
        WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obesity'
	END AS BMI_Status,
	IF(Life_Exp > Total_Avg_Life_Exp AND BMI > 25, 'Odd', '') AS Odd_Status
FROM LifeExp_w_Avg
ORDER BY Life_Exp DESC
;
-- Insight: Countries with above-average life expectancy tend to have high BMIs. However, BMI alone may not fully explain variations in life expectancy.

-- Analyze adult mortality trends for each country over the past 15 years, focusing on cumulative totals and rates of change. 
WITH RollingTotals AS (
    SELECT 
        Country,
        Year,
        Lifeexpectancy,
        AdultMortality,
        SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY Year) AS 
        rolling_total
    FROM world_life_expectancy
)
SELECT 
    Country,
    Year,
    Lifeexpectancy,
    AdultMortality,
    rolling_total,
    CASE 
        WHEN LAG(rolling_total) OVER(PARTITION BY Country ORDER BY Year) IS NOT 
        NULL THEN 
            ROUND(
                (rolling_total - LAG(rolling_total) OVER(PARTITION BY Country 
                 ORDER BY Year))/ LAG(rolling_total) OVER(PARTITION BY Country 
                 ORDER BY Year) * 100, 2)
        ELSE NULL 
    END AS rolling_total_rate_of_change
FROM RollingTotals
;
-- Insight: Cumulative adult mortality shows an overall upward trend, though the rate of change decreases over time. Periodic spikes may be linked to conflicts or natural disasters. 
-- Adding population data could provide more context by showing mortality trends relative to population size.