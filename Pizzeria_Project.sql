-- total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS TotalRevenue
FROM
    orders_details o
        INNER JOIN
    pizzas p ON o.pizza_id = p.pizza_id;

-- total number of orders placed.
SELECT 
    COUNT(*)
FROM
    orders;

--  the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizzas p
        INNER JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- the most common pizza size ordered.
SELECT 
    p.size, COUNT(o.order_id) AS orderCount
FROM
    pizzas p
        JOIN
    orders_details o ON o.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY orderCount DESC
LIMIT 1;


-- top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(o.quantity) AS TotalQuantity
FROM
    pizzas p
        JOIN
    orders_details o ON p.pizza_id = o.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY TotalQuantity DESC
LIMIT 5;

-- total quantity of each pizza category ordered.
SELECT 
    SUM(o.quantity) AS toatalQuantity, pt.category
FROM
    pizzas p
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    orders_details o ON o.pizza_id = p.pizza_id
GROUP BY pt.category; 

-- Determine the distribution of orders by hour of the day.
SELECT 
    COUNT(Order_id) AS Ordercount, HOUR(order_time) AS Hour
FROM
    orders
GROUP BY Hour
ORDER BY Ordercount ASC;

-- category-wise distribution of pizzas.
SELECT 
    COUNT(od.order_details_id) AS TotalCount, pt.category
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    orders_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY TotalCount DESC;

-- Grouping the orders by date and calculating the average number
-- of pizzas ordered per day.
SELECT 
    ROUND(AVG(TotalQuantity), 0) AS AvgPizzaOrdered
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS TotalQuantity
    FROM
        orders o
    JOIN orders_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_details;

-- Top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name AS PizzaType, SUM(od.quantity * p.price) AS Revenue
FROM
    orders_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY PizzaType
ORDER BY Revenue DESC
LIMIT 3;

-- Percentage contribution of each pizza type to total revenue.
SELECT 
    pt.category,
    ROUND((SUM(od.quantity * p.price)) / (SELECT 
                    SUM(od.quantity * p.price) AS Total_sales
                FROM
                    orders_details od
                        JOIN
                    pizzas p ON od.pizza_id = p.pizza_id
                        JOIN
                    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id) * 100,
            2) AS PercentContribution
FROM
    orders_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY PercentContribution DESC;

-- Analyzing the cumulative revenue generated over time.
Select Orderdate,round(sum(Revenue) over(order by Orderdate),2) as Cumelative_Revenue from
(Select o.order_date as Orderdate,round(sum(od.quantity*p.price),2) as Revenue from orders o
join orders_details od on o.order_id= od.Order_id
join pizzas p on p.pizza_id=od.pizza_id
group by Orderdate) as RevenueDetails;

-- top 3 most ordered pizza types based on revenue for each pizza category.
Select category,name,Revenue
from
(select category,name,Revenue, rank() over(partition by category order by Revenue desc)
as PizzaRank
from
(Select pt.category ,pt.name,round(sum(od.quantity*p.price),2) as Revenue 
from pizza_types pt join pizzas p on p.pizza_type_id=pt.pizza_type_id
join orders_details od on
od.pizza_id= p.pizza_id
group by pt.category,pt.name order by Revenue desc) as A) as B
where PizzaRank<=3







