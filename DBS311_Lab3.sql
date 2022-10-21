

/*
Question 1 - Create an INSERT statement to do this.  Add yourself as an 
employee with a NULL salary, 0.21 commission_pct, in department 90, and
Manager 100.  You started TODAY.  
*/
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number,
        hire_date, job_id, commission_pct, manager_id, department_id)
VALUES ((SELECT (max(employee_id) + 1) FROM employees), 'Jeffrey', 'Zhou', 
    ('ZJZHOU2'), '647.888.5547', sysdate, 'SA REP', 0.21, 100, 90);        
    
/*
Question 2.	Create an Update statement to: Change the salary of the 
employees with a last name of Matos and Whalen to be 2500.
*/
UPDATE employees SET salary = 2500
    WHERE lower(last_name) IN (lower('Matos'), lower('Whalen'));


/*
Question 3.	Make sure you run a commit statement after the first 2 steps to 
make those changes permanent.
*/
COMMIT;

/*
Question 4.	Display the last names of all employees who are in the same 
department as the employee named Abel.
*/
SELECT last_name
FROM employees
WHERE department_id IN(
    SELECT department_id
        FROM employees
        WHERE lower(last_name) = lower('Abel')
);

/*
Question 5. Display the last name of the lowest paid employee(s)
*/
SELECT last_name
FROM employees
WHERE nvl(salary, 0) IN (
    SELECT min(nvl(salary, 0) * (nvl(commission_pct, 0) + 1))
        FROM employees
);

/*
Question 6 Display the city that the lowest paid employee(s) are located in.
*/
SELECT city
FROM locations
WHERE location_id IN (
    SELECT location_id
        FROM departments
        WHERE department_id IN (
            SELECT department_id
                FROM employees
                WHERE nvl(salary, 0) IN (
                    SELECT min(nvl(salary, 0) * (nvl(commission_pct, 0) + 1))
                    FROM employees
                )
        )
);
    
/*
Question 7. Display the last name, department_id, and salary of the lowest paid
employee(s) in each department.  Sort by Department_ID. 
(HINT: careful with department 60)
*/
SELECT 
    last_name, 
    department_id,
    nvl(salary, 0) AS SALARY
FROM employees
WHERE (department_id, nvl(salary, 0)) IN (
    SELECT department_id, min(nvl(salary, 0))
        FROM employees
        GROUP BY department_id
    ) 
ORDER BY department_id;


/*
Question 8 Display the last name of the lowest paid employee(s) in each city
*/

SELECT 
    last_name, 
    city
FROM employees JOIN departments USING (department_id)
    JOIN locations USING (location_id)
WHERE (location_id, nvl(salary, 0)) IN (
    SELECT location_id, min(nvl(salary, 0))
        FROM locations JOIN departments USING (location_id) 
            JOIN employees USING (department_id)
        GROUP BY city, location_id
    )         
;

/*
Question 9.	Display last name and salary for all employees who earn less 
than the lowest salary in ANY department.  Sort the output by top salaries 
first and then by last name.
*/

SELECT 
    last_name,
    nvl(salary, 0) AS SALARY
FROM employees
WHERE nvl(salary, 0) < ANY (
    SELECT min(nvl(salary, 0))
        FROM employees
        GROUP BY department_id
)
ORDER BY salary DESC, last_name;

/*
Question 10 Display last name, job title and salary for all employees whose 
salary matches any of the salaries from the IT Department. Do NOT use Join 
method.  Sort the output by salary ascending first and then by last_name
*/

SELECT
    last_name,
    job_id,
    salary
FROM employees
WHERE salary IN(
    SELECT salary
        FROM employees
        WHERE department_id IN (
            SELECT department_ID
                FROM departments
                WHERE department_name = 'IT'
        )
)
ORDER BY salary, last_name;

SELECT 
    last_name, 
    job_id, 
    salary
FROM employees
WHERE salary = ANY(
  SELECT salary 
    FROM employees 
    WHERE upper(job_id)= 'IT_PROG'
  )
ORDER BY 
salary, last_name;


SELECT * FROM (
SELECT
    firstName,
    lastName
FROM players
WHERE upper(lastName) LIKE 'D%'
ORDER BY lower(lastName), lower(firstName)
)
UNION ALL
SELECT * FROM (
SELECT
    firstName,
    lastName
FROM players
WHERE upper(lastName) LIKE 'D%'
ORDER BY lower(lastName), lower(firstName)
)
UNION ALL 
SELECT * FROM (
SELECT
    firstName,
    lastName
FROM players
WHERE upper(lastName) LIKE 'D%'
ORDER BY lower(lastName), lower(firstName)
);


SELECT * FROM (
    SELECT
        firstName,
        lastName
    FROM players
    WHERE upper(lastName) LIKE 'D%'
    ORDER BY lower(lastName), lower(firstName)
)
UNION ALL
SELECT * FROM (
    SELECT
        firstName,
        lastName
    FROM players
    WHERE upper(lastName) LIKE 'C%'
    ORDER BY lower(lastName), lower(firstName)
)
UNION ALL
SELECT * FROM (
    SELECT
        firstName,
        lastName
    FROM players
    WHERE upper(lastName) LIKE 'C%'
    ORDER BY lower(lastName), lower(firstName)
)
    