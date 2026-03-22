DROP DATABASE enhanced_abc_university;
CREATE DATABASE enhanced_abc_university;
USE enhanced_abc_university;

CREATE TABLE Department (
Department_Name varchar(50) NOT NULL,
Department_ID int PRIMARY KEY,
Dean varchar(50) UNIQUE NOT NULL
);

CREATE TABLE Office_Locations (
   Dep_ID INT,
   Location VARCHAR(100),
   CONSTRAINT fk_Office_Locations FOREIGN KEY (Dep_ID) REFERENCES
Department(Department_ID), 
CONSTRAINT pk_Office_Locations PRIMARY KEY (Dep_ID, Location)
);

CREATE TABLE Programs (
   Program_ID INT PRIMARY KEY,
   Program_Name VARCHAR(50),
   Dep_ID INT,
   CONSTRAINT fk_Programs FOREIGN KEY (Dep_ID) REFERENCES
Department(Department_ID)
);

CREATE TABLE Degree_Level (
   Prog_ID INT,
   Degree VARCHAR(50),
CONSTRAINT pk_Degree_Level PRIMARY KEY (Prog_ID, Degree),
   CONSTRAINT fk_Degree_Level FOREIGN KEY (Prog_ID) REFERENCES
Programs(Program_ID)
);

CREATE TABLE Courses (
   Course_Code VARCHAR(10) PRIMARY KEY,
   Course_Name VARCHAR(50),
   Credit_Hours INT CHECK (Credit_Hours BETWEEN 1 AND 6),
   Dep_ID INT,
   Prog_ID INT,
   CONSTRAINT fk_CoursesP FOREIGN KEY (Prog_ID) REFERENCES Programs(Program_ID),
   CONSTRAINT fk_CoursesD FOREIGN KEY (Dep_ID) REFERENCES
Department(Department_ID)
);

CREATE TABLE Person (
Person_ID int PRIMARY KEY,
Fname varchar(20),
Minit varchar(5),
Lname varchar(20), 
Date_of_Birth date,
Gender varchar(1)
);

CREATE TABLE Instructors (
Pers_ID int,
Instructor_ID int UNIQUE, 
Staff_Email varchar(40) NOT NULL,
Hire_Date date, Dep_ID int,
CONSTRAINT pk_instructorSP PRIMARY KEY (Pers_ID, Instructor_ID), 
CONSTRAINT fk_instructorFK FOREIGN KEY (Dep_ID) references
Department(Department_ID),
CONSTRAINT uk_instructorsUNI UNIQUE (Staff_Email)
);

CREATE TABLE Deliver (
C_Code VARCHAR(10),
Instruc_ID INT,
CONSTRAINT pk_Deliver PRIMARY KEY (C_Code, Instruc_ID),
CONSTRAINT fk_DeliverC FOREIGN KEY (C_Code) REFERENCES Courses(Course_Code),
CONSTRAINT fk_DeliverI FOREIGN KEY (Instruc_ID) REFERENCES Instructors(Instructor_ID)
);

CREATE TABLE Classrooms (
Building_Name VARCHAR(30) NOT NULL,
Room_Number INT NOT NULL,
Capacity INT,
CONSTRAINT pk_Classrooms PRIMARY KEY (Building_Name, Room_Number)
);

CREATE TABLE Course_Offerings (
C_Code VARCHAR(10),
Room_No INT,
Build_Name VARCHAR(30),
Year INT,
Semester VARCHAR(20),
Course_Time TIME,
CONSTRAINT pk_Course_Offerings PRIMARY KEY (C_Code, Year, Semester,
Course_Time),
CONSTRAINT fk_Course_OfferingsC FOREIGN KEY (C_Code) REFERENCES
Courses(Course_Code),
CONSTRAINT fk_Course_OfferingsR FOREIGN KEY (Build_Name, Room_No) REFERENCES
Classrooms(Building_Name, Room_Number)
);

CREATE TABLE Linked_to (
Instruc_ID INT,
C_Code VARCHAR(10),
Year INT,
Semester VARCHAR(20),
C_Time TIME,
CONSTRAINT pk_Linked_to PRIMARY KEY (Instruc_ID, C_Code, Year, Semester, C_Time),
CONSTRAINT fk_Linked_toI FOREIGN KEY (Instruc_ID) REFERENCES
Instructors(Instructor_ID),
CONSTRAINT fk_Linked_toC FOREIGN KEY (C_Code) REFERENCES
Courses(Course_Code),
CONSTRAINT fk_Linked_toT FOREIGN KEY (C_Code, Year, Semester, C_Time) REFERENCES
Course_Offerings(C_Code, Year, Semester, Course_Time)
);

CREATE TABLE Students (
Pers_ID int,
Student_ID int UNIQUE, 
University_Email varchar(40) UNIQUE NOT NULL,
Major varchar(30) NOT NULL, 
Enrollment_Year int,
Advisor_ID int,
Dep_ID int,
Prog_ID int,
CONSTRAINT pk_students PRIMARY KEY (Pers_ID, Student_ID), 
CONSTRAINT fk_students1 FOREIGN KEY (Advisor_ID) REFERENCES
Instructors(Instructor_ID),
CONSTRAINT fk_students2 FOREIGN KEY (Dep_ID) REFERENCES
Department(Department_ID), 
CONSTRAINT fk_students3 FOREIGN KEY (Prog_ID) REFERENCES Programs(Program_ID)
);

CREATE TABLE Enroll (
Stud_ID INT,
C_Code VARCHAR(10),
Semester VARCHAR(20),
Year INT,
C_Time TIME,
Grade VARCHAR(2),
CONSTRAINT pk_Enroll PRIMARY KEY (Stud_ID, C_Code, Semester, Year, C_Time),
CONSTRAINT fk_EnrollS FOREIGN KEY (Stud_ID) REFERENCES Students(Student_ID),
CONSTRAINT fk_EnrollOffering FOREIGN KEY (C_Code, Year, Semester,C_Time)
REFERENCES Course_Offerings(C_Code, Year, Semester, Course_Time)
);

CREATE TABLE Scholarships (
Scholarship_Name varchar(30) PRIMARY KEY, 
Amount int, 
Eligibility_Desc varchar(100),
M_Flag boolean,
Scholarship_ID int UNIQUE,
Minimum_GPA float,
S_Flag boolean, 
Sponsor_ID int UNIQUE, 
Sponsor_Name varchar(30) 
);

CREATE TABLE Awarded (
Stud_ID INT,
Scholar_Name VARCHAR(30),
Year_Awarded INT,
CONSTRAINT fk_AwardedS FOREIGN KEY (Stud_ID) REFERENCES Students(Student_ID),
CONSTRAINT fk_AwardedSc FOREIGN KEY (Scholar_Name) REFERENCES
Scholarships(Scholarship_Name),
CONSTRAINT pk_Awarded PRIMARY KEY (Stud_ID, Scholar_Name, Year_Awarded)
);