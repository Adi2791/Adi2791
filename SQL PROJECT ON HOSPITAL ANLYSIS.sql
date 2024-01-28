  select *
from [my pro]..dataset$

--How many total deaths occured in the hospital and what was the percentage of the mortality rate?

UPDATE dataset$
SET ethnicity = CASE
    WHEN ethnicity = '' THEN 'Mixed'
    ELSE ethnicity
    END;

SELECT COUNT(CASE WHEN hospital_death = 1 THEN 1 END) AS total_hospital_deaths, 
ROUND(COUNT(CASE WHEN hospital_death = 1 THEN 1 END)*100/COUNT(*),2) AS mortality_rate
FROM [my pro]..dataset$


--What was the death count of each ethnicity? 

SELECT ethnicity, COUNT(hospital_death) as total_hospital_deaths
FROM [my pro]..dataset$
WHERE hospital_death = '1'
GROUP BY ethnicity 
order by 2 desc

-- What was the death count of each gender? 

SELECT gender, COUNT(hospital_death) as total_hospital_deaths
FROM [my pro]..dataset$
WHERE hospital_death = '1'
GROUP BY gender 

-- Comparing the average and max ages of patients who died and patients who survived

SELECT ROUND(AVG(age),2) as avg_age,
MAX(age) as max_age, 
hospital_death
FROM [my pro]..dataset$
WHERE hospital_death = '1'
GROUP BY hospital_death
UNION
SELECT ROUND(AVG(age),2) as avg_age,
MAX(age) as max_age, 
hospital_death
FROM [my pro]..dataset$
WHERE hospital_death = '0'
GROUP BY hospital_death

--Comparing the amount of patients that died and survived by each age 

SELECT age,
	COUNT(CASE WHEN hospital_death = '1' THEN 1 END) as amount_that_died,
	COUNT(CASE WHEN hospital_death = '0' THEN 1 END) as amount_that_survived
FROM [my pro]..dataset$
GROUP BY age
ORDER BY age ASC;

--Age distribution of patients in 10-year intervals 

SELECT 
    CONCAT(FLOOR(age/10)*10, '-', FLOOR(age/10)*10+9) AS age_interval,
    COUNT(*) AS patient_count
FROM [my pro].dbo.dataset$
GROUP BY age
ORDER BY age_interval;

-- Amount of patients above 65 who died vs Amount of patients between 50-65 who died

SELECT COUNT(CASE WHEN age > 65 AND hospital_death = '0' THEN 1 END) as survived_over_65,
       COUNT(CASE WHEN age BETWEEN 50 AND 65 AND hospital_death = '0' THEN 1 END) as survived_between_50_and_65,
       COUNT(CASE WHEN age > 65 AND hospital_death = '1' THEN 1 END) as died_over_65,
       COUNT(CASE WHEN age BETWEEN 50 AND 65 AND hospital_death = '1' THEN 1 END) as died_between_50_and_65
FROM [my pro]..dataset$

--- Calculating the average probability of hospital death for patients of different age groups

sELECT
    CASE
        WHEN age < 40 THEN 'Under 40'
        WHEN age >= 40 AND age < 60 THEN '40-59'
        WHEN age >= 60 AND age < 80 THEN '60-79'
        ELSE '80 and above'
    END AS age_group,
    ROUND(AVG(apache_4a_hospital_death_prob),3) AS average_death_prob
FROM [my pro]..dataset$
GROUP BY age
order by 2 asc

--which admit source of the ICU did most patients die in and get admitted to

SELECT DISTINCT icu_admit_source,
	COUNT(CASE WHEN hospital_death = '1' THEN 1 END) as amount_that_died,
	COUNT(CASE WHEN hospital_death = '0' THEN 1 END) as amount_that_survived
FROM [my pro]..dataset$
GROUP BY icu_admit_source;

-- Average age of people in each ICU admit source and amount that died

SELECT DISTINCT icu_admit_source,
	COUNT(hospital_death) as amount_that_died,
	ROUND(AVG(age),2) as avg_age
FROM [my pro]..dataset$
WHERE hospital_death = '1'
GROUP BY icu_admit_source

--- Average age of people in each type of ICU and amount that died
 
 select  distinct icu_type,
 COUNT(hospital_death) as amount_that_died,
	ROUND(AVG(age),2) as avg_age
FROM [my pro]..dataset$
WHERE hospital_death = '1'
GROUP BY icu_type
order by 2 desc

-- Average age of people in each type of ICU and amount that survived

select distinct icu_type,
COUNT(hospital_death) as amount_that_survived,
	ROUND(AVG(age),2) as avg_age
FROM [my pro]..dataset$
WHERE hospital_death = '0'
GROUP BY icu_type
order by 2 desc

--what were the  ethnicities with the highest BMI? 

select distinct  ethnicity,   ROUND(AVG(bmi),2) AS average_bmi
from [my pro]..dataset$
group by ethnicity
order by average_bmi desc

--How many patients are suffering from each comorbidity? 

SELECT
    SUM(aids) AS patients_with_aids,
    SUM(cirrhosis) AS patients_with_cirrhosis,
    SUM(diabetes_mellitus) AS patients_with_diabetes,
    SUM(hepatic_failure) AS patients_with_hepatic_failure,
    SUM(immunosuppression) AS patients_with_immunosuppression,
    SUM(leukemia) AS patients_with_leukemia,
    SUM(lymphoma) AS patients_with_lymphoma,
    SUM(solid_tumor_with_metastasis) AS patients_with_solid_tumor
FROM [my pro]..dataset$;

 --What was the percentage of patients with each comorbidity among those who died?

SELECT
    ROUND(SUM(CASE WHEN aids = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS aids_percentage,
    ROUND(SUM(CASE WHEN cirrhosis = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS cirrhosis_percentage,
    ROUND(SUM(CASE WHEN diabetes_mellitus = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS diabetes_percentage,
    ROUND(SUM(CASE WHEN hepatic_failure = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS hepatic_failure_percentage,
    ROUND(SUM(CASE WHEN immunosuppression = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS immunosuppression_percentage,
    ROUND(SUM(CASE WHEN leukemia = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS leukemia_percentage,
    ROUND(SUM(CASE WHEN lymphoma = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS lymphoma_percentage,
    ROUND(SUM(CASE WHEN solid_tumor_with_metastasis = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS solid_tumor_percentage
FROM [my pro]..dataset$
WHERE hospital_death = 1;

--What is the mortality rate in percentage?

SELECT 
ROUND(COUNT(CASE WHEN hospital_death = 1 THEN 1 END)*100/COUNT(*),2) AS mortality_rate
FROM [my pro]..dataset$

--- What was the percentage of patients who underwent elective surgery?

SELECT
    COUNT(CASE WHEN elective_surgery = 1 THEN 1 END)*100/COUNT(*) AS elective_surgery_percentage
FROM [my pro]..dataset$

-- What was the average weight and height for male & female patients who underwent elective surgery?

SELECT
    ROUND(AVG(CASE WHEN gender = 'M' THEN weight END),2) AS avg_weight_male,
    ROUND(AVG(CASE WHEN gender = 'M' THEN height END),2) AS avg_height_male,
    ROUND(AVG(CASE WHEN gender = 'F' THEN weight END),2) AS avg_weight_female,
    ROUND(AVG(CASE WHEN gender = 'F' THEN height END),2) AS avg_height_female
	FROM [my pro]..dataset$
	WHERE elective_surgery='1'

	--- What were the top 10 ICUs with the highest hospital death probability? 

	SELECT icu_id, 
	apache_4a_hospital_death_prob as hospital_death_prob
FROM [my pro]..dataset$
ORDER BY apache_4a_hospital_death_prob DESC

 --What was the average length of stay at each ICU for patients who survived and those who didn't? 
 SELECT
    icu_type,
    ROUND(AVG(CASE WHEN hospital_death = 1 THEN pre_icu_los_days END), 2) AS avg_icu_stay_death,
    ROUND(AVG(CASE WHEN hospital_death = 0 THEN pre_icu_los_days END), 2) AS avg_icu_stay_survived
 FROM [my pro]..dataset$
GROUP BY icu_type
ORDER BY icu_type;

 --What was the average BMI for patients that died based on ethnicity? (excluding missing or null values)
 SELECT ethnicity ,
 round(avg(bmi),2) as avg_bmi
 from [my pro]..dataset$
 where hospital_death='1'
 and bmi is not null
 group by ethnicity
 order by 2 desc

 --- What was the death percentage for each ethnicity? 
 SELECT
    ethnicity,
    ROUND(COUNT(CASE WHEN hospital_death = 1 THEN 1 END) * 100 / (SELECT COUNT(*) FROM [my pro]..dataset$), 2) AS death_percentage
FROM [my pro]..dataset$
GROUP BY ethnicity;

 --Finding out how many patients are in each BMI category based on their BMI value?

 SELECT
    COUNT(*) AS patient_count,
    CASE
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category
FROM (
    SELECT
        patient_id,
        ROUND(bmi, 2) AS bmi
    FROM [my pro]..dataset$
    WHERE bmi IS NOT NULL
) AS subquery
GROUP BY bmi

-- Hospital death probabilities where the ICU type is 'SICU' and BMI is above 30

SELECT
    patient_id,
    apache_4a_hospital_death_prob as hospital_death_prob
from [my pro]..dataset$
where icu_type ='sicu'
and bmi > 30
ORDER BY hospital_death_prob DESC;

