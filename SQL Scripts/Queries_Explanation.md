# Queries Explanation

## Pharmacy Management Database System

This document explains the purpose of the SQL queries used in the Pharmacy Management Database System.

---

## Query 1: Display All Drugs

### SQL Query

```sql
SELECT * FROM DRUGS;
```

### Explanation

Retrieves all records stored in the **DRUGS** table. It allows users to view the complete list of medicines available in the pharmacy, including their details.

---

## Query 2: Check Available Stock

### SQL Query

```sql
SELECT batch_id, quantity_received, quantity_available
FROM STOCK_BATCHES;
```

### Explanation

Displays the quantity received and the quantity currently available for each stock batch. This query helps monitor inventory levels and supports effective stock management.

---

## Query 3: Find Expired Drugs

### SQL Query

```sql
SELECT *
FROM STOCK_BATCHES
WHERE EXPIRY_DATE < SYSDATE;
```

### Explanation

Identifies all drug batches that have expired. This helps pharmacy staff remove expired medicines from inventory and ensures patient safety.

---

## Query 4: Count Total Drugs

### SQL Query

```sql
SELECT COUNT(*) AS TOTAL_DRUGS
FROM DRUGS;
```

### Explanation

Counts the total number of medicines registered in the pharmacy database. This provides a quick summary of the available inventory.

---

## Query 5: Stock by Supplier

### SQL Query

```sql
SELECT s.supplier_name, COUNT(d.drug_id)
FROM suppliers s
JOIN drugs d
ON s.supplier_id = d.supplier_id
GROUP BY s.supplier_name;
```

### Explanation

Displays the number of medicines supplied by each supplier. This query helps evaluate supplier contributions and supports inventory planning.

---

## Query 6: Low Stock Alert

### SQL Query

```sql
SELECT *
FROM STOCK_BATCHES
WHERE QUANTITY_AVAILABLE < 20;
```

### Explanation

Identifies medicines with low stock levels that may require immediate restocking to prevent shortages.

---

# Conclusion

The SQL queries implemented in this project support the daily operations of the Pharmacy Management Database System. They help users retrieve important information about medicines, inventory, suppliers, and stock levels, enabling better decision-making and efficient pharmacy management.
