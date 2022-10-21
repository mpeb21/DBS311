

/* Question 1 Display the difference between the Average pay and 
Lowest pay in the company.  Name this result Real Amount.  
Format the output as currency with 2 decimal places. */

-- Q1 Solution
SELECT
    to_char(avg(salary * (nvl(commission_pct, 0) + 1)) - 
        min(salary * (nvl(commission_pct, 0) + 1)), 'fm$999G999D00') 
        AS "Real Amount"
FROM employees;

/*
Question 2 Display the department number and Highest, Lowest and Average pay per 
each department. Name these results High, Low and Avg.  Sort the output so that 
the department with highest average salary is shown first.  Format the output 
as currency where appropriate.
*/

-- Q2 Solution
SELECT
    department_id AS "DEPARTMENT_NUMBER",
    TO_CHAR(max(salary * (nvl(commission_pct, 0) + 1)), '$999G999D00') AS "High",
    TO_CHAR(min(salary * (nvl(commission_pct, 0) + 1)), '$999G999D00') AS "Low",
    TO_CHAR(avg(salary * (nvl(commission_pct, 0) + 1)), '$999G999D00') AS "Avg"
FROM employees
WHERE 
    department_id IS NOT NULL
GROUP BY department_id
ORDER BY "Avg" DESC;

/*
-Question 3 Display how many people work the same job in the same department.
Name these results Dept#, Job and How Many. Include only jobs that involve more
than one person.  Sort the output so that jobs with the most people involved are
shown first.
*/

-- Q3 Solution
SELECT
    department_id AS "Dept#",
    job_id AS "Job",
    count(job_id) AS "How Many"
FROM employees
WHERE 
    department_id IS NOT NULL
GROUP BY department_id, job_id
HAVING count(job_id) > 1
ORDER BY "How Many" DESC;

/*
Question 4.	For each job title display the job title and total amount paid each
month for this type of the job. Exclude titles AD_PRES and AD_VP and also 
include only jobs that require more than $11,000.  Sort the output so that top 
paid jobs are shown first.
*/

-- Question 4 Solution
SELECT
    job_id AS "JOB_TITLE",
    to_char(sum(salary * (nvl(commission_pct, 0) + 1)), '$99G999D00') 
        AS "TOTAL_AMOUNT_PER_MONTH"
FROM employees
WHERE 
    job_id NOT IN ('AD_PRES', 'AD_VP')
GROUP BY job_id
HAVING sum(salary * (nvl(commission_pct, 0) + 1)) > 11000
ORDER BY "TOTAL_AMOUNT_PER_MONTH" DESC;

/*
Question 5 For each manager number display how many persons he / she 
supervises. Exclude managers with numbers 100, 101 and 102 and also include 
only those managers that supervise more than 2 persons.  Sort the output so 
that manager numbers with the most supervised persons are shown first.
*/

-- Question 5 Solution
SELECT
    manager_id AS "MANAGER_ID",
    count(employee_id) AS "NUMBER_SUPERVISED"
FROM employees
WHERE
    manager_id NOT IN (100, 101, 102)
GROUP BY manager_id
HAVING count(employee_id) > 2
ORDER BY "NUMBER_SUPERVISED" DESC;

/*
Question 6 For each department show the latest and earliest hire date, BUT
- exclude departments 10 and 20 
- exclude those departments where the last person was hired in this decade. 
(it is okay to hard code dates in this question only)
- Sort the output so that the most recent, meaning latest hire dates, are shown first.
*/

--Question 6 Solution
SELECT 
    department_id AS "DEPARTMENT_ID",
    to_char(max(hire_date),'fmMonth dd, YYYY') AS "LATEST_HIRE_DATE",
    to_char(min(hire_date),'fmMonth dd, YYYY') AS "EARLIEST_HIRE_DATE"
FROM employees
WHERE 
    department_id NOT IN (10, 20) 
GROUP BY department_id
HAVING max(hire_date) < to_date('01-01-2021', 'MM-DD-YYYY')
ORDER BY max(hire_date) DESC;
