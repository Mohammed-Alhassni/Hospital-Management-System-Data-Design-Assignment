CREATE DATABASE HMS

USE HMS

CREATE TABLE Patient
(
	patient_id int PRIMARY KEY,
	first_name varchar,
	last_name varchar,
	dob date,
	gender varchar,
	blood_group varchar,
	age_derived varchar,
)


CREATE TABLE Doctor
(
	doctor_id int PRIMARY KEY,
	first_name varchar,
	last_name varchar,
	specialization varchar,
)

CREATE TABLE Department
(
	department_id int PRIMARY KEY,
	dept_name varchar,
	head_doctor_id int,
	constraint fk_dep_doc
		FOREIGN KEY (head_doctor_id) references Doctor(doctor_id)
)

ALTER TABLE Doctor ADD department_id int references Department(department_id)


CREATE TABLE Doctor_Schedule
(
	schedule_id int PRIMARY KEY,
	doctor_id int,
	day_of_week varchar,
	start_time date,
	end_time date,
	constraint fk_sch_doc
		FOREIGN KEY (doctor_id) references Doctor(doctor_id)
)


CREATE TABLE Appointment
(
	appointment_id int PRIMARY KEY,
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

CREATE TABLE Medical_Record
(
	record_id int PRIMARY KEY,
	patient_id int,
	doctor_id int,
	appointment_id int,
	diagnosis varchar,
	treatment_plan varchar,
	record_date date,
	constraint fk_rec_pat
		FOREIGN KEY (patient_id) references Patient(patient_id),
	constraint fk_rec_doc
		FOREIGN KEY (doctor_id) references Doctor(doctor_id),
	constraint fk_rec_app
		FOREIGN KEY(appointment_id) references Appointment(appointment_id)
)

CREATE TABLE Category_Service
(
	categiory_id int PRIMARY KEY,
	category_name varchar,
	description varchar,
)

CREATE TABLE Service
(
	service_id int PRIMARY KEY,
	service_name varchar,
	current_price int,
	categiory_id int,
	constraint fk_ser_cate
		FOREIGN KEY (categiory_id) references Category_Service(categiory_id)
)


CREATE TABLE Appointment_Service 
(
	appointment_id int,
	service_id int,
	quantity int,
	unit_price_at_time dec,
	constraint fk_appSer_app
		FOREIGN KEY (appointment_id) references Appointment(appointment_id),
	constraint fk_appSer_ser
		FOREIGN KEY (service_id) references Service(service_id)
)

CREATE TABLE Billing 
(
	bill_id int PRIMARY KEY,
	appointment_id int,
	total_amount dec,
	insurance_covered dec,
	remaining_amount dec,
	payment_status varchar,
	payment_date date
	constraint fk_bil_app
		FOREIGN KEY (appointment_id) references Appointment(appointment_id)
)

CREATE TABLE Payment 
(
	payment_id int PRIMARY KEY,
	bill_id int,
	payment_method varchar,
	amount_paid dec,
	paid_at date,
	constraint fk_pay_bil
		FOREIGN KEY (bill_id) references Billing(bill_id)
)

CREATE TABLE Insurance 
(
	insurance_id int PRIMARY KEY,
	patient_id int,
	provider_name varchar,
	policy_number varchar,
	coverage_limit dec,
	expiry_date date,
	constraint fk_Insur_Pat
		FOREIGN KEY (patient_id) references Patient(patient_id)
)