# Hospital Management System — ERD Design Assignment

## Project Overview

This project is a full system design assignment for a Hospital Management System (HMS). Rather than jumping straight into drawing, the work begins with structured analysis — classifying every component of the system before any design decisions are made. The deliverable covers system analysis, logical design, ERD, real-world scenario handling, and a mid-day change request (Version 2) that extends the original design with five new business requirements.

---

## Key Design Decisions

### Entities Identified

| Entity | Type | Reasoning |
|---|---|---|
| Patient | Strong | Exists independently; has its own identity |
| Doctor | Strong | Exists independently; not dependent on any other entity |
| Department | Strong | Independent; contains doctors and services |
| Appointment | Strong | Central entity linking patient and doctor; exists in its own right |
| Service | Strong | Independent; reused across many appointments |
| Appointment_Service | Weak (junction) | Exists only in the context of a specific appointment and service; holds the relationship attribute `quantity` |
| Medical_Record | Weak | Meaningful only in relation to a patient, doctor, and appointment |
| Billing | Weak | Dependent on appointment; has no meaning without one |

### Attributes of Note

- **Age** in Patient is a **derived attribute** — it can always be calculated from `DOB` and the current date. It is not stored as a column; it is computed at query time to avoid stale data.
- **Total_amount** in Billing is also **derived** — it is calculated from the services used in the linked appointment multiplied by their quantities, not stored directly.
- **Appointment_id and Bill_id** embedded in the original Patient table are **misplaced relationship references**, not attributes. They belong as foreign keys in their respective tables, not in Patient.
- **Quantity** in the Appointment–Service relationship is a **relationship attribute** — it describes how many units of a service were used in a specific appointment. It cannot live in either Service or Appointment alone, so it belongs in the `Appointment_Service` junction table.

### Critical Relationship: Appointment ↔ Service

The relationship between Appointment and Service is **many-to-many**: one appointment can use many services, and one service can appear in many appointments. This is resolved into the `Appointment_Service` junction table with `(appointment_id, service_id)` as a composite primary key. The `quantity` column lives here because it describes the relationship itself, not either entity independently.

### Department Head

The head doctor relationship is modelled as a **self-referencing optional FK** on Department (`head_doctor_id` referencing `Doctor.doctor_id`). It is nullable — not every department is required to have a named head at all times. A doctor can only head one department, maintaining a 1:1 optional relationship.

---

## Version 2 Changes (Mid-Day Change Request)

Five new requirements were added mid-task. None required a redesign from scratch — each was incorporated as a targeted addition or modification:

### 1. Insurance
A new **Insurance** entity was added with its own primary key, provider name, policy number, coverage percentage, and a FK to Patient. A patient may have zero or one insurance record (1:M from Patient to Insurance, partial on Patient side). Billing now references Insurance to determine the covered amount.

### 2. Multiple Payment Methods
The original `payment_method` column on Billing was a single value, which cannot support split payments. This was replaced by a new **Bill_Payment** junction table: `(bill_payment_id, billing_id, payment_method, amount_paid, payment_date)`. This allows one bill to record multiple partial payments across different methods (Cash, Card, Insurance) without violating 1NF.

### 3. Doctor Schedule
A new **Doctor_Schedule** entity was added: `(schedule_id, doctor_id, day_of_week, start_time, end_time)`. This is a 1:M relationship from Doctor to Doctor_Schedule. Appointments must fall within a valid schedule entry for the assigned doctor, which can be enforced at the application layer or via a trigger.

### 4. Appointment Status Update
The `status` column on Appointment now accepts four values: `'Scheduled'`, `'Completed'`, `'Cancelled'`, `'No-show'`. This is a constraint-level change — no structural modification to the table was required, only the CHECK constraint was expanded.

### 5. Service Categories
A new **Service_Category** entity was added: `(category_id, category_name, description)`. A FK `category_id` was added to the **Service** table, replacing the free-text `service_type` column. This enforces consistent grouping and allows services to be filtered or reported by category cleanly.

---

## Scenario Analysis

### Appointment Cancellation
When an appointment is cancelled, its `status` is updated to `'Cancelled'`. Medical records and billing records linked to that appointment remain in the system for audit and history purposes. No cascade delete is triggered. If a bill exists for a cancelled appointment, its `payment_status` can be updated to `'Cancelled'` separately.

### Doctor Leaving
The Doctor table retains the record. If a doctor is deactivated, a soft-delete approach is preferred — adding an `is_active` flag — rather than physically deleting the row, because existing appointments and medical records reference that doctor. Hard deletion would violate referential integrity unless all dependent records were removed first, which would destroy clinical history.

### Partial Payments
Handled by the **Bill_Payment** table introduced in Version 2. Each payment installment is recorded as a separate row. The total paid is derived by summing all `Bill_Payment.amount_paid` records for a given `billing_id`. The `payment_status` on Billing is updated to `'Partial'` when at least one payment exists but the sum is below the total amount, and `'Paid'` when fully settled.

### Service Price Changes
The current design stores `unit_price` directly on Service. If a price changes, historical billing amounts remain correct because `Billing.total_amount` is either stored at the time of billing or derived from `Appointment_Service.quantity × Service.unit_price` at billing creation time. For full auditability, a **Service_Price_History** table could be added in a future version to track price changes over time with effective dates.

---

## Challenges Faced

- **Derived vs. stored attributes:** Deciding whether to store `age` and `total_amount` or compute them required understanding the trade-off between query performance and data accuracy. The decision was to compute both rather than risk stale values.
- **Where quantity belongs:** This was the most critical modelling decision. Placing `quantity` in Appointment or Service would have created a partial dependency. It belongs only in the junction table.
- **Version 2 mid-task:** Adding multiple payment methods after the initial design was already committed required restructuring the Billing table's payment model without breaking the rest of the schema. Introducing `Bill_Payment` as a new table was the cleanest solution.
- **Department head:** The circular reference (Department has a head Doctor, Doctor belongs to a Department) required careful ordering during table creation — `head_doctor_id` must be added as a nullable column after both tables exist, to avoid a bootstrapping FK conflict.
