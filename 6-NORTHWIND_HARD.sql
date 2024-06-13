-- Q1: Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, 
    --and a column called "Shipped" that displays "On Time" if the order shipped on time and "Late" if the order shipped late.
    --Order by employee last_name, then by first_name, and then descending by number of orders.

    --employees = EP
    --orders = OD

SELECT EP.first_name, EP.last_name, count(OD.order_id) AS num_orders, 
  CASE 
      WHEN OD.required_date > OD.shipped_date THEN 'On Time'
      ELSE 'Late'
  END AS shipped
FROM employees AS EP 
JOIN orders AS OD ON EP.employee_id = OD.employee_id
GROUP BY EP.first_name, EP.last_name, shipped
ORDER BY EP.last_name, EP.first_name, num_orders DESC;
