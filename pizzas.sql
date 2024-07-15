-- Retrieve the total number of orders placed 
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;


-- Calculate the total revenue generated from pizza sales
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
   
   
   -- Identify the highest-priced pizza.
SELECT 
    SUM(price) AS price_pizza, pizza_id
FROM
    pizzas
GROUP BY pizza_id
ORDER BY price_pizza DESC
LIMIT 1;
   
SELECT 
    pizza_type_id, price
FROM
    pizzas_types
ORDER BY price DESC
LIMIT 1;
   
   -- Identify the most common pizza size ordered.
SELECT 
    pizzas.size, COUNT(order_details.order_details_id) AS number
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY number DESC
LIMIT 1;
 
 -- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    SUM(order_details.quantity) AS pizza_count,
    pizzas.pizza_type_id AS name
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY pizza_count DESC
LIMIT 5
;
 
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    SUM(order_details.quantity) AS total_quantity,
    pizzas.pizza_type_id
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY total_quantity DESC;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY COUNT(order_id) DESC
;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quan), 0)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quan
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    order_details.pizza_id,
    SUM(order_details.quantity * pizzas_types.price) AS revenue
FROM
    order_details
        JOIN
    pizzas_types ON order_details.pizza_id = pizzas_types.pizza_id
GROUP BY order_details.pizza_id
ORDER BY revenue DESC
LIMIT 3;
-- or
SELECT 
    pizzas.pizza_type_id AS pizza,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza
ORDER BY revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
 
SELECT 
    pizzas.pizza_type_id AS pizza,
    (SUM(order_details.quantity * pizzas.price) / (SELECT 
            SUM(order_details.quantity * pizzas.price)
        FROM
            order_details
                JOIN
            pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100 AS revenue_contri
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza
ORDER BY revenue_contri DESC;

-- Analyze the cumulative revenue generated over time
select orders.order_date, 
sum(revenue) over(order by order_date) as cumm_revenue
from
(select orders.order_date , 
 SUM(order_details.quantity * pizzas.price) AS revenue
 from orders join order_details on orders.order_id = order_details.order_id
 join pizzas on order_details.pizza_id = pizzas.pizza_id
group by  orders.order_date)
;


