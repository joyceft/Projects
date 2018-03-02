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
SELECT DISTINCT LeadStudio FROM Hollywood
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
HAVING COUNT(Genre) >2;
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
