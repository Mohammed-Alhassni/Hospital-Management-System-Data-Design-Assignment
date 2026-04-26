# Logical Design 

## Patient
- Primary key: personal information
- Relationships: one to many (appointments, records, bills), many to many (doctors) 

## Doctor 
- Primary key: Profesional Details
- Relationships: many to one (department), one to one (department), one to many (appointments, patients, records)

