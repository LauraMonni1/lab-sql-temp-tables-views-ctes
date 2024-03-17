USE sakila;

-- Step 1: Create a View of rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW customer_rental_summary AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, c.email, COUNT(r.rental_id) AS rental_count
FROM sakila.customer AS c
JOIN sakila.rental AS r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- Step 2: create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE payment_summary AS
SELECT crs.customer_id, SUM(p.amount) AS total_paid
FROM sakila.payment AS p
JOIN customer_rental_summary AS crs 
ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

-- Step3: Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

CREATE TEMPORARY TABLE customer_summary AS
SELECT crs.full_name, crs.email, crs.rental_count, ps.total_paid
FROM customer_rental_summary AS crs
JOIN payment_summary AS ps
ON crs.customer_id = ps.customer_id;

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

SELECT *, total_paid/rental_count AS average_payment_per_rental FROM customer_summary;



