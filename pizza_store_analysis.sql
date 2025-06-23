-- 1. Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS Total_orders
FROM
    Orders
    
-- 2. Calculate the total revenue generated from pizza sales. 

SELECT 
    ROUND(SUM(price * quantity), 2) AS Total_revenue
FROM
    order_details AS o
        INNER JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
    
-- 3. Identify the highest-priced pizza.

SELECT 
    p.price, pt.name
FROM
    pizzas AS p
        INNER JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1

-- 4. Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(o.order_details_id) AS order_count
FROM
    pizzas AS p
        JOIN
    order_details AS o ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY order_count DESC

-- 5. List the top 5 most ordered pizza types along with their quantities

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantities
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantities DESC
LIMIT 5

-- 6. Join the necessary tables to find the total quantity of each pizza category ordered

SELECT 
    pt.category, SUM(od.quantity) AS total_quantity
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC

-- 7. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hours, COUNT(order_id)
FROM
    orders
GROUP BY hours

-- 8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantities_ordered), 0)
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantities_ordered
    FROM
        orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_quantity
    
-- 10.Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, SUM(o.quantity * p.price) AS Revenue
FROM
    pizza_types pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS o ON o.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Revenue DESC
LIMIT 3

-- 11.Calculate the percentage contribution of each pizza type to total revenue

SELECT 
    pt.category,
    ROUND((SUM(o.quantity * p.price) / (SELECT 
                    SUM(p2.price * o2.quantity)
                FROM
                    order_details AS o2
                        JOIN
                    pizzas AS p2 ON o2.pizza_id = p2.pizza_id)) * 100,
            2) AS revenue_percentage
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS o ON o.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue_percentage DESC;


