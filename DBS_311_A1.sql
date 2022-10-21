-- Question 1
/*
Display the employee number, full employee name, job and hire date of all 
employees hired in May or November of any year, with the most recently hired 
employees displayed first. 
*/
SELECT
    RPAD(employee_id, Length('employeeNumber'), ' ') AS employeeNumber,
    substr(last_name || ', ' || first_name, 1, 25) AS FullName,
    job_id,
    to_char(last_day(hire_date), '[fmMonth ddth "of" YYYY]') AS "Start Date"
FROM employees
WHERE 
    Extract(YEAR FROM hire_date) NOT IN (2015, 2016)
    AND Extract(MONTH FROM hire_date) IN (5,11)
ORDER BY hire_date DESC;

-- Question 2
/*
List the employee number, full name, job and the modified salary for all 
employees whose monthly earning (without this increase) is outside the range 
$6,500 – $11,500 and who are employed as Vice Presidents or Managers 
(President is not counted here).  
*/
SELECT
    'Emp# ' || to_char(employee_id) || ' named ' || first_name || ' '
    || last_name || ' who is ' || job_id || ' will have a new salary of ' 
    || to_char(
        CASE
            WHEN Upper(job_id) LIKE '%MAN%'
            OR Upper(job_id) LIKE '%MGR%' THEN salary*1.18
            WHEN Upper(job_id) LIKE '%VP%' THEN salary*1.25
        END, 'fm$99999') AS "Employees with Increased Pay"
FROM employees
WHERE (Upper(job_id) LIKE '%MAN%'
    OR Upper(job_id) LIKE '%MGR%'
    OR Upper(job_id) LIKE '%VP%')
    AND salary NOT BETWEEN 6500 AND 11500
ORDER BY salary DESC;

-- Question 3
/*
Display the employee last name, salary, job title and manager# of all 
employees not earning a commission OR if they work in the SALES department, 
but only  if their total monthly salary with $1000 included bonus and  
commission (if  earned) is  greater  than  $15,000.  

**** NOTE ****
We used a subquery to look for the department name, rather than using the 
department_id because we feel that we would not know the department_id off the 
top of our heads. This means that we would probably need to do a query to match
the corrosponding id to name, either by looking at the table itself, doing a 
separate query, or doing a subquery like in our answers. Furthermore, it is
possible that the department ID may change in the future. 

This applies to Questions 3,4,6,7.
*/

SELECT
    last_name,
    salary,
    job_id,
    nvl(to_char(manager_id), 'NONE') AS Manager#,
    to_char((salary * (nvl(commission_pct, 0) + 1) * 12 + 1000), 'fm$999G999D00') 
        AS "Total Income"
FROM employees
WHERE (department_id IN( 
        SELECT department_id
        FROM departments
        WHERE Lower(department_name) = ('sales')
    )
    OR commission_pct IS NULL)
    AND ((salary * (nvl(commission_pct, 0) + 1) + 1000) > 15000)
ORDER BY salary * (nvl(commission_pct, 0) + 1) DESC; 

-- Question 4
/*
Display Department_id, Job_id and the Lowest salary for this combination 
under the alias Lowest Dept/Job Pay, but only if that Lowest Pay falls in the 
range $6500 - $16800. Exclude people who work as some kind of Representative job
from this query and departments IT and SALES as well.
*/
SELECT
    e.department_id,
    job_id,
    Min(salary) AS "Lowest Dept/Job Pay"
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id
WHERE Lower(d.department_name) NOT IN ('it', 'sales')
    AND Lower(job_id) NOT LIKE '%rep%' 
GROUP BY e.department_id, job_id
HAVING Min(salary) BETWEEN 6500 AND 16800
ORDER BY e.department_id, job_id;

-- Question 5
/*
Display last_name, salary and job for all employees who earn more than all 
lowest paid employees per department outside the US locations.
*/
SELECT
    last_name,
    salary,
    job_id
FROM employees
WHERE salary > (
    SELECT Max(Min(salary))
    FROM employees
    WHERE department_id IN(
        SELECT d.department_id
        FROM departments d INNER JOIN locations l 
            ON d.location_id = l.location_id
        WHERE Upper(l.country_id) NOT LIKE 'US'
        )
    GROUP BY department_id
    )
    AND Upper(job_id) NOT LIKE '%PRES%'
    AND Upper(job_id) NOT LIKE '%VP%'
ORDER BY job_id ASC;

-- Question 6
/*
Who are the employees (show last_name, salary and job) who work either in IT or 
MARKETING department and earn more than the worst paid person in the ACCOUNTING
department. 
*/
SELECT
    last_name,
    salary, 
    job_id
FROM employees
WHERE (salary * (nvl(commission_pct, 0) + 1)) > (
    SELECT Min((salary * (nvl(commission_pct, 0) + 1)))
        FROM employees
        WHERE department_id = (
            SELECT department_id
            FROM departments
            WHERE Lower(department_name) IN ('accounting')
        )
    )
    AND department_id IN (
        SELECT department_id
        FROM departments
        WHERE Lower(department_name) IN ('it', 'marketing')
        )
ORDER BY last_name;

-- Question 7
/*
Display alphabetically the full name, job, salary (formatted as a currency 
amount incl. thousand separator, but no decimals) and department number for each
employee who earns less than the best paid unionized employee (i.e. not the 
president nor any manager nor any VP), and who work in either SALES or MARKETING
department.  
*/

SELECT 
    substr(first_name || ' ' || last_name, 1, 24) AS "Employee",
    job_id,
    LPAD(to_char(salary, '$999G999'),15, '=' ) AS "Salary",
    department_id
FROM employees
WHERE (salary * (nvl(commission_pct, 0) + 1)) < (
    SELECT 
        Max((salary * (nvl(commission_pct, 0) + 1)))
    FROM employees
    WHERE Lower(job_id) NOT LIKE '%man%'
        AND Lower(job_id) NOT LIKE '%mgr%'
        AND Lower(job_id) NOT LIKE '%vp%'
        AND Lower(job_id) NOT LIKE '%pres%'
    )
    AND department_id IN (
        SELECT department_id
            FROM departments
            WHERE Lower(department_name) IN ('sales', 'marketing')
        )
ORDER BY "Employee";

-- Question 8
/*
Display department name, city and number of different jobs in each department. 
If city is null, you should print Not Assigned Yet.
*/

SELECT
    nvl(department_name,'NONE') AS departmentName,
    substr(nvl(city, 'Not Assigned Yet'),1,22) AS "City",
    nvl("# of Jobs",0) AS "# of Jobs"
FROM departments d RIGHT OUTER JOIN (
    SELECT
        department_id,
        COUNT(DISTINCT job_id) AS "# of Jobs"
    FROM employees
    GROUP BY department_id) t
    ON d.department_id = t.department_id
    FULL OUTER JOIN locations l ON d.location_id = l.location_id
ORDER BY "# of Jobs" DESC, department_name;