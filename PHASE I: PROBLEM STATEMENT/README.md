
# PROBLEM STATEMENT

---

## 1. Problem Definition

Community pharmacies that rely on manual logs or basic spreadsheets to manage stock and prescriptions face three recurring failures: they don't catch low-stock or near-expiry drugs early enough, risking stockouts or dispensing expired medication; they have no reliable way to verify a prescription against what's actually dispensed; and they lack an audit trail showing who changed what and when, which matters for both patient safety and regulatory accountability.

---

## 2. Context of Use

A single-branch retail pharmacy handling a realistic operational load — 30–50+ distinct drugs and dozens of patients. Prescriptions originate from doctors, are verified and dispensed by pharmacists, paid for at the counter by cashiers, and stock is monitored and replenished by an inventory manager. At this scale, manual tracking breaks down, which is the core justification for a relational database solution rather than a spreadsheet.

---

## 3. Target Users

- **Doctors** — originate prescriptions
- **Pharmacists** — verify prescriptions and dispense drugs
- **Cashiers** — process payment for dispensed prescriptions
- **Inventory managers** — monitor stock levels, batch expiry, and trigger reordering
- **Patients** — indirect beneficiaries; their prescription and dispensing history is stored in the system

---

## 4. Project Objectives

- Maintain a single source of truth for drug stock, tracked down to batch and expiry level
- Track the full prescription lifecycle: issued → verified → dispensed
- Automate low-stock and near-expiry alerts and reorder triggers
- Enforce an audit trail and access-control rules over all data-modifying operations
- Give dispensing staff a verification step that reduces wrong-drug/wrong-patient errors

---

## 5. Expected Benefits

- Fewer stockouts and lower risk of dispensing expired drugs
- Faster, traceable prescription processing end-to-end
- Accountability — every insert, update, and delete is attributable to a user and timestamp
- A clean, structured data foundation for the analytics/BI innovation component later
