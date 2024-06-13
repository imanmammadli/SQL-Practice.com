-- Q1: Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table

    --categories = CA
    --products = PR
    --suppliers = SP

SELECT PR.product_name, SP.company_name, CA.category_name
FROM products AS PR 
JOIN suppliers AS SP ON PR.supplier_id = SP.supplier_id
JOIN categories AS CA ON PR.category_id = CA.category_id;


-- Q2: Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table

    --categories = CA
    --products = PR
    
SELECT CA.category_name, round(avg(PR.unit_price), 2) AS average_unit_price
FROM products AS PR 
JOIN categories AS CA ON PR.category_id = CA.category_id
GROUP BY category_name;


-- Q3: Show the city, company_name, contact_name from the customers and suppliers table merged together. 
    --Create a column which contains 'customers' or 'suppliers' depending on the table it came from.

SELECT city, company_name, contact_name, 'customers' AS relationship  FROM customers
          UNION ALL
SELECT city, company_name, contact_name, 'suppliers' AS relationship FROM suppliers
