-- total number of orders placed 

select count(order_id) as total_orders
from orders;


-- total revenue genrated by pizza sales

select round(sum(order_detail.quantity * pizzas.price), 2) as total_revenue
from order_detail join pizzas
on pizzas.pizza_id = order_detail.pizza_id;


-- highest priced pizza

select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc limit 1;


-- most common pizza size ordered

select size, count(order_detils_id) as order_count
from pizzas join order_detail
on pizzas.pizza_id = order_detail.pizza_id
group by pizzas.size 
order by order_count desc;


--  most ordered pizza category along with their quntities

select category, sum(quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_detail
on pizzas.pizza_id = order_detail.pizza_id
group by category
order by total_quantity desc;


-- 5 most ordered pizza types along with their quntities

select pizza_types.name, sum(quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_detail
on pizzas.pizza_id = order_detail.pizza_id
group by pizza_types.name
order by total_quantity desc limit 5;


-- distribution of orders by the hour of the day

select hour(order_time) as hour, count(order_id) as order_count
from orders 
group by hour(order_time); 


-- category wise distribution of pizzas

select category, count(name) from pizza_types
group by category;


-- grouped orders by date and calculated the average number of pizzas ordered per day

select round(avg(quantity),0) as avg_pizza_ordered_per_day
from
(select order_date, sum(order_detail.quantity) as quantity
from orders join order_detail
on orders.order_id = order_detail.order_id
group by orders.order_date) as order_quantity;


-- top 3 ordered pizza types based on revenue

select pizza_types.name, sum(quantity * price) as total_revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_detail
on pizzas.pizza_id = order_detail.pizza_id
group by pizza_types.name
order by total_revenue desc limit 3;


-- percentage contribution of each pizza type to total revenue

select category, round(sum(quantity * price) / (select round(sum(order_detail.quantity * pizzas.price), 2) as total_revenue
from order_detail join pizzas
on pizzas.pizza_id = order_detail.pizza_id)*100,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_detail
on pizzas.pizza_id = order_detail.pizza_id
group by category
order by revenue desc;


-- cumulative revenue genrated over time

select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date,
sum(order_detail.quantity * pizzas.price) as revenue
from order_detail join pizzas
on order_detail.pizza_id = pizzas.pizza_id
join orders 
on orders.order_id = order_deltail.order_id
group by orders.order_date) as sales;