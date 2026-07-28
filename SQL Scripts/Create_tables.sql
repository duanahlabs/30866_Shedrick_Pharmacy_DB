SUPPLIERS
CREATE TABLE suppliers (
    supplier_id NUMBER PRIMARY KEY,
    supplier_name VARCHAR2(100) NOT NULL,
    contact_person VARCHAR2(100),
    phone VARCHAR2(20) UNIQUE,
    email VARCHAR2(100) UNIQUE,
    address VARCHAR2(200)
);

DRUGS
CREATE TABLE drugs (
    drug_id NUMBER PRIMARY KEY,
    drug_name VARCHAR2(100) NOT NULL UNIQUE,
    category VARCHAR2(50),
    unit_price NUMBER(10,2)
        CHECK (unit_price >= 0),
    reorder_level NUMBER
        CHECK (reorder_level >= 0),
    supplier_id NUMBER NOT NULL,

    CONSTRAINT fk_drug_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);

STOCK_BATCHES
CREATE TABLE stock_batches (

    batch_id NUMBER PRIMARY KEY,

    drug_id NUMBER NOT NULL,

    batch_number VARCHAR2(40) UNIQUE NOT NULL,

    quantity NUMBER
        CHECK(quantity >=0),

    manufacture_date DATE,

    expiry_date DATE,

    CONSTRAINT chk_expiry
        CHECK(expiry_date > manufacture_date),

    CONSTRAINT fk_batch_drug
        FOREIGN KEY(drug_id)
        REFERENCES drugs(drug_id)
);

PATIENTS
CREATE TABLE patients (

    patient_id NUMBER PRIMARY KEY,

    first_name VARCHAR2(50) NOT NULL,

    last_name VARCHAR2(50) NOT NULL,

    gender CHAR(1)
        CHECK(gender IN ('M','F')),

    date_of_birth DATE,

    phone VARCHAR2(20) UNIQUE
);

DOCTORS
CREATE TABLE doctors (

    doctor_id NUMBER PRIMARY KEY,

    first_name VARCHAR2(50) NOT NULL,

    last_name VARCHAR2(50) NOT NULL,

    specialization VARCHAR2(80),

    phone VARCHAR2(20) UNIQUE
);

EMPLOYEES
CREATE TABLE employees (

    employee_id NUMBER PRIMARY KEY,

    first_name VARCHAR2(50),

    last_name VARCHAR2(50),

    role VARCHAR2(40),

    hire_date DATE,

    phone VARCHAR2(20) UNIQUE
);

PRESCRIPTIONS
CREATE TABLE prescriptions (

    prescription_id NUMBER PRIMARY KEY,

    patient_id NUMBER NOT NULL,

    doctor_id NUMBER NOT NULL,

    prescription_date DATE DEFAULT SYSDATE,

    status VARCHAR2(20)
        CHECK(status IN
        ('Pending',
         'Dispensed',
         'Cancelled')),

    CONSTRAINT fk_pres_patient
        FOREIGN KEY(patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_pres_doctor
        FOREIGN KEY(doctor_id)
        REFERENCES doctors(doctor_id)
);

PRESCRIPTION_ITEMS
CREATE TABLE prescription_items (

    item_id NUMBER PRIMARY KEY,

    prescription_id NUMBER NOT NULL,

    drug_id NUMBER NOT NULL,

    quantity NUMBER
        CHECK(quantity>0),

    dosage VARCHAR2(100),

    CONSTRAINT fk_item_prescription
        FOREIGN KEY(prescription_id)
        REFERENCES prescriptions(prescription_id),

    CONSTRAINT fk_item_drug
        FOREIGN KEY(drug_id)
        REFERENCES drugs(drug_id)
);

DISPENSING
CREATE TABLE dispensing (

    dispensing_id NUMBER PRIMARY KEY,

    prescription_id NUMBER NOT NULL,

    employee_id NUMBER NOT NULL,

    dispensing_date DATE DEFAULT SYSDATE,

    total_amount NUMBER(10,2)
        CHECK(total_amount>=0),

    CONSTRAINT fk_disp_prescription
        FOREIGN KEY(prescription_id)
        REFERENCES prescriptions(prescription_id),

    CONSTRAINT fk_disp_employee
        FOREIGN KEY(employee_id)
        REFERENCES employees(employee_id)
);

PUBLIC_HOLIDAYS
CREATE TABLE public_holidays (

    holiday_id NUMBER PRIMARY KEY,

    holiday_date DATE UNIQUE,

    holiday_name VARCHAR2(100)
);

AUDIT_LOG
CREATE TABLE audit_log (

    audit_id NUMBER PRIMARY KEY,

    table_name VARCHAR2(50),

    operation VARCHAR2(20),

    record_id NUMBER,

    old_value CLOB,

    new_value CLOB,

    changed_by VARCHAR2(100),

    change_date DATE DEFAULT SYSDATE
);
