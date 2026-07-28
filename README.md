# Pharmacy Inventory & Prescription Tracking System

## Course Information

| Item | Details |
|------|---------|
| **Course** | DPR400210 – Database Programming with Oracle Database |
| **Type** | Individual Capstone Final Examination |
| **Institution** | University of Lay Adventists of Kigali (UNILAK), Faculty of Computing and Information Sciences |
| **Academic Year** | 2025–2026 |
| **Student** | Shedrick Duanah (ID: 30866) |
| **Naming Convention** | `30866_Shedrick_Pharmacy_DB` |

---

## Project Description

An Oracle database solution for a single-branch pharmacy that manages drug stock, expiry tracking, prescriptions, dispensing, and supplier reordering — with full audit logging and security controls. The system models the end-to-end prescription chain: doctor → patient → pharmacist verification → dispensing → stock deduction → reorder trigger, with cashier payment processed alongside dispensing.

**Scope:** Single branch, realistic scale (30–50+ drugs, dozens of patients).

---

## Repository Structure

| Folder | Phase | Contents |
|--------|-------|----------|
| `01_problem_statement/` | I | Problem statement — context of use, objectives, target users, expected benefits (3-slide PowerPoint) |
| `02_business_process/` | II | BPMN swimlane diagram + one-page explanation of the process flow |
| `03_erd_design/` | III | ER diagram, entities/attributes/PK-FK, normalization to 3NF |
| `04_database_creation/` | IV | Database/user creation scripts, privilege grants, OEM screenshots |
| `05_tables/` | V | CREATE TABLE scripts (PK, FK, NOT NULL, UNIQUE, CHECK constraints) + sample data |
| `06_plsql/` | VI | Procedures, functions, packages, cursors, exception handling |
| `07_advanced_plsql/` | VII | Triggers, audit logging system, weekday/holiday DML-blocking business rule |
| `08_presentation/` | VIII | Final max-10-slide presentation |
