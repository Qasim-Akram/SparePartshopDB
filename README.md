# localsparepartsdb

A database project for managing a spare parts shop (**Abdullah Autos**).  
It includes workers, clients, suppliers, orders, payments, and inventory management.

## Features
- Manage clients, workers, suppliers
- Track orders and order details
- Handle client, supplier, and worker payments
- Manage inventory (stock in/out)
- Monitor paid, unpaid, and partially paid transactions

## Files
- `schema.sql` → Database structure (CREATE TABLEs with PK/FK)
- `data.sql` → Sample dataset for testing
- `queries.sql` → Example SQL queries for reports
- `erd.png` → ER Diagram of the database

## Technologies
- MySQL (can adapt for MariaDB, PostgreSQL)
- SQL standard schema design

## How to Use
```bash
# Create DB
mysql -u root -p < schema.sql

# Insert sample data
mysql -u root -p < data.sql

# Run example queries
mysql -u root -p < queries.sql
```
EER diagram:
<img width="1152" height="594" alt="erd" src="https://github.com/user-attachments/assets/d6912866-6615-41aa-b5fb-c3f4ad23448e" />


## Author
Muhammad Qasim Akram
