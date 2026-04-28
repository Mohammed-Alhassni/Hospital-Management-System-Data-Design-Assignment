CREATE DATABASE HMS

USE HMS

CREATE TABLE Patient (patient_id int PRIMARY KEY, 
					  first_name varchar,
					  last_name varchar,
					  dob date,
					  gender varchar,
					  blood_group varchar,
					  age_derived varchar,
					  )


CREATE TABLE Doctor (doctor_id int PRIMARY KEY, 
					 first_name varchar,
					 last_name varchar,
					 specialization varchar,
					 )

CREATE TABLE Department (department_id int PRIMARY KEY, 
						 dept_name varchar,
						 head_doctor_id int,
						 constraint fk_dep_doc
						  FOREIGN KEY (head_doctor_id) references Doctor(doctor_id)
						 )

ALTER TABLE Doctor ADD department_id int references Department(department_id)


CREATE TABLE Doctor_Schedule (schedule_id int PRIMARY KEY, 
							 doctor_id int,
							 day_of_week varchar,
							 start_time date,
							 end_time date,
							 constraint fk_sch_doc
							 FOREIGN KEY (doctor_id) references Doctor(doctor_id)
						     )


CREATE TABLE Appointment	(appointment_id int PRIMARY KEY, 
							 schedule_at date,
							 appoint_status varchar,
							 appoint_type varchar,
							 patient_id int,
							 doctor_id int,
							 constraint fk_app_doc
							 FOREIGN KEY (doctor_id) references Doctor(doctor_id),
							 constraint fk_sch_pat
							 FOREIGN KEY (patient_id) references Patient(patient_id)
						     )
