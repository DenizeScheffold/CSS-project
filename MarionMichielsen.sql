CREATE TABLE UNF (
    Id DECIMAL(38, 0) NOT NULL,
    Name VARCHAR(30) NOT NULL,
    Grade VARCHAR(11) NOT NULL,
    Hobbies VARCHAR(25),
    City VARCHAR(15) NOT NULL,
    School VARCHAR(25) NOT NULL,
    HomePhone VARCHAR(12),
    JobPhone VARCHAR(12),
    MobilePhone1 VARCHAR(12),
    MobilePhone2 VARCHAR(12)
);

LOAD DATA INFILE '/var/lib/mysql-files/denormalized-data.csv'
INTO TABLE UNF 
character set latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table if exists Hobbies;         
drop table if exists HobbyType  ;     
drop view if exists NEWUNF;
drop table if exists Phones;          
drop table if exists Phonetype;       
drop table if exists School    ;      
drop table if exists StudentHobby;    
drop table if exists User          ;  
drop table if exists UserGrade     ;  
drop table if exists UserPhone      ; 
drop table if exists UserSchool;
drop table if exists Grade;

create table User as
select distinct Id, Name from UNF;

ALTER TABLE User ADD PRIMARY KEY(Id);
ALTER TABLE User MODIFY Id INTEGER NOT NULL AUTO_INCREMENT;


create table Grade AS
select distinct 0 as Id, Grade as Grade from UNF;
SET @incrementValue = 0;
UPDATE Grade set Id = (select @incrementValue := @incrementValue + 1);

create table UserGrade AS
select distinct UNF.Id as UserId, Grade.Id as GradeId from UNF
inner join Grade on UNF.Grade = Grade.Grade;

update UserGrade
set GradeId = 2
where GradeId = 5
;
update UserGrade
set GradeId = 2
where GradeId = 6
;
update UserGrade
set GradeId = 9
where GradeId = 10
;
update UserGrade
set GradeId = 8
where GradeId = 4
;
update UserGrade
set GradeId = 1
where GradeId = 11
;

update Grade 
set Grade = 'Gorgeous' 
where Id = 8;

delete from Grade where Id= 6;
delete from Grade where Id= 5;
delete from Grade where Id= 4;
delete from Grade where Id= 10;
delete from Grade where Id= 11;


create table School AS
select distinct 0 as Id, School as Name, City from UNF;

SET @incrementValue = 0;
UPDATE School set Id = (select @incrementValue := @incrementValue + 1);

ALTER TABLE School ADD PRIMARY KEY(Id);
ALTER TABLE School MODIFY Id INTEGER NOT NULL AUTO_INCREMENT;

create table UserSchool AS
select distinct UNF.Id as UserId, School.Id as SchoolId from UNF
inner join School on UNF.School = School.Name;

CREATE TABLE Phones AS
select Id, "Home" as Type, 1 As PhoneNo, HomePhone As Phone, true as Home, False as Work, false as Mobile from UNF
union select Id, "Job" As Type, 2 as PhoneNo, JobPhone as Phone, false as Home, True as Work, false as Mobile from UNF
Union select Id, "Mobile" as Type, 3 as PhoneNo, MobilePhone1 as Phone, false as Home, false as Work, true as Mobile from UNF
union select Id, "Mobile" as Type, 4 as PhoneNo, MobilePhone2 as Phone, false as Home, false as Work, true as Mobile from UNF;

DELETE FROM Phones WHERE Phone = "";

create table UserPhone as 
SELECT Name, GROUP_CONCAT(Phone) as PhoneNumbers
FROM User 
LEFT JOIN Phones 
ON User.Id = Phones.Id 
GROUP BY Name;

CREATE TABLE Phonetype AS
SELECT DISTINCT PhoneNo AS Id, Type AS Name FROM Phones;

create table StudentHobby as
select distinct Id as StudentId, SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies, ' ', 1), ' ', -1) AS Hobby1,
SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies, ' ', 2), ' ', -1) AS Hobby2,
SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies, ' ', 3), ' ', -1) AS Hobby3 from UNF
where Hobbies like "%,%,%";

 create table Hobby2 as 
 select distinct Id as StudentId, SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies, ' ', 1), ' ', -1) AS Hobby1,
SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies, ' ', 2), ' ', -1) AS Hobby2,
'' AS Hobby3 from UNF
where Hobbies not like "%,%,%"
and Hobbies like "%,%";

INSERT INTO StudentHobby SELECT * FROM Hobby2;

 create table Hobby1 as 
 select distinct Id as StudentId, SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies, ' ', 1), ' ', -1) AS Hobby1,
'' AS Hobby2,
'' AS Hobby3 from UNF
where Hobbies not like "%,%";

  
 INSERT INTO StudentHobby SELECT * FROM Hobby1;

 select Hobby1 from StudentHobby
where Hobby1 like '%,';

  Update StudentHobby
set Hobby1 = SUBSTR(Hobby1, 1, LENGTH(Hobby1) - 1)
  where Hobby1 like '%,';

 Update StudentHobby
set Hobby2 = SUBSTR(Hobby2, 1, LENGTH(Hobby2) - 1)
  where Hobby2 like '%,';
  
  select * from StudentHobby order by StudentId;
  
  select StudentId,  1 As HobbyNumber, Hobby1 As Hobby from StudentHobby
union select StudentId,  2 as HobbyNumber, Hobby2 as Hobby from StudentHobby
Union select StudentId, 3 as HobbyNumber, Hobby3 as Hobby from StudentHobby;

create table Hobbies as 
select StudentId,  1 As HobbyNumber, Hobby1 As Hobby from StudentHobby
union select StudentId,  2 as HobbyNumber, Hobby2 as Hobby from StudentHobby
Union select StudentId, 3 as HobbyNumber, Hobby3 as Hobby from StudentHobby;

delete from Hobbies where Hobby = '';
delete from Hobbies where Hobby ='Nothing';

select * from Hobbies order by StudentId;

CREATE TABLE HobbyType AS
SELECT DISTINCT 0 As HobbyId, Hobby AS Name FROM Hobbies;

SET @incrementValue = 0;
UPDATE HobbyType set HobbyId = (select @incrementValue := @incrementValue + 1);


Drop table Hobby1;
drop table Hobby2;

create view NEWUNF as 
SELECT distinct User.Id, User.Name, GROUP_CONCAT(distinct Hobby) as Hobbies, GROUP_CONCAT(distinct Type, ' ', Phone) as PhoneNumbers, School.Name as SchoolName, School.City, Grade.Grade 
FROM User 
left  JOIN Hobbies ON User.Id= Hobbies.StudentId
inner JOIN Phones ON User.Id = Phones.Id 
inner join UserSchool on User.Id = UserSchool.UserId
inner join School on UserSchool.SchoolId = School.Id
inner join UserGrade on User.Id = UserGrade.UserId
inner join Grade on UserGrade.GradeId = Grade.Id
GROUP BY User.Id,  School.Name, School.City, Grade.Grade;






