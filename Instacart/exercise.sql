create table RawMaterials(
material_ID INT,
Unit_of_Measure INT,
Standard_Cost numeric(7,2),
Primary key (Material_ID)
);
select * from RawMaterials;

INSERT INTO Vendor
VALUES (1,"fff","fff");

INSERT INTO Vendor
VALUES (2,"lumberbar","8736 SE 1st");

INSERT INTO Vendor(Vendor_id, Vendor_Name)
VALUES(3,"JCsupply");
INSERT INTO Vendor(Vendor_id, Vendor_Name, Vendor_Address)
values(4, "mgmt544","KRAN");
select * from Vendor;
#insert several rows at one time
INSERT INTO Vendor(Vendor_id, Vendor_Name, Vendor_Address)
values(5,"stat545","univ"),(6,"ie535","gris");

select* from student;
drop table Vendor; #delete a entire table
#in order to modify the table(unlock the safe mode)
set SQL_SAFE_UPDATES = 0;
delete from student
where Student_ID = 97701; 

update student
set Major = "Art"
where Student_ID = "98467";
update student
set F_Name = "Purple"
where Student_ID = "93273";
select * from student;

select * from Hollywood;
#where
select * from Hollywood
where Year >2008
order by Year;

select Film, AudienceScore, Profitability from Hollywood
where RottenTomatoes>90;

select Film, LeadStudio from Hollywood
where Profitability >50 or WorldwideGross>100;

select Film, LeadStudio from Hollywood
where Genre ="Comedy" and LeadStudio ="Fox";
#distinct
select distinct LeadStudio from Hollywood;
select distinct LeadStudio from Hollywood
where Year >2008;
select distinct LeadStudio, Genre from Hollywood
where Profitability >30;

#count
select count(Film), Film, Profitability from Hollywood
where Profitability>=30;
select count(distinct LeadStudio) from Hollywood
where Profitability >=5;

select count(Film) from Hollywood
where LeadStudio = "Disney" and Profitability>=30;
select count(Film) from Hollywood
where Profitability >=30 and AudienceScore>=80;
#limit
select Film, Profitability from Hollywood
order by Profitability desc
limit 3;
#
select sum(WorldwideGross) from Hollywood
where LeadStudio = "Warner Bros.";

select Film, Profitability from Hollywood
where LeadStudio ="Independent"
order by Profitability desc
limit 1;

select Film, LeadStudio, Profitability from Hollywood
order by Profitability desc;
select distinct LeadStudio, Genre from Hollywood
where Genre = "Comedy";
select distinct LeadStudio, Year from Hollywood
where Year = 2011;
#10/17
select * from Hollywood;
#calculate then create a new col
select max(Profitability) as Maxp, avg(Profitability) as avyP from Hollywood;
#calculate the difference between As and RottenTomatoes
select AudienceScore, AudienceScore-RottenTomatoes as Score_gap from Hollywood;
#create a new col
select 100*Profitability from Hollywood;

#10.17
SELECT * FROM Hollywood;
SELECT Film, LeadStudio FROM Hollywood
WHERE Profitability>50 or WorldwideGross > 100;
SELECT Film, LeadStudio FROM Hollywood
WHERE Genre="Comedy" AND LeadStudio="Fox";
#limit
SELECT Film, Profitability FROM Hollywood
ORDER BY Profitability DESC
LIMIT 3;
SELECT Film, Profitability FROM Hollywood
WHERE LeadStudio = "Independent"
order by Profitability desc
LIMIT 1;
#aggregate operator
SELECT COUNT(Profitability), AVG(Profitability),MAX(Profitability),MIN(Profitability)
FROM Hollywood;
SELECT COUNT(Profitability), AVG(Profitability),MAX(Profitability),MIN(Profitability)
FROM Hollywood
WHERE year = "2010";
SELECT SUM(WorldWideGross) FROM Hollywood
WHERE LeadStudio = "Warner bros.";
#COUNT(DISTINCT)
SELECT COUNT(distinct LeadStudio) FROM Hollywood
WHERE Profitability>=5;
#aliasing>set as new col
SELECT MAX(Profitability), AVG(Profitability) as AvgP FROM Hollywood
WHERE Genre = "comedy";
#operation
select * from Hollywood;

SELECT AudienceScore - RottenTomatoes as score_gap FROM Hollywood;
SELECT Profitability * 100 FROM Hollywood;
#wildcards like: % _
SELECT * FROM Hollywood
WHERE film LIKE "%love%";
SELECT * FROM Hollywood
WHERE film LIKE "love%";
SELECT * FROM Hollywood
WHERE film like" %love";
SELECT * FROM Hollywood
WHERE film LIKE "G__d%";
SELECT DISTINCT LeadStudio, film FROM Hollywood
WHERE film LIKE "f%" or "w%";

#date function
SELECT * FROM famousbirthdays;
#ages of all people in years
SELECT *, year(now())- year(birthday) FROM famousbirthdays;
#younger than 40
SELECT *, year(now())-year(birthday) FROM famousbirthdays
WHERE year(now())-year(birthday) < 40;
SELECT *, Month(birthday) FROM famousbirthdays
WHERE Month(birthday) = 5;
#group_by
SELECT AVG(Profitability), Genre FROM Hollywood
Order by AVG(Profitability) desc
limit 1;
SELECT Profitability, Genre FROM Hollywood
GROUP BY Genre
ORDER BY AVG(Profitability) DESC;

SELECT SUM(Profitability), LeadStudio FROM Hollywood
ORDER BY SUM(Profitability) desc
limit 1;
SELECT WorldwideGross, LeadStudio FROM Hollywood
Group by WorldwideGross
ORDER BY SUM(WorldwideGross) DESC;
SELECT Genre, profitability FROM Hollywood
Group by Genre
Order by Profitability desc;
#having
SELECT Genre, AudienceScore FROM Hollywood
group by Genre
having AudienceScore >50;
select film, LeadStudio, Year from Hollywood
where year = 2010
group by LeadStudio
having count(LeadStudio) >2;
SELECT film, year, Genre from Hollywood
WHERE Genre = "romance"
group by Year
having count(Genre) >2;
#practice
select leadstudio, genre, Year from Hollywood
WHERE Year>=2009
Group by LeadStudio
having count(Genre) >=2;
#WRONG
select leadstudio, film from Hollywood
WHERE count(LeadStudio)=1
GROUP BY "LeadStudio"
having film like "%love%";

select SUM(WorldWideGross), leadstudio, audienceScore from Hollywood
GROUP BY LeadStudio
Having min(AudienceScore)>50;

#hw3.1
select AVG(RottenTomatoes) FROM Hollywood
WHERE LeadStudio = "Disney";
SELECT MAX(Profitability)-MIN(Profitability) FROM Hollywood
WHERE LeadStudio = "FOX";
SELECT DISTINCT LeadStudio FROM Hollywood
WHERE Genre = "Comedy";
SELECT COUNT(DISTINCT LeadStudio) FROM Hollywood
WHERE Year=2011;
select * from Hollywood;
#hw3.2
SELECT * FROM TopBabyNamesbyState;

SELECT TopName, SUM(Occurrences) AS TotalOccurence FROM TopBabyNamesbyState
WHERE Gender = "F" AND State="IN" AND Year >=2000 
GROUP BY TopName
ORDER BY SUM(Occurrences) DESC
LIMIT 3;

SELECT COUNT(TopName) AS Mary_topinCA FROM TopBabyNamesbyState
WHERE TopName = "Mary" AND State = "CA";

SELECT TopName FROM TopBabyNamesbyState
GROUP BY TopName
ORDER BY SUM(Occurrences) DESC
LIMIT 1;
SELECT AVG(Occurrences) FROM TopBabyNamesbyState
WHERE TopName = "Jessica" AND State = "IN";

SELECT MAX(Occurrences) AS maxOcc, TopName FROM TopBabyNamesbyState
GROUP BY TopName
ORDER BY TopName DESC;

#10.24
#having
SELECT * FROM Hollywood;
SELECT AVG(AudienceScore) AS avgscore, Genre FROM Hollywood
GROUP BY Genre
HAVING avgscore >50;
#CANNOT use where firest, because we need to compare the group mean >50
SELECT COUNT(LeadStudio) AS number, LeadStudio FROM Hollywood
WHERE Year = 2010 #year is based on films, not leadstudio
GROUP BY LeadStudio
HAVING number > 2;
#which year has more than 2 romance movie?
SELECT Year, Genre, COUNT(Genre) FROM Hollywood
WHERE Genre ="Romance"
GROUP BY Year
HAVING COUNT(Genre)>2;
#LEADSTUDIO WHO HAVE PRODUCED MOVIE BELONGS TO AT LEAST 2 GENRES SINCE 2009
SELECT LeadStudio, Genre FROM Hollywood
WHERE Year >=2009
GROUP BY LeadStudio
HAVING COUNT(DISTINCT Genre) >=2;
#find leadstudio who have 1 movie have lovw in its title
SELECT LeadStudio, film FROM Hollywood
WHERE Film LIKE "%Love%"
GROUP BY LeadStudio
HAVING COUNT(LeadStudio) =1;
#TOTAL WWG whose lowest audience score >50
SELECT SUM(WorldWideGross), LeadStudio, AudienceScore FROM Hollywood
GROUP BY LeadStudio
HAVING MIN(AudienceScore)>50;
#join
SELECT * FROM product;
#10/26 Join
SELECT * FROM supplier;
SELECT supplier.CompanyName, supplier.City, product.ProductName, product.ProductCategory FROM product
INNER JOIN supplier
ON product.SupplierNumber = product.SupplierNumber;
#class practice1
SELECT supplier.CompanyName, product.ProductName FROM supplier
INNER JOIN product
ON supplier.SupplierNumber=product.SupplierNumber
ORDER BY supplier.CompanyName;
#nature join
SELECT supplier.CompanyName, product.ProductName 
FROM supplier, product
WHERE supplier.SupplierNumber=product.SupplierNumber
ORDER BY supplier.CompanyName;
#class practice2
SELECT product.ProductName, supplier.State FROM supplier
INNER JOIN product
ON supplier.SupplierNumber = product.SupplierNumber
ORDER BY ProductName;
#class practice3
SELECT product.ProductName, product.ProductCategory FROM product
INNER JOIN supplier
ON supplier.SupplierNumber = product.SupplierNumber
WHERE supplier.ZIP > 70000
ORDER BY supplier.CompanyName;
SELECT supplier.CompanyName, product.ProductName FROM supplier
INNER JOIN product
WHERE product.PurchaseCost <= product.ReorderLevel;
##rename table name
SELECT p.productName, s.CompanyName FROM supplier AS s
INNER JOIN product AS p;
#left join<<return all rows in the first table
SELECT p.ProductName, s.CompanyName FROM supplier AS s
LEFT JOIN product AS p
ON s.SupplierNumber = p.SupplierNumber;
#right join << return all rows in the second table
SELECT p.ProductName, s.CompanyName FROM supplier AS s
RIGHT JOIN product AS p
ON p.SupplierNumber = s.SupplierNumber;

##class practice II
SELECT * FROM employees;
SELECT * FROM manager;
SELECT * FROM location;

#1.return names of employee who stay >20 years
SELECT e.FirstName, e.LastName, 
round(DATEDIFF(curdate(), e.hired_date)/365) AS tenure
FROM employees AS e
WHERE round(DATEDIFF(curdate(), e.hired_date)/365) > 20;

#2.for all location, get the list of employee who work there
SELECT e.FirstName, e.LastName, l.Location FROM employees AS e
RIGHT JOIN location AS l
ON e.Location = l.Location
ORDER BY l.Location;
###
SELECT e.*, l.*
FROM employees AS e
RIGHT JOIN location AS l
ON e.Location = l.Location;


#3.return the e.ID who work in regional office
SELECT e.EmployeeID, e.FirstName, e.LastName, l.RegionalOffice 
FROM employees AS e
LEFT JOIN location AS l
ON e.Location = l.Location
WHERE l.RegionalOffice = "Yes";

#4.which location is regionoffice and has >=1 employee receive "good"
SELECT l.Location, COUNT(e.Performance) FROM location AS l
LEFT JOIN employees AS e
ON l.Location = e.Location
WHERE l.RegionalOffice = "Yes" AND e.Performance = "Good"
GROUP BY l.Location
HAVING COUNT(e.Performance)>=1 
ORDER BY COUNT(e.Performance) asc
LIMIT 1;
##
SELECT COUNT(*), l.Location FROM employees AS e
RIGHT JOIN location AS l
ON e.Location = l.Location
WHERE l.RegionalOffice = "YES" AND e.Performance = "Good"
GROUP BY l.Location;

#5.for each title in a regional office or not, get average, min, max salary 
SELECT e.Title, l.RegionalOffice, AVG(e.salaries), MIN(e.salaries), MAX(e.salaries) FROM employees AS e
LEFT JOIN location as l
ON e.Location = l.Location
GROUP BY e.Title, l.RegionalOffice;
##using INNER JOIN

#6.get the manager's f,lname of the trainees whoes first name start with j
SELECT m.FirstName, m.LastName, e.FirstName FROM employees AS e
RIGHT JOIN employees AS m
ON e.ManagerID = m.EmployeeID
WHERE e.Title = "Trainee" AND e.FirstName LIKE "J%";
##
SELECT m.FirstName AS ManagerFirstName, m.LastName, e.FirstName
FROM manager AS m
INNER JOIN employees AS e
ON m.EmployeeID = e.ManagerID
WHERE e. FirstName LIKE "J%";


#10.31class practice
##do multiply queries: do one create a table, then do other query on that table
CREATE TABLE test
SELECT AVG(SellingPrice) AS avgPrice FROM product;
SELECT * FROM test;

SELECT * FROM product
INNER JOIN test
WHERE product.SellingPrice > test.avgPrice;

##subquery
SELECT * FROM product
WHERE SellingPrice > 
     (SELECT AVG(SellingPrice) AS avgPrice FROM product);
     
SELECT ProductName FROM product
WHERE SellingPrice >
     (SELECT AVG(SellingPrice) AS avgPrice FROM product)
ORDER BY ProductName;

SELECT * FROM product
INNER JOIN #INNER JOIN WITH A NEW TABLE temp
    (SELECT AVG(product.SellingPrice) AS AvgPrice 
    FROM product) AS temp
WHERE product.SellingPrice > temp.AvgPrice;
#2.Retrieve all information of products, of which margin is greater than
#the average margin.S
SELECT * FROM product
WHERE(product.SellingPrice - product.PurchaseCost) >
	  (SELECT AVG(product.SellingPrice - product.PurchaseCost) 
      FROM product);

#3.How many products in children's category are more expensive that 
#avg of sellingprice of all products in children's category
SELECT COUNT(*) FROM product
WHERE product.ProductCategory = "Children" AND product.SellingPrice
>(SELECT AVG(product.SellingPrice) FROM product
   WHERE product.ProductCategory = "Children")
   ;


##HW4
SELECT * FROM manager;
SELECT * FROM employees;
SELECT * FROM location;

##1. Get IDs whose first name starts with "pa", followed by 3 chr and end with "a"a
SELECT EmployeeID FROM employees
WHERE FirstName LIKE "pa___a";

##2.How many employees at non-region office were hired after 2000?
SELECT COUNT(*) FROM employees AS e
INNER JOIN location AS l
ON e.Location = l.Location
WHERE l.RegionalOffice = "NO" AND YEAR(e.hired_date) > 2000;

##3.IDs of newest Account Rep who is working in a location with audit code = 100
SELECT e.EmployeeID,e.Title FROM employees AS e
INNER JOIN location AS l
ON e.Location = l.Location
WHERE l.AuditCode = 100 AND e.Title = "Account Rep"
ORDER BY e.hired_date DESC
LIMIT 1;

##4.AVG salaries for 3 groups: poor-perform account_rep, poor manager, poor trainee, group by multi categories
SELECT AVG(salaries), e.Title, e.Performance FROM employees AS e
WHERE e.Performance = "Poor"
GROUP BY e.Title;

##retrieve all inform about employees whose hired data is 31 and whose last name consists of 5 chr
SELECT * FROM employees AS e
WHERE day(hired_date) = 31 AND LENGTH(e.LastName) = 5;


###SUMMARY SAMPLE QUESTION
#CREATE
CREATE TABLE project(
ProjectID INTEGER,
ProjectName VARCHAR(100),
StartTime DATE,
ManagerID INTEGER,
PRIMARY KEY (ProjectID)
);
#INSERT
INSERT INTO manager (EmployeeID, LastName, FirstName)
VALUES(111000, "Young", "Alwvn");
#DROP 
DROP TABLE project;
#update employee's 11100's location to Chicago
UPDATE employees
SET location = "Chicago"
WHERE EmployeeID = "11110";
#delete
DELETE FROM employees
WHERE EmployeeID = 99999;

#6
SELECT * FROM employees
WHERE Title = "manager"
ORDER BY salaries;
#7
SELECT  DISTINCT Title FROM employees;
#8
SELECT * FROM employees
ORDER BY salaries DESC
LIMIT 3;
#9.
SELECT AVG(salaries), MIN(salaries), MAX(salaries) FROM employees;
#10.
SELECT MAX(salaries)-MIN(salaries) AS extreme_diff FROM employees;
#11.
SELECT COUNT(DISTINCT location) FROM employees 
WHERE FirstName LIKE "J%";
#12.
SELECT DISTINCT location, AVG(DATEDIFF(NOW(), hired_date)/365) AS Avgtenure FROM employees
GROUP BY location
ORDER BY Avgtenure DESC
LIMIT 1;
#13
SELECT MAX(salaries)-MIN(salaries) AS extreme_diff, Title FROM employees
GROUP BY Title;
#14.
SELECT DISTINCT location, MAX(salaries)-MIN(salaries) AS extreme_diff FROM employees
GROUP BY Location
HAVING extreme_diff > 40000;
#15.
SELECT DISTINCT e.ManagerID, COUNT(*) FROM employees AS e
LEFT JOIN manager AS m
ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID !=""
GROUP BY e.ManagerID
ORDER BY COUNT(*) DESC;
LIMIT 1;

#15
SELECT COUNT(*) AS groupsize, manager.* FROM manager
LEFT JOIN employees
ON employees.ManagerID = manager.EmployeeID
GROUP BY manager.EmployeeID
ORDER BY groupsize DESC;

#16
SELECT * FROM employees AS e
WHERE e.Title != "Manager" AND e.salaries >
      (SELECT AVG(m.salaries) AS avgmanager FROM employees AS m)
      ;
#17

#18
SELECT e.LastName, e.FirstName, e.EmployeeID, e.Performance, COUNT(*) AS people FROM employees AS e
RIGHT JOIN manager AS m
ON e.ManagerID = m.EmployeeID
GROUP BY m.EmployeeID
HAVING e.Performance = "Good"
ORDER BY people;
LIMIT 1;

#19
SELECT * FROM employees AS e
LEFT JOIN 

#20
SELECT * FROM employees AS e
WHERE location = (SELECT location FROM employees 
                  GROUP BY location
                  ORDER BY AVG(salaries) DESC 
                  LIMIT 1);
                  