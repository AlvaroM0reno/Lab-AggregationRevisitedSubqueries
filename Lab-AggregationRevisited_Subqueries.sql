USE sakila;
-- 1. Seleccione el nombre, apellido y dirección de correo electrónico de todos los clientes que han alquilado una película.
SELECT DISTINCT 
    c.first_name, 
    c.last_name, 
    c.email
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id;
    
    -- 2. ¿Cuál es el pago promedio realizado por cada cliente?
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
    AVG(p.amount) AS average_payment
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id, customer_name;
    
    -- 3. Seleccione el nombre y la dirección de correo electrónico de todos los clientes que han alquilado las películas "Acción".
    -- 3.1 Escriba la consulta utilizando múltiples declaraciones de unión
SELECT DISTINCT 
    c.first_name, 
    c.last_name, 
    c.email
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film_category fc ON i.film_id = fc.film_id
JOIN 
    category cat ON fc.category_id = cat.category_id
WHERE 
    cat.name = 'Action';

-- 3.2 Escriba la consulta utilizando subconsultas con múltiples cláusulas y IN condiciones WHERE
SELECT DISTINCT 
    c.first_name, 
    c.last_name, 
    c.email
FROM 
    customer c
WHERE 
    c.customer_id IN (
        SELECT 
            r.customer_id
        FROM 
            rental r
        WHERE 
            r.inventory_id IN (
                SELECT 
                    i.inventory_id
                FROM 
                    inventory i
                WHERE 
                    i.film_id IN (
                        SELECT 
                            fc.film_id
                        FROM 
                            film_category fc
                        WHERE 
                            fc.category_id = (
                                SELECT 
                                    cat.category_id
                                FROM 
                                    category cat
                                WHERE 
                                    cat.name = 'Action'
                            )
                    )
            )
    )
;

-- 4. Utilice la declaración CASE para crear una nueva columna que clasifique las transacciones según el monto del pago.
SELECT 
    p.payment_id, 
    p.amount, 
    CASE 
        WHEN p.amount > 0 AND p.amount <= 2 THEN 'low'
        WHEN p.amount > 2 AND p.amount <= 4 THEN 'medium'
        WHEN p.amount > 4 THEN 'high'
        ELSE 'undefined'
    END AS payment_category
FROM 
    payment p
;
