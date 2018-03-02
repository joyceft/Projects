CREATE TABLE project(
ProjectID int,
ProjectName varchar(200),
StartTime DATE,
ManagerID int,
PRIMARY KEY (ProjectID));

INSERT INTO manager
VALUES (11100, "Toung", "Alwwn");

DROP TABLE project;

UPDATE employees
SET location = "Chicago"
WHERE EmployeeID = 11110;

#DELETE FROM employees
#WHRERE EmployeeID = 99999;

SELECT * FROM employees
WHERE Title = "manager"
ORDER BY salaries;

#7
SELECT DISTINCT Title FROM employees;

#8
SELECT EmployeeID, LastName, FirstName, salaries FROM employees
ORDER BY salaries DESC
LIMIT 3;
#9
SELECT AVG(salaries), MIN(salaries), MAX(salaries) FROM employees;
#10
SELECT MAX(salaries)-MIN(salaries) AS extreme_diff FROM employees;
#11
SELECT COUNT(l.Location) FROM location AS l
LEFT JOIN employees AS e
ON e.Location = l.Location
WHERE e.FirstName LIKE "J%"
GROUP BY l.Location
HAVING COUNT(l.Location) >=1;
 ##
 SELECT COUNT(DISTINCT location) FROM employees
 WHERE FirstName LIKE "J%";
 
 #12
SELECT location, AVG(DATEDIFF(NOW(), hired_date)/365) AS avgtenure FROM employees 
GROUP BY location
ORDER BY avgtenure DESC
LIMIT 1
;
 #13
 SELECT Title, (salaries)-MIN(salaries) AS extreme_diff FROM employees
 GROUP BY Title;
 