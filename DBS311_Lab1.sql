/*
To update database
UPDATE employees SET hire_date = hire_date + (20*365);
UPDATE job_history SET end_date = end_date + (20*365);
UPDATE job_history SET start_date = start_date + (20*365);
COMMIT;
*/

-- Question 1
/*
Wrong statement 
SELECT last_name “LName”, job_id “Job Title”, 
       Hire Date “Job Start”
FROM employees;

Solution: Need to add in "AS" when using aliases for last_name, job_id, 
and hire_date, correct syntax for "Hire Date" to hire_date
*/
-- Corrected Statement
SELECT 
    last_name AS "LName", 
    job_id AS "Job Title", 
    hire_date AS "Job Start"
FROM employees;
    
--Question 2
SELECT
    employee_id,
    last_name,
    to_char (salary, '$999,999.00') AS "SALARY"
FROM employees
WHERE 
    salary >= 8000 
    AND salary <= 11000
ORDER BY salary DESC, last_name;

--Question 3
SELECT
    employee_id,
    last_name,
    salary
FROM employees
WHERE 
    salary >= 8000 
    AND salary <= 11000
ORDER BY salary DESC, last_name;

--Question 4
SELECT 
    job_id AS "Job Title",
    first_name || ' ' || last_name AS "Full Name"
FROM employees
WHERE 
    LOWER(first_name) LIKE '%e%';

--Question 5
SELECT *
FROM locations
WHERE 
    LOWER(city) LIKE LOWER('%&EnterCity%');

--Question 6
SELECT 
    to_char ((sysdate + 1), 'fmMonth ddth "of year" YYYY') AS "Tomorrow"
FROM DUAL;

--Question 7
SELECT
    last_name,
    first_name,
    department_name,
    salary,
    round(salary * 1.04, 2) AS "Good Salary",
    round((salary * 0.04) * 12, 2) AS "Annual Pay Increase"
FROM 
    employees INNER JOIN departments 
    ON employees.department_id = departments.department_id
WHERE 
    employees.department_id IN (20, 50, 60);

--Question 8
SELECT 
    last_name,
    to_char(hire_date, 'DD-Mon-YYYY') AS "Hire Date",
    trunc((SYSDATE - hire_date) / 365.25) AS "Years Worked"
FROM 
    employees
WHERE 
    hire_date < to_date('01-02-2014', 'MM-DD-YYYY')
ORDER BY "Years Worked" DESC;

-- Better answer
SELECT  last_name AS "Last Name", 
        hire_date AS "Hire Date",
        TRUNC(months_between(sysdate,hire_date)/12,0) AS "Years Worked"
FROM employees
WHERE hire_date < to_date('20140101','yyyymmdd')
ORDER BY "Years Worked";

--Question 9
SELECT
    city,
    country_id,
    NVL(state_province, 'Unknown Province') AS "State or Province"
FROM 
    locations
WHERE 
    UPPER(city) LIKE 'S%'
    AND length(city) >= 8;

--Question 10
SELECT
    last_name,
    TRIM(to_char(hire_date, 'DAY')) || ', ' || TRIM(to_char(hire_date, 'MONTH'))
    || ' the ' || TRIM(to_char(hire_date, 'Ddspth')) || ' of year ' || 
    TRIM(to_char(hire_date, 'YYYY')) AS "Hire Date",
    TRIM(to_char(next_day(add_months(hire_date, 12), 'Thursday'), 'DAY')) 
    || ', ' ||
    TRIM(to_char(next_day(add_months(hire_date, 12), 'Thursday'), 'MONTH')) 
    || ' the ' ||
    TRIM(to_char(next_day(add_months(hire_date, 12), 'Thursday'), 'Ddspth')) 
    || ' of year ' || 
    TRIM(to_char(next_day(add_months(hire_date, 12), 'Thursday'), 'YYYY')) 
    AS "REVIEW DAY"
FROM 
    employees
WHERE 
    extract(year from hire_date) > 2017
ORDER BY next_day(add_months(hire_date, 12), 'Thursday');


SELECT
    last_name,
    hire_date,
    to_char ( 
        next_day ( 
            add_months(hire_date,12), 'Thursday' 
            ) , 'fmDAY, MONTH "the" Ddspth "of year" yyyy' ) AS "Review Day"
FROM employees
WHERE extract(year from hire_date) > 2017
ORDER BY hire_date;
