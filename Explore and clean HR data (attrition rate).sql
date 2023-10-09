select * from HR_Employee_attrition

-----------------------------------------------------------
-- The stage of exploring, cleaning and processing the data
-----------------------------------------------------------


--Replace "Yes" with 1 and "No" with 0 in the Attrition column

select Attrition from HR_Employee_attrition

update HR_Employee_attrition
set Attrition = CASE 
	WHEN Attrition = 'Yes' THEN 1
	WHEN Attrition = 'No' THEN 0
	ELSE Attrition
	END;


--Replace "Non-Travel" with 1, "Travel_Rarely" with 2, and "Travel_Frequently" with 3 in the BusinessTravel column

select BusinessTravel from HR_Employee_attrition


UPDATE HR_Employee_attrition
SET BusinessTravel = CASE
	WHEN BusinessTravel = 'Non-Travel' THEN 1
	WHEN BusinessTravel = 'Travel_Rarely' THEN 2
	WHEN BusinessTravel = 'Travel_Frequently' THEN 3
	ELSE BusinessTravel
	END;


--

SELECT * FROM HR_Employee_Attrition



-- Define null values

SELECT *
  FROM [HR_Cabiston_Project_DB].[dbo].[HR_Employee_Attrition]
  WHERE 
      [Age]                        IS NULL OR
      [Attrition]				  IS NULL OR
      [BusinessTravel]			  IS NULL OR
      [DailyRate]				  IS NULL OR
      [Department]				  IS NULL OR
      [DistanceFromHome]		  IS NULL OR
      [Education]				  IS NULL OR
      [EducationField]			  IS NULL OR
      [EmployeeCount]			  IS NULL OR
      [EmployeeNumber]			  IS NULL OR
      [EnvironmentSatisfaction]	  IS NULL OR
      [Gender]					  IS NULL OR
      [HourlyRate]				  IS NULL OR
      [JobInvolvement]			  IS NULL OR
      [JobLevel]				  IS NULL OR
      [JobRole]					  IS NULL OR
      [JobSatisfaction]			  IS NULL OR
      [MaritalStatus]			  IS NULL OR
      [MonthlyIncome]			  IS NULL OR
      [MonthlyRate]				  IS NULL OR
      [NumCompaniesWorked]		  IS NULL OR
      [Over18]					  IS NULL OR
      [OverTime]				  IS NULL OR
      [PercentSalaryHike]		  IS NULL OR
      [PerformanceRating]		  IS NULL OR
      [RelationshipSatisfaction]  IS NULL OR
      [StandardHours]			  IS NULL OR
      [StockOptionLevel]		  IS NULL OR
      [TotalWorkingYears]		  IS NULL OR
      [TrainingTimesLastYear]	  IS NULL OR
      [WorkLifeBalance]			  IS NULL OR
      [YearsAtCompany]			  IS NULL OR
      [YearsInCurrentRole]		  IS NULL OR
      [YearsSinceLastPromotion]	  IS NULL OR
      [YearsWithCurrManager]	  IS NULL ;



SELECT * FROM HR_Employee_Attrition


-- Find out duplicate rows

SELECT COUNT(DISTINCT EmployeeNumber)
FROM HR_Employee_Attrition;

SELECT DISTINCT EmployeeNumber
FROM HR_Employee_Attrition;

 SELECT EmployeeNumber,Attrition,DistanceFromHome,MonthlyIncome,TotalWorkingYears,COUNT(*)
FROM HR_Employee_Attrition
GROUP BY EmployeeNumber ,Attrition,DistanceFromHome,MonthlyIncome,TotalWorkingYears 
HAVING COUNT(*) > 1;

-- ADD PRIMARY KEY 

ALTER TABLE HR_Employee_Attrition
ADD PRIMARY KEY (EmployeeNumber);

-- Percentage of the (Department’s) effect on attrition

SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS AttritionRate
FROM
    HR_Employee_Attrition
GROUP BY
    Department
ORDER BY
    AttritionRate DESC;


--Percentage of the impact of (Monthly income) on attrition 

SELECT
    CASE
        WHEN MonthlyIncome BETWEEN 0 AND 4999 THEN '0-4999'
        WHEN MonthlyIncome BETWEEN 5000 AND 9999 THEN '5000-9999'
        WHEN MonthlyIncome BETWEEN 10000 AND 14999 THEN '10000-14999'
        WHEN MonthlyIncome BETWEEN 15000 AND 19999 THEN '15000-19999'
        WHEN MonthlyIncome >= 20000 THEN '20000+'
        ELSE 'Unknown'
    END AS SalaryRange,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    CAST(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS float) / COUNT(*) * 100 AS decimal(10,2)) AS AttritionRate
FROM
   HR_Employee_Attrition
GROUP BY
    CASE
        WHEN MonthlyIncome BETWEEN 0 AND 4999 THEN '0-4999'
        WHEN MonthlyIncome BETWEEN 5000 AND 9999 THEN '5000-9999'
        WHEN MonthlyIncome BETWEEN 10000 AND 14999 THEN '10000-14999'
        WHEN MonthlyIncome BETWEEN 15000 AND 19999 THEN '15000-19999'
        WHEN MonthlyIncome >= 20000 THEN '20000+'
        ELSE 'Unknown'
    END
ORDER BY
    AttritionRate DESC;



-- Percentage of the effect of (Age) on attrition

SELECT 
	CASE 
	    WHEN AGE BETWEEN 18 AND 25 THEN '18-25'
		WHEN AGE BETWEEN 26 AND 35 THEN '26-30'
		WHEN AGE BETWEEN 36 AND 45 THEN '36-45'
		WHEN AGE > = 46 THEN '46+'
		ELSE 'UnKnown'
		end as Age,
		COUNT(*) as Total_Employee,
		SUM(case  WHEN Attrition = 'YES' THEN 1 ELSE 0 END ) AS AttritionCount,
		CAST(CAST(SUM(case  WHEN Attrition = 'YES' THEN 1 ELSE 0 END )AS float) /  COUNT(*) * 100 AS decimal(10,2)) AS AttritionRate

 FROM HR_Employee_Attrition
 GROUP BY 	 CASE   WHEN AGE BETWEEN 18 AND 25 THEN '18-25'
		WHEN AGE BETWEEN 26 AND 35 THEN '26-30'
		WHEN AGE BETWEEN 36 AND 45 THEN '36-45'
		WHEN AGE > = 46 THEN '46+'
		ELSE 'UnKnown'
		END
		ORDER BY 
	AttritionRate DESC



-- Percentage of the effect of (Work-life balance) on attrition

SELECT * FROM HR_Employee_Attrition

select WorkLifeBalance from HR_Employee_attrition
GROUP BY WorkLifeBalance

SELECT
    WorkLifeBalance,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS AttritionRate
FROM
    HR_Employee_Attrition
GROUP BY
    WorkLifeBalance
ORDER BY
    AttritionRate desc;

-- Percentage of the effect of (Number Companies Worked) on attrition


SELECT
    NumCompaniesWorked,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    CAST(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS decimal(10,2)) AS AttritionRate
FROM
    HR_Employee_Attrition
GROUP BY
    NumCompaniesWorked
ORDER BY
    NumCompaniesWorked DESC;


-- Percentage of the effect of subjective (job satisfaction) on attrition


SELECT JobSatisfaction, 
COUNT(*) AS TotalEmployees,
SUM( CASE  WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS AttritionCount,
CAST(CAST(SUM (CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END)AS float) / COUNT(*) * 100 AS decimal(10,2)  ) AS AttritionRate
FROM HR_Employee_Attrition 
GROUP BY JobSatisfaction
ORDER BY AttritionRate DESC


-- Percentage of the effect of subjective (Stock Option Level) on attrition


SELECT StockOptionLevel,
COUNT(*) AS StockOptionLevel,
SUM( CASE  WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS AttritionCount,
CAST(CAST(SUM (CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END)AS float) / COUNT(*) * 100 AS decimal(10,2)  ) AS AttritionRate
 FROM HR_Employee_Attrition
 GROUP BY StockOptionLevel
 ORDER BY AttritionRate DESC


-- Percentage of the effect of subjective (Years In Current Role) on attrition



  SELECT YearsInCurrentRole,
COUNT(*) AS YearsInCurrentRole,
SUM( CASE  WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS AttritionCount,
CAST(CAST(SUM (CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END)AS float) / COUNT(*) * 100 AS decimal(10,2)  ) AS AttritionRate
 FROM HR_Employee_Attrition
 GROUP BY YearsInCurrentRole
 ORDER BY AttritionRate DESC


--Percentage of the effect of subjective (Percent Salary Hike) on attrition

  SELECT PercentSalaryHike,
COUNT(*) AS Total_Employee,
SUM( CASE  WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS AttritionCount,
CAST(CAST(SUM (CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END)AS float) / COUNT(*) * 100 AS decimal(10,2)  ) AS AttritionRate
 FROM HR_Employee_Attrition
 GROUP BY PercentSalaryHike
 ORDER BY AttritionRate DESC


 ----Percentage of the effect of subjective (Years With Current Manager) on attrition


   SELECT YearsWithCurrManager,
COUNT(*) AS Total_Employee,
SUM( CASE  WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS AttritionCount,
CAST(CAST(SUM (CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END)AS float) / COUNT(*) * 100 AS decimal(10,2)  ) AS AttritionRate
 FROM HR_Employee_Attrition
 GROUP BY YearsWithCurrManager
 ORDER BY AttritionRate DESC
