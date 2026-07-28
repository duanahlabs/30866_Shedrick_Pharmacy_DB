# Phase III — Entity Relationship Diagram

`30866_Shedrick_Pharmacy_DB` — Pharmacy Inventory & Prescription Tracking System

This diagram matches the corrected schema in `05_tables/05_tables_corrected.sql`
exactly (12 entities, including SALES and the batch-level DISPENSING link).
GitHub renders the Mermaid block below automatically when you view this file
in the repo — no image export needed.

```mermaid
erDiagram
    SUPPLIERS ||--o{ STOCK_BATCHES : supplies
    DRUGS ||--o{ STOCK_BATCHES : "has batches of"
    DRUGS ||--o{ PRESCRIPTION_ITEMS : "prescribed as"
    PATIENTS ||--o{ PRESCRIPTIONS : has
    DOCTORS ||--o{ PRESCRIPTIONS : issues
    PRESCRIPTIONS ||--o{ PRESCRIPTION_ITEMS : contains
    PRESCRIPTION_ITEMS ||--o{ DISPENSING : "dispensed via"
    STOCK_BATCHES ||--o{ DISPENSING : "deducted from"
    EMPLOYEES ||--o{ DISPENSING : performs
    EMPLOYEES ||--o{ SALES : processes
    PRESCRIPTIONS ||--|| SALES : "paid by"

    SUPPLIERS {
        number supplier_id PK
        string supplier_name
        string contact_person
        string phone
        string email
        string address
    }

    DRUGS {
        number drug_id PK
        string drug_name
        string generic_name
        string dosage_form
        string strength
        string category
        number unit_price
        number reorder_level
    }

    STOCK_BATCHES {
        number batch_id PK
        number drug_id FK
        number supplier_id FK
        string batch_number
        number quantity_received
        number quantity_available
        date manufacture_date
        date expiry_date
        date date_received
    }

    PATIENTS {
        number patient_id PK
        string first_name
        string last_name
        string gender
        date date_of_birth
        string phone
    }

    DOCTORS {
        number doctor_id PK
        string first_name
        string last_name
        string specialization
        string phone
    }

    EMPLOYEES {
        number employee_id PK
        string first_name
        string last_name
        string role
        string username
        date hire_date
        string phone
    }

    PRESCRIPTIONS {
        number prescription_id PK
        number patient_id FK
        number doctor_id FK
        date prescription_date
        string status
    }

    PRESCRIPTION_ITEMS {
        number prescription_item_id PK
        number prescription_id FK
        number drug_id FK
        number quantity_prescribed
        string dosage_instructions
    }

    DISPENSING {
        number dispensing_id PK
        number prescription_item_id FK
        number batch_id FK
        number employee_id FK
        number quantity_dispensed
        date dispensing_date
    }

    SALES {
        number sale_id PK
        number prescription_id FK
        number employee_id FK
        number total_amount
        date payment_date
        string payment_method
    }

    PUBLIC_HOLIDAYS {
        number holiday_id PK
        date holiday_date
        string holiday_name
    }

    AUDIT_LOG {
        number audit_id PK
        string table_name
        string operation
        number record_id
        string old_value
        string new_value
        string changed_by
        date change_date
    }
```

## Notes on relationships

- **SUPPLIERS 1:M STOCK_BATCHES** — a supplier delivers many batches; a
  batch comes from exactly one supplier.
- **DRUGS 1:M STOCK_BATCHES** — a drug can have many batches on shelf
  at once (different expiry dates), which is exactly why expiry and
  reorder tracking has to live at the batch level, not the drug level.
- **PRESCRIPTIONS 1:M PRESCRIPTION_ITEMS** — resolves the many-to-many
  between prescriptions and drugs (one prescription can list several
  drugs).
- **PRESCRIPTION_ITEMS 1:M DISPENSING** and **STOCK_BATCHES 1:M DISPENSING**
  — together these are what make dispensing traceable down to *which
  batch* a given item was filled from, which is the core value
  proposition from the Problem Statement.
- **PRESCRIPTIONS 1:1 SALES** — each prescription is paid for exactly
  once; enforced in the DDL with `UNIQUE` on `sales.prescription_id`.
- **AUDIT_LOG** has no FK to any other table on purpose — it has to
  keep logging even if the record it refers to gets deleted, so it's
  intentionally decoupled (this is standard practice for audit tables,
  worth a one-line mention in your write-up so it doesn't look like an
  oversight).
