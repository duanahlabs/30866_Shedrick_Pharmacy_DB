-- Goes in: SQL Scripts/Create_tables.sql
-- (Full corrected table DDL — adds SALES, fixes STOCK_BATCHES supplier
-- link and received/available split, fixes DISPENSING batch tracking)

DROP TABLE dispensing        CASCADE CONSTRAINTS PURGE;
DROP TABLE sales             CASCADE CONSTRAINTS PURGE;
DROP TABLE prescription_items CASCADE CONSTRAINTS PURGE;
DROP TABLE prescriptions     CASCADE CONSTRAINTS PURGE;
DROP TABLE stock_batches     CASCADE CONSTRAINTS PURGE;
DROP TABLE drugs             CASCADE CONSTRAINTS PURGE;
DROP TABLE doctors           CASCADE CONSTRAINTS PURGE;
DROP TABLE patients          CASCADE CONSTRAINTS PURGE;
DROP TABLE employees         CASCADE CONSTRAINTS PURGE;
DROP TABLE suppliers         CASCADE CONSTRAINTS PURGE;
DROP TABLE public_holidays   CASCADE CONSTRAINTS PURGE;
DROP TABLE audit_log         CASCADE CONSTRAINTS PURGE;

CREATE TABLE suppliers (
    supplier_id     NUMBER PRIMARY KEY,
    supplier_name   VARCHAR2(100) NOT NULL,
    contact_person  VARCHAR2(100),
    phone           VARCHAR2(20) UNIQUE,
    email           VARCHAR2(100) UNIQUE,
    address         VARCHAR2(200)
);

CREATE TABLE drugs (
    drug_id         NUMBER PRIMARY KEY,
    drug_name       VARCHAR2(100) NOT NULL UNIQUE,
    generic_name    VARCHAR2(100),
    dosage_form     VARCHAR2(50),
    strength        VARCHAR2(30),
    category        VARCHAR2(50),
    unit_price      NUMBER(10,2) CHECK (unit_price >= 0),
    reorder_level   NUMBER CHECK (reorder_level >= 0)
);

CREATE TABLE stock_batches (
    batch_id            NUMBER PRIMARY KEY,
    drug_id             NUMBER NOT NULL,
    supplier_id         NUMBER NOT NULL,
    batch_number        VARCHAR2(40) UNIQUE NOT NULL,
    quantity_received   NUMBER CHECK (quantity_received >= 0),
    quantity_available  NUMBER CHECK (quantity_available >= 0),
    manufacture_date    DATE,
    expiry_date         DATE,
    date_received       DATE DEFAULT SYSDATE,
    CONSTRAINT chk_expiry CHECK (expiry_date > manufacture_date),
    CONSTRAINT chk_available_le_received CHECK (quantity_available <= quantity_received),
    CONSTRAINT fk_batch_drug FOREIGN KEY (drug_id) REFERENCES drugs(drug_id),
    CONSTRAINT fk_batch_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE patients (
    patient_id      NUMBER PRIMARY KEY,
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    gender          CHAR(1) CHECK (gender IN ('M','F')),
    date_of_birth   DATE,
    phone           VARCHAR2(20) UNIQUE
);

CREATE TABLE doctors (
    doctor_id       NUMBER PRIMARY KEY,
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    specialization  VARCHAR2(80),
    phone           VARCHAR2(20) UNIQUE
);

CREATE TABLE employees (
    employee_id     NUMBER PRIMARY KEY,
    first_name      VARCHAR2(50),
    last_name       VARCHAR2(50),
    role            VARCHAR2(40) CHECK (role IN ('Pharmacist','Cashier','InventoryManager','Admin')),
    username        VARCHAR2(50) UNIQUE,
    hire_date       DATE,
    phone           VARCHAR2(20) UNIQUE
);

CREATE TABLE prescriptions (
    prescription_id     NUMBER PRIMARY KEY,
    patient_id          NUMBER NOT NULL,
    doctor_id           NUMBER NOT NULL,
    prescription_date   DATE DEFAULT SYSDATE,
    status              VARCHAR2(20) CHECK (status IN ('Pending','Dispensed','Cancelled')),
    CONSTRAINT fk_pres_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_pres_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE prescription_items (
    prescription_item_id   NUMBER PRIMARY KEY,
    prescription_id        NUMBER NOT NULL,
    drug_id                NUMBER NOT NULL,
    quantity_prescribed     NUMBER CHECK (quantity_prescribed > 0),
    dosage_instructions     VARCHAR2(100),
    CONSTRAINT fk_item_prescription FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id),
    CONSTRAINT fk_item_drug FOREIGN KEY (drug_id) REFERENCES drugs(drug_id)
);

CREATE TABLE dispensing (
    dispensing_id           NUMBER PRIMARY KEY,
    prescription_item_id    NUMBER NOT NULL,
    batch_id                NUMBER NOT NULL,
    employee_id              NUMBER NOT NULL,
    quantity_dispensed        NUMBER CHECK (quantity_dispensed > 0),
    dispensing_date          DATE DEFAULT SYSDATE,
    CONSTRAINT fk_disp_item FOREIGN KEY (prescription_item_id) REFERENCES prescription_items(prescription_item_id),
    CONSTRAINT fk_disp_batch FOREIGN KEY (batch_id) REFERENCES stock_batches(batch_id),
    CONSTRAINT fk_disp_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE sales (
    sale_id         NUMBER PRIMARY KEY,
    prescription_id NUMBER NOT NULL UNIQUE,
    employee_id     NUMBER NOT NULL,
    total_amount    NUMBER(10,2) CHECK (total_amount >= 0),
    payment_date    DATE DEFAULT SYSDATE,
    payment_method  VARCHAR2(20) CHECK (payment_method IN ('Cash','Card','MobileMoney','Insurance')),
    CONSTRAINT fk_sale_prescription FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id),
    CONSTRAINT fk_sale_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE public_holidays (
    holiday_id      NUMBER PRIMARY KEY,
    holiday_date    DATE UNIQUE,
    holiday_name    VARCHAR2(100)
);

CREATE TABLE audit_log (
    audit_id        NUMBER PRIMARY KEY,
    table_name      VARCHAR2(50),
    operation       VARCHAR2(20),
    record_id       NUMBER,
    old_value       CLOB,
    new_value       CLOB,
    changed_by      VARCHAR2(100),
    change_date     DATE DEFAULT SYSDATE
);
