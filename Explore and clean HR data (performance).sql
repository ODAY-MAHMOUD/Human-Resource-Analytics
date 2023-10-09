SELECT * FROM HR_Employee_Performance

------------------------------------------------------------
-- The stage of exploring, cleaning and processing the data
------------------------------------------------------------


--Find out the empty values

SELECT *
  FROM HR_Employee_Performance
  WHERE 
      [employee_id]          is null OR
      [department]           is null OR
      [region]               is null OR
      [education]            is null OR
      [gender]               is null OR
      [recruitment_channel]  is null OR
      [no_of_trainings]      is null OR
      [age]                  is null OR
      [previous_year_rating] is null OR
      [length_of_service]    is null OR
      [KPIs_met_more_than_80] is null OR
      [awards_won]           is null OR
      [avg_training_score]   is null
	  

--replace the empty values
       
   -- I will replace the empty values in the (Education) column with the most frequent values
        
	   --the most frequent values was (Bachelors)
	   SELECT education,COUNT(*) AS EmployeeCount FROM HR_Employee_Performance
	   GROUP BY education 
	   ORDER BY EmployeeCount DESC

	   --Replace empty values (Bachelors)
	   UPDATE HR_Employee_Performance
	   SET education = CASE WHEN education IS NULL THEN 'Bachelors' ELSE education END;

   --Replace the blank values in (previous year's rating) with the average rating
       -- The AVG WAS (3)
	   SELECT AVG(previous_year_rating) FROM HR_Employee_Performance

	   --Replace empty values (3)
	   UPDATE HR_Employee_Performance
	   SET previous_year_rating = CASE WHEN previous_year_rating IS NULL THEN 3 ELSE previous_year_rating END



--Identify duplicate columns
 
 SELECT 
 employee_id, department, region, education, gender, recruitment_channel,
 no_of_trainings, age, previous_year_rating, length_of_service
 KPIs_met_more_than_80, awards_won, avg_training_score, 
 COUNT(*) AS Count
FROM HR_Employee_Performance
GROUP BY 
employee_id, department, region, education, gender, recruitment_channel,
no_of_trainings, age, previous_year_rating, length_of_service,
KPIs_met_more_than_80, awards_won, avg_training_score
HAVING COUNT(*) > 1;


-- Remove Duplicate Value Using CTE

SELECT employee_id,COUNT(*) CountRow FROM HR_Employee_Performance
GROUP BY employee_id
HAVING COUNT(*) > 1

WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY employee_id
			   order by employee_id
           ) AS ROW_Num
    FROM HR_Employee_Performance
)
delete   
FROM RowNumCTE
WHERE ROW_Num > 1



-- ADD Primary key 
ALTER TABLE HR_Employee_Performance
ADD PRIMARY KEY (employee_id)

---------------------------------------------
--The effect of the (Department) on performance
---------------------------------------------

-- A query to calculate the percentage of people who achieved KPIs in each department(KPIs_met_more_than_80)

SELECT
    department,
	COUNT(*) AS Total_Employees,
    SUM(CASE WHEN KPIs_met_more_than_80 > 0 THEN 1 ELSE 0 END) AS Employees_with_KPIs_met,
    
    (SUM(CASE WHEN KPIs_met_more_than_80 > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS KPIs_Met_Percentage
FROM
    HR_Employee_Performance
GROUP BY
    department
ORDER BY
    KPIs_Met_Percentage DESC;




-- Calculating the average training score relative to the number of employees in each department(avg_training_score)


	SELECT
    department,
    COUNT(*) AS Total_Employees,
	AVG(avg_training_score) Average_Training,
    cast(cast(AVG(avg_training_score)as float) * 100 / SUM(COUNT(*)) OVER ()*100 as decimal(10,2)) AS Average_Training_Score
FROM
    HR_Employee_Performance
GROUP BY
    department
ORDER BY
    Average_Training_Score DESC;


	-- Calculate the average rating of the previous year and
	--its percentage in relation to the number of employees in each department (previous_year_rating).


	SELECT
    department,
    COUNT(*) AS Total_Employees,
	AVG(previous_year_rating) Average_previous_year_rating,
    cast(cast(AVG(previous_year_rating)as float) / SUM(COUNT(*)) OVER ()*100 as decimal(10,4)) AS AVG_previous_year_rating
FROM
    HR_Employee_Performance
GROUP BY
    department
ORDER BY
    Average_previous_year_rating DESC;


-- Calculating the number of employees and the percentage of people who received awards in each department(awards_won).

SELECT
    department,
	COUNT(*) AS Total_Employee,
	SUM(CASE WHEN awards_won = 1 THEN 1 ELSE 0 END) as Count_Employee,
    CAST(SUM(CASE WHEN awards_won = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)AS decimal(10,2)) AS Awards_Won_Percentage
FROM
    HR_Employee_Performance
GROUP BY
    department 
	ORDER BY Awards_Won_Percentage

---------------------------------------------------
--Calculating the (region’s) influence on performance
---------------------------------------------------


-- Calculate the average percentage of achieving KPIs greater than 80% for each region(KPIs_met_more_than_80)

		SELECT region FROM HR_Employee_Performance
		group by region
		order by region desc


SELECT
    region,
    COUNT(*) AS Total_Employee,
    cast(CAST(SUM(CASE WHEN KPIs_met_more_than_80 > 0 THEN 1 ELSE 0 END) AS float) /
    CAST(COUNT(*) AS float)as decimal(10,2)) AS Average_KPIs_Met
FROM
    HR_Employee_Performance
GROUP BY
    region
ORDER BY
    Average_KPIs_Met DESC;



-- Calculate the average rating of the previous year and
--its percentage in relation to the number of employees in each region (previous_year_rating).

	SELECT
    region,
    COUNT(*) AS Total_Employees,
	AVG(previous_year_rating) Average_previous_year_rating,
    cast(cast(AVG(previous_year_rating)as float) / SUM(COUNT(*)) OVER ()*100 as decimal(10,4)) AS AVG_previous_year_rating
FROM
    HR_Employee_Performance
GROUP BY
    region
ORDER BY
    Average_previous_year_rating DESC;


				
---- Calculating the average training score relative to the number of employees in each region(avg_training_score)


	SELECT
    region,
    COUNT(*) AS Total_Employees,
	AVG(avg_training_score) Average_Training,
    cast(cast(AVG(avg_training_score)as float) * 100 / SUM(COUNT(*)) OVER ()*100 as decimal(10,2)) AS Average_Training_Score
FROM
    HR_Employee_Performance
GROUP BY
    region
ORDER BY
    Average_Training_Score DESC;


-- Calculating the number of employees and the percentage of people who received awards in each department(awards_won).

SELECT
    region,
	COUNT(*) AS Total_Employee,
	SUM(CASE WHEN awards_won = 1 THEN 1 ELSE 0 END) as Count_Employee,
    CAST(SUM(CASE WHEN awards_won = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)AS decimal(10,2)) AS Awards_Won_Percentage
FROM
    HR_Employee_Performance
GROUP BY
    region 
	ORDER BY Awards_Won_Percentage desc

	SELECT * FROM HR_Employee_Performance


