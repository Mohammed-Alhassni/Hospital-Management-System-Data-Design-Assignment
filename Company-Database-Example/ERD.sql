CREATE DATABASE CODELINE

USE CODELINE


CREATE TABLE Employee (SSN int primary key,
						Birthday date,
						FirstName varchar,
						LastName varchar,
						Supervisor int REFERENCES Employee(SSN)
						)


CREATE TABLE Department (DepNum int primary key,
						DepName varchar,
						HireDate Date,
						ManagerID int REFERENCES Employee(SSN)
						)


ALTER TABLE Employee ADD DepNum int REFERENCES Department(DepNum) -- Shortcut: No "FOREIGN KEY" keywords needed

/* 
--alternative way more, better 
ALTER TABLE Employee 
ADD CONSTRAINT fk_emp_dept 
FOREIGN KEY (DepNum) REFERENCES Department(DepNum);
*/


CREATE TABLE DepLocation (DepNum int,
						  LocationID VARCHAR,
						  PRIMARY KEY (DepNum, LocationID),
						  CONSTRAINT fk_dep_loc
						  FOREIGN KEY (DepNum) REFERENCES Department(DepNum),
						  )

CREATE TABLE Project (PNum int PRIMARY KEY,
					  PName VARCHAR,
					  Loc VARCHAR,
					  DepNum int,
					  CONSTRAINT fk_Proj_Dept
					  FOREIGN KEY (DepNum) REFERENCES Department(DepNum),
					 );

CREATE TABLE EmpWorkHrs (SSN int,
						PNum int,
						PRIMARY KEY (SSN, PNum),
						CONSTRAINT Hrs_Emp
						FOREIGN KEY (SSN) REFERENCES Employee(SSN),
						CONSTRAINT Hrs_Proj
						FOREIGN KEY (PNum) REFERENCES Project(PNum),
						)

CREATE TABLE EmpDependent (DependentName VARCHAR,
						   Birthdate DATE,
						   Gender VARCHAR,
						   SSN INT REFERENCES Employee(SSN)
						   PRIMARY KEY (DependentName, SSN)
						   )


ALTER TABLE EmpWorkHrs ADD Hours int  