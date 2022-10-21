

/*
Question 1 The HR department needs a list of Department IDs for departments that
do not contain the job ID of ST_CLERK> Use a set operator to create this report.
*/
SELECT department_id
FROM departments
MINUS
(SELECT department_id
FROM employees
WHERE upper(job_id) = 'ST_CLERK');


/*
Question 2 Same department requests a list of countries that have no departments
located in them. Display country ID and the country name. Use SET operators. 
*/

SELECT
    country_id, 
    country_name
FROM countries 
WHERE country_id NOT IN(
    SELECT country_id
    FROM locations
    WHERE location_id IN(
        SELECT location_id
        FROM locations
        INTERSECT
        SELECT location_id
        FROM departments
        )
)
ORDER BY COUNTRY_ID;

-- OR

SELECT
	country_id,
	country_name
FROM countries

MINUS

SELECT 
	country_id,
	country_name
FROM countries
WHERE country_id IN(
	SELECT country_id
	FROM locations
	WHERE location_id IN(	
		SELECT location_id
		FROM departments
		)
	)

ORDER BY country_id;

/*
Question 3	The Vice President needs very quickly a list of departments 10, 50,
20 in that order. Job and department ID are to be displayed.
*/
SELECT 
    DISTINCT job_id, 
    department_id
FROM employees
WHERE department_id = 10
UNION ALL
SELECT 
    DISTINCT job_id, 
    department_id
FROM employees
WHERE department_id = 50
UNION ALL
SELECT 
    DISTINCT job_id, 
    department_id
FROM employees
WHERE department_id = 20;

/*
Question 4 Create a statement that lists the employeeIDs and JobIDs of those 
employees who currently have a job title that is the same as their job title 
when they were initially hired by the company (that is, they changed jobs but 
have now gone back to doing their original job).
*/

SELECT
    employee_id,
    job_id,
    hire_date
FROM employees
INTERSECT
SELECT
    employee_id,
    job_id,
    start_date
FROM job_history;
    
/*
Question 5 The HR department needs a SINGLE report with the following 
specifications:
a.	Last name and department ID of all employees regardless of whether they 
belong to a department or not.
b.	Department ID and department name of all departments regardless of whether
they have employees in them or not.

Write a compound query to accomplish this.

*/

SELECT 
    last_name, 
    department_id, 
    TO_CHAR('null') AS department_name
FROM employees
UNION
SELECT 
    TO_CHAR('null'), 
    department_id, 
    department_name
FROM departments
