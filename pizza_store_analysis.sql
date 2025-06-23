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


