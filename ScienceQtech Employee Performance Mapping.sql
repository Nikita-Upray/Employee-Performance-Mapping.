 /* 1. Create a database named employee, then import data_science_team.csv
proj_table.csv and emp_record_table.csv into the employee database
from the given resources */

CREATE DATABASE employee;
USE employee;

/* Q.2 - Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and 
DEPARTMENT from the employee record table, and make a list of 
employees and details of their department */

SELECT  emp_id, first_name, last_name, gender, dept
FROM emp_record_table;

/* Q.3 - Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, 
DEPARTMENT, and EMP_RATING if the EMP_RATING is:
• less than two
• greater than four
• between two and four */

-- Method 1 :- 
 SELECT emp_id, first_name, last_name, gender, dept, emp_rating
 FROM emp_record_table
 WHERE emp_rating < 2;
 
 SELECT emp_id, first_name, last_name, gender, dept, emp_rating
 FROM emp_record_table
 WHERE emp_rating > 4;
 
 SELECT emp_id, first_name, last_name, gender, dept, emp_rating
 FROM emp_record_table
 WHERE emp_rating BETWEEN 2 AND 4;
 
  -- Method 2 :- 
  SELECT emp_id, first_name, last_name, gender, dept, emp_rating,
CASE 
	WHEN emp_rating < 2 THEN 'Less than two'
    WHEN emp_rating > 4 THEN 'Greater than four'
    WHEN emp_rating BETWEEN 2 AND 4 THEN 'Between two and four'
 END as emp_ratings
 FROM emp_record_table
 ORDER BY emp_id;


 /* Q.4 - Write a query to concatenate the FIRST_NAME and the LAST_NAME of 
employees in the Finance department from the employee table and 
then give the resultant column alias as NAME. */

SELECT concat(first_name,' ', last_name) AS Name, dept
FROM emp_record_table
WHERE dept = 'finance';

/* Q. 5- Write a query to list only those employees who have someone 
reporting to them. Also, show the number of reporters (including the 
President). */
 
SELECT * FROM emp_record_table;
SELECT * FROM data_science_team;

SELECT E.emp_id, E.first_name, 
COUNT(DISTINCT R.manager_id) AS num_reporters
FROM emp_record_table AS E JOIN emp_record_table AS R 
ON E.emp_id = R.manager_id
GROUP BY E.emp_id, E.first_name
HAVING COUNT(DISTINCT R.manager_id) > 0
ORDER BY E.emp_id;

/* Q.6 - Write a query to list down all the employees from the healthcare and 
finance departments using union. Take data from the employee record 
table */

SELECT concat(first_name,' ',last_name) AS 'Name' ,dept 
FROM  employee.emp_record_table
WHERE DEPT= 'finance' OR dept='healthcare'
UNION 
SELECT concat(first_name,' ',last_name) AS 'Name' ,dept 
FROM  employee.data_science_team
WHERE DEPT= 'finance' OR dept='healthcare';

/* Q.7 - Write a query to list down employee details such as EMP_ID, 
FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING 
grouped by dept. Also include the respective employee rating along 
with the max emp rating for the department. */

SELECT
  EMP_ID,
  FIRST_NAME,
  LAST_NAME,
  ROLE,
  DEPT,
  EMP_RATING,
  MAX_EMP_RATING
FROM
  (
    SELECT
      EMP_ID,
      FIRST_NAME,
      LAST_NAME,
      ROLE,
      DEPT,
      EMP_RATING,
      MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_EMP_RATING
    FROM
      emp_record_table
  ) AS subquery
GROUP BY
  DEPT,
  EMP_ID,
  FIRST_NAME,
  LAST_NAME,
  ROLE,
  EMP_RATING;
  
/* Q.8 - Write a query to calculate the minimum and the maximum salary of the 
employees in each role. Take data from the employee record table. */

SELECT role, MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM emp_record_table
GROUP BY role;

/* Q. 9 - Write a query to assign ranks to each employee based on their 
experience. Take data from the employee record table. */
 
 SELECT
  emp_id, concat(first_name,' ',last_name) AS 'name', exp,
  RANK() OVER (
    ORDER BY exp DESC
  ) AS 'rank'
FROM emp_record_table;

/* Q. 10 - Write a query to create a view that displays employees in various 
countries whose salary is more than six thousand. Take data from the 
employee record table. */

CREATE VIEW Employees_in_various_Countries_with_high_salary AS
SELECT emp_id, concat(first_name,' ',last_name) AS 'name', country
FROM emp_record_table
WHERE salary  > 6000;

SELECT *
FROM Employees_in_various_Countries_with_high_salary;

/* Q. 11 Write a nested query to find employees with experience of more than 
ten years. Take data from the employee record table. */

SELECT emp_id, CONCAT(first_name,' ',last_name) AS name, exp
FROM emp_record_table
WHERE exp > ( SELECT 10 FROM DUAL);

/* Q. 12 - Write a query to create a stored procedure to retrieve the details of the 
employees whose experience is more than three years. Take data from 
the employee record table. */

DELIMITER //

CREATE PROCEDURE Get_Experienced_Employees()
BEGIN
    SELECT *
    FROM emp_record_table
    WHERE exp > 3;
END //

DELIMITER ;

CALL Get_Experienced_Employees();

/* Q. 13 - Write a query using stored functions in the project table to check 
whether the job profile assigned to each employee in the data science 
team matches the organization’s set standard
The standard is given as follows:
• Employee with experience less than or equal to 2 years, assign 
'JUNIOR DATA SCIENTIST’
• Employee with experience of 2 to 5 years, assign 'ASSOCIATE DATA 
SCIENTIST’
• Employee with experience of 5 to 10 years, assign 'SENIOR DATA 
SCIENTIST’
• Employee with experience of 10 to 12 years, assign 'LEAD DATA 
SCIENTIST’,
• Employee with experience of 12 to 16 years, assign 'MANAGER' */

DELIMITER //

CREATE FUNCTION GetRole(exp INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE role VARCHAR(50);
    
    IF exp <= 2 THEN
        RETURN 'JUNIOR DATA SCIENTIST';
    ELSEIF exp <= 5 THEN
        RETURN 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp <= 10 THEN
        RETURN 'SENIOR DATA SCIENTIST';
    ELSEIF exp <= 12 THEN
        RETURN 'LEAD DATA SCIENTIST';
    ELSEIF exp <= 16 THEN
        RETURN 'MANAGER';
    END IF;
    
    RETURN role;
END //

DELIMITER ;

DELIMITER //

ALTER FUNCTION GetRole(exp INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE role VARCHAR(50);

    IF exp <= 2 THEN
        RETURN 'JUNIOR DATA SCIENTIST';
    ELSEIF exp <= 5 THEN
        RETURN 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp <= 8 THEN
        RETURN 'SENIOR DATA SCIENTIST';
    ELSEIF exp <= 12 THEN
        RETURN 'LEAD DATA SCIENTIST';
    ELSEIF exp <= 16 THEN
        RETURN 'MANAGER';
    ELSE
        RETURN 'UNKNOWN';
    END IF;

    RETURN role;
END;

DELIMITER ;

SELECT emp_id, first_name, last_name, exp, GetRole(exp) AS job_profile
FROM emp_record_table
ORDER BY exp;


/* Q. 14 - Create an index to improve the cost and performance of the query to 
find the employee whose FIRST_NAME is ‘Eric’ in the employee table 
after checking the execution plan. */

CREATE INDEX idx_first_name ON emp_record_table (first_name(20));

EXPLAIN SELECT * FROM emp_record_table WHERE first_name = 'Eric';

/* Q. 15 - Write a query to calculate the bonus for all the employees, based on 
their ratings and salaries (Use the formula: 5% of salary * employee 
rating). */

SELECT emp_id, first_name, last_name, salary, emp_rating, 
		0.05 * SALARY * EMP_RATING AS BONUS
FROM emp_record_table
ORDER BY Bonus DESC;
  
  /* Q. 16 - Write a query to calculate the average salary distribution based on the 
continent and country. Take data from the employee record table. */

SELECT continent, country, AVG(salary) AS avg_salary
FROM emp_record_table
GROUP BY continent, country;
