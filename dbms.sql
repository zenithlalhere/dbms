CREATE DATABASE STUDENT;
USE STUDENT;
create table students(SID varchar(10) primary key, SName varchar(30), course char(20),dob date, contact_no int(10));
DESC students;
INSERT INTO STUDENTS VALUES('101','DIYA','BVOC','2001-05-18', '88888888');
SELECT * FROM STUDENTS;
SELECT SNAME,COURSE FROM STUDENTS WHERE DOB BETWEEN '2001-04-03' AND '2006-12-31';
SELECT * FROM STUDENTS WHERE COURSE = 'BVOC';
SELECT SNAME, timestampdiff(YEAR,DOB,CURDATE()) AS AGE FROM STUDENTS;



CREATE DATABASE STUDENT_COURSE;
CREATE TABLE STUDENT(ROLL_NO CHAR(6) PRIMARY KEY,STUDENT_NAME VARCHAR(20), COURSE_ID VARCHAR(10), DOB DATE);

CREATE TABLE COURSE(CID CHAR(6)PRIMARY KEY, COURSE_NAME VARCHAR(20), COURSE_TYPE CHAR(8), TEACHER_IN_CHARGE VARCHAR(15), TOTAL_SEATS INT UNSIGNED, DURATION INT UNSIGNED);

CREATE TABLE ADMISSION(ROLL_NO CHAR(6), CID CHAR(6), DATE_OF_ADMISSION DATE, FOREIGN KEY(ROLL_NO) REFERENCES STUDENT(ROLL_NO), FOREIGN KEY(CID) REFERENCES COURSE(CID));

INSERT INTO STUDENT VALUES
('101', 'Amit Kumar', 'S1', '2001-05-15'),
('102', 'Ravi Singh', 'S2', '2000-07-20'),
('103', 'Anjali Verma', 'S3', '2002-08-12'),
('104', 'Arjun Roy', 'S4', '1999-03-22'),
('105', 'Zara Khan', 'S2', '2001-11-30'),
('106', 'Xavier Peter', 'S1', '2000-02-15'),
('107', 'Zayn Malik', 'S4', '1999-09-09');

SELECT * FROM STUDENT;

INSERT INTO COURSE VALUES('S1', 'CS', 'FULLTIME', 'SAHIL PATHAK', 50,120),
('S3', 'MATHS', 'FULLTIME', 'RAHUL PATHAK', 40,150),
('S2', 'CHEMISTRY', 'PARTTIME', 'RAMESH GUPTA', 60,180),
('S4', 'BCOM', 'PARTTIME', 'PRAKHAR WADHWA', 60,180),
('S5', 'HISTORY', 'PARTTIME', 'UMESH JHA', 40,100);

SELECT * FROM COURSE;

#anycourse
SELECT STUDENT_NAME FROM STUDENT a, COURSE b, ADMISSION c WHERE a.ROLL_NO = c.ROLL_No AND c.CID = b.CID;

#atleast one parttime
SELECT STUDENT_NAME FROM STUDENT INNER JOIN COURSE WHERE STUDENT.COURSE_ID = COURSE.CID GROUP BY STUDENT_NAME,COURSE_TYPE HAVING COURSE_TYPE = "PARTTIME";

#starts with A
SELECT STUDENT_NAME FROM STUDENT WHERE STUDENT_NAME LIKE "A_%";
#Computer or Chemistry Students
SELECT * FROM STUDENT INNER JOIN COURSE ON STUDENT.COURSE_ID = COURSE.CID GROUP BY ROLL_NO HAVING COURSE_NAME = "CS" OR COURSE_NAME = "CHEMISTRY";

SELECT STUDENT_NAME FROM STUDENT WHERE ROLL_NO LIKE "X%9" OR ROLL_NO LIKE "Z%9";

#courses with more than N Students
SET @N = 1;
SELECT COURSE.*, COUNT(CID) FROM ADMISSION LEFT JOIN COURSE USING(CID) GROUP BY CID HAVING COUNT(CID) = @N;

#Change Student name in TABLE
UPDATE STUDENT SET STUDENT_NAME = "Siddhart" WHERE ROLL_NO = '104';

#youngest
ALTER TABLE STUDENT ADD COLUMN AGE INT(5);
UPDATE STUDENT SET AGE = YEAR(NOW()) - YEAR(DOB);
SELECT STUDENT_NAME,AGE,COURSE_NAME FROM STUDENT LEFT JOIN ADMISSION USING(ROLL_NO) LEFT JOIN COURSE ON COURSE.CID = STUDENT.COURSE_ID HAVING COURSE_NAME='CS' ORDER BY AGE LIMIT 1;

#POPULAR COURSE
SELECT COURSE.COURSE_NAME, COUNT(*) AS ENROLLED FROM ADMISSION GROUP BY CID ORDER BY ENROLLED DESC LIMIT 1;

#popular Parttime

SELECT COURSE.COURSE_NAME,COURSE_TYPE,COUNT(*) AS ENROLLED FROM ADMISSION LEFT JOIN COURSE USING(CID) GROUP BY CID HAVING COURSE_TYPE = "PARTTIME" ORDER BY ENROLLED DESC LIMIT 2;

#fulltime students
SELECT STUDENT_NAME,COURSE_TYPE FROM STUDENT LEFT JOIN ADMISSION USING(ROLL_NO) LEFT JOIN COURSE USING(CID) WHERE COURSE_TYPE = "FULLTIME";

#name of all student students enrolled
SELECT s.STUDENT_NAME, c-.COURSE_NAME FROM STUDENT AS s, COURSE AS c, ADMISSION AS a WHERE s.COURSE_ID = c.CID AND c.CID = a.CID GROUP BY a.CID, s.STUDENT_NAME, c.COURSE_NAME HAVING COUNT(c.CID) >=1;

#surname
SELECT COURSE_NAME FROM COURSE WHERE TEACHER_IN_INCHARGE LIKE "%GUPTA" AND COURSE_TYPE="FULLTIME";

#vacant Seats
SELECT(TOTAL_SEATS - COUNT(ADMISSION.ROLL_NO)) AS VACANT_SEATS FROM COURSE INNTER JOIN ADMISSION USING(CID) GROUP BY CID;

#increase no of seats
SELECT ROUND(TOTAL_SEATS + 0.2*TOTAL_SEATS) AS AFTER_INCREASED_SEATS FROM COURSE INNER JOIN ADMISSION USING(CID) GROUP BY CID;

#Enrollement fee
ALTER TABLE ADMISSION ADD COLUMN FEES_PAID ENUM ("YES","NO") DEFAULT("NO");


#create view course name no.students

CREATE VIEW COURSES AS SELECT COURSE_NAME,COUNT(*) AS ENROLLED FROM COURSE INNER JOIN ADMISSION USING(CID) GROUP BY CID;

#more than 5 student enrolled
SELECT COUNT(COURSE_NAME) AS COURSE FROM COURSES WHERE ENROLLED >=2;

#phone number
ALTER TABLE STUDENT ADD COLUMN MOBILE_NO BIGINT(10) DEFAULT("9999999999");


#total no. students whose age is >18

SELECT COUNT(STUDENT_NAME) FROM STUDENT WHERE STUDENT.AGE >18;

SELECT STUDENT_NAME, AGE FROM STUDENT WHERE AGE >18;

#born in _ and admitted in one parttime course
SELECT STUDENT_NAME, DOB, COURSE_TYPE FROM STUDENT RIGHT JOIN ADMISSION USING(ROLL_NO) RIGHT JOIN COURSE USING(CID) WHERE STUDENT.DOB LIKE"2001%" AND COURSE_TYPE = "PARTTIME";

#BSc is Science
INSERT INTO COURSE VALUES ('A1', 'BSc. Science','FULLTIME','SUBODH',30,100), ('A2','BSc. BIO_SCIENCE','PARTTIME','VIKASH',60,100);

SELECT COUNT(COURSE_NAME) FROM COURSE WHERE COURSE_NAME LIKE "BSc%";



