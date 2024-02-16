CREATE SCHEMA pizza_runner;
 use pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE new_pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
 (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  drop table if exists pizza_recipes;
create table new_pizza_rec 
(
 pizza_id int,
    toppings int);
insert into new_pizza_rec
(pizza_id, toppings) 
values
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(1,8),
(1,10),
(2,4),
(2,6),
(2,7),
(2,9),
(2,11),
(2,12);
  
  select * from customer_orders
  select * from pizza_toppings
  select * from pizza_recipes
  select * from runner_orders
  select * from pizza_names
  select * from runners
  
  #Data Cleaning 
#The missing,null values and concated values in the tables
#customer_orders , runner_orders and pizza_recipes were handled
#through the below steps

update  customer_orders
set exclusions = null
where exclusions = '' or exclusions = null

update  customer_orders
set extras = null
where  extras = '' or extras = null

select * from customer_orders

update runner_orders
set pickup_time = Null
where pickup_time = '' or pickup_time = null

update runner_orders
set distance = Null
where distance = '' or distance = null

update runner_orders
set distance = Null
where distance = '' or distance = null

update runner_orders
set cancellation = Null
where cancellation = '' or cancellation = null

#remove strings at end of distance

update runner_orders
set distance = regexp_replace(distance,'[^0-9.]',' ')
where distance is not null and distance regexp'[^0-9]';

#remove strings at end of duration
update runner_orders
set duration = regexp_replace(duration,'[^0-9.]',' ')
where duration is not null and duration regexp'[^0-9]';

select * from runner_orders

#A. Pizza Metrics

#1.How many pizzas were ordered?

select count(*) as total_pizza_ordered
from customer_orders

#total_pizza_ordered is 14

# 2.How many unique customer orders were made? runner_orders

select distinct (customer_id) as total_customers
from customer_orders

#There were total 5 unique customer are there 

#3. How many successful orders were delivered by each runner?
select runner_id ,count(*)as total_orders_deleiverd
from runner_orders
where cancellation is null
group by 1
order by total_orders_deleiverd desc

#4. How many of each type of pizza was deliver
select pizza_name ,count(*) as 'pizza deliverd' from customer_orders
left join runner_orders using (order_id)
left join pizza_names using (pizza_id)
group by pizza_name
order by 'pizza deliverd'

#so there were 10 non_veg pizza and 4 veg pizza were delierved

#5.How many Vegetarian and Meatlovers were ordered by each customer?

select  customer_id , pizza_name ,count(pizza_name) as 'pizza deliverd' from customer_orders
left join pizza_names using (pizza_id)
group by customer_id, pizza_name
order by 'pizza deliverd'

#6.What was the maximum number of pizzas delivered in a single order?
with pizza_delivery as
(select order_id as 'Order_id', count(*) as 'pizzas_deliverd' from customer_orders
left join runner_orders using(order_id)
where cancellation is null 
group by order_id )
select Order_id ,pizzas_deliverd
from pizza_delivery
where pizzas_deliverd = (selecT max(pizzas_deliverd) from pizza_delivery)

#There were total 3 pizzas were deliverd in a single order

#8.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select customer_id ,
sum(case when (exclusions is not null or extras is not null)then 1 else 0 end) as 'atleast one change',
sum(case when (exclusions is  null and  extras is  null)then 1 else 0 end) as 'no change'
from customer_orders
where order_id  in (select order_id  from runner_orders where cancellation is null)
group by customer_id  

#How many pizzas were delivered that had both exclusions and extras?

select count(*) as pizzas_deliverd
from customer_orders
where exclusions is not null and extras is not null and
order_id in (select order_id from runner_orders where cancellation is  null)

#there were only 1 pizza

#9.What was the total volume of pizzas ordered for each hour of the day?

select hour(order_time) as 'hour_of _the_day' , count(*) as pizzas_deliverd
from customer_orders
group by 1
order by 1 desc

#10. What was the volume of orders for each day of the week?

select dayname(order_time) as 'days_of _the_week' , count(order_id) as pizzas_deliverd
from customer_orders
group by 1,'days_of _the_week'
order by 'days_of _the_week' 


                   #Runner and Customer Experience
      
#1.How many runners signed up for each 1 week period?(i.e. week starts 2021-01-01)

select week(registration_date,1)+1 as 'week_number',count(*) as 'runners_signed'
from runners
group by 1

#What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order
select ro.runner_id , round(avg(timestampdiff(minute, co.order_time , ro.pickup_time))) as 'average_time'
from runner_orders ro
join  (select distinct order_id , order_time from customer_orders) co using (order_id)
where ro.pickup_time is not null and ro.cancellation is null
group by ro.runner_id;

#2.Is there any relationship between the number of pizzas and how long the order takes to prepare?

with preapartion_time as(
select count(*) over(partition by order_id) as pizza_count,
timestampdiff(minute,order_time,pickup_time) as time_required from runner_orders
inner join customer_orders using(order_id)
where cancellation is null)
select pizza_count , round(avg(time_required)) as 'average_time'
from preapartion_time
group by 1;

#3.What was the average distance travelled for each customer?

select customer_id ,avg(distance) as avg_distance
from runner_orders ro
inner join (select distinct order_id,customer_id from customer_orders) co
using (order_id)
where ro.cancellation is null 
group by 1


#4.What was the difference between the longest and shortest delivery times for all orders?

;select max(duration) as 'longest_duration( mins)',
min( duration) as 'shortest_duration( mins)',
(max(duration) - min(duration)) as 'differance(mins)'
from runner_orders;

#6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

select runner_id,round((duration/60),2) as dur_hr,round((distance*60/duration),2) as avg_speed
 from runner_orders  where cancellation is NULL group by runner_id,dur_hr,avg_speed;
 
#7.What is the successful delivery percentage for each runner?

with success_del as (
select runner_id , sum(case when distance is not null then 1 else 0 end) as success,
count(order_id) as total_ord
from runner_orders
group by runner_id)
select runner_id ,round((success / total_ord)*100) as 'successful_in_%'
from success_del
order by runner_id

                #Ingredient Optimisation

#1. What are the standard ingredients for each pizza?

with cte as (
select a.pizza_name,b.pizza_id, c.topping_name
from new_pizza_rec b
inner join pizza_runner.pizza_toppings c
on b.toppings = c.topping_id
inner join pizza_runner.pizza_names a
on a.pizza_id = b.pizza_id
order by a.pizza_name, b.pizza_id)
select pizza_name, group_concat(topping_name) as StandardToppings
from cte
group by pizza_name;

#2.What was the most commonly added extra?

select topping_id as most_common from pizza_toppings
where topping_id = (select extras from
(select extras ,count(*)as 'occurance' from customer_orders
where extras is not null
group by 1
order by 2 desc
limit  1) as temp);

#The commonly added extra was 'BACON';

#3.What was the most common exclusion?

select topping_id as most_common from pizza_toppings
where topping_id = (select exclusions from
(select  exclusions ,count(*)as 'occurance' from customer_orders
where exclusions  is not null
group by 1
order by 2 desc
limit  1) as temp);

# The most common exclusions was 'CHEESE'

#4.Generate an order item for each record in the customers_orders table in the format of one of the following?

select a.order_id, a.pizza_id, b.pizza_name, a.exclusions, a.extras, 
case
when a.pizza_id = 1 and (exclusions is null) and (extras is null) then 'Meat Lovers'
when a.pizza_id = 2 and (exclusions is null) and (extras is null) then 'Veg Lovers'
when a.pizza_id = 2 and (exclusions =4 ) and (extras is null) then 'Veg Lovers - Exclude Cheese'
when a.pizza_id = 1 and (exclusions =4 ) and (extras is null) then 'Meat Lovers - Exclude Cheese'
when a.pizza_id=1 and (exclusions like '%3%' or exclusions =3) and (extras is null) then 'Meat Lovers - Exclude Beef'
when a.pizza_id =1 and (exclusions is null) and (extras like '%1%' or extras =1) then 'Meat Lovers - Extra Bacon'
when a.pizza_id=1 and (exclusions like '1, 4' ) and (extras like '6, 9') then 'Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers'
when a.pizza_id=1 and (exclusions like '2, 6' ) and (extras like '1, 4') then 'Meat Lovers - Exclude BBQ Sauce,Mushroom - Extra Bacon, Cheese'
when a.pizza_id=1 and (exclusions =4) and (extras like '1, 5') then 'Meat Lovers - Exclude Cheese - Extra Bacon, Chicken'
end as OrderItem
from customer_orders a
inner join pizza_runner.pizza_names b
on b.pizza_id = a.pizza_id;


								#Pricing and Ratings
                                
#1. If a Meat Lovers pizza costs $12 and Vegetarian costs
#$10 and there were no charges for changes - how much
#money has Pizza Runner made so far if there are no
#delivery fees?

select concat('$',sum(case when pizza_id = 1 then 12 else 10 end )) as total_earnings
from customer_orders 
left join runner_orders  using (order_id)
where cancellation is not null 

#the total earning was $68

#2.What if there was an additional $1 charge for any pizza extras?

select concat('$',sum(case when pizza_id = 1 and extras is null then 12
when pizza_id = 1 and extras is not null then 13
when pizza_id = 2 and  extras is null then 10
when pizza_id = 2   and extras is not  null then 11
end)) as total_earning
from customer_orders
join runner_orders  using (order_id)
where cancellation is not null 

#the total earning was $93

#3.The Pizza Runner team now wants to add an additional ratings
#system that allows customers to rate their runner, how would you
#design an additional table for this new dataset - generate a schema for
#this new table and insert your own data for ratings for each successful
#customer order between 1 to 5 

DROP TABLE IF EXISTS runner_rating;

CREATE TABLE runner_rating (order_id INTEGER, rating INTEGER, review VARCHAR(100)) ;

-- Order 6 and 9 were cancelled
INSERT INTO runner_rating
VALUES ('1', '1', 'Really bad service'),
       ('2', '1', NULL),
       ('3', '4', 'Took too long...'),
       ('4', '1','Runner was lost, delivered it AFTER an hour. Pizza arrived cold' ),
       ('5', '2', 'Good service'),
       ('7', '5', 'It was great, good service and fast'),
       ('8', '2', 'He tossed it on the doorstep, poor service'),
       ('10', '5', 'Delicious!, he delivered it sooner than expected too!');


SELECT *
FROM runner_rating;

#4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
#customer_id,order_id,runner_id,rating,order_time,pickup_time,Time between order and pickup,Delivery duration,Average speed,Total number of pizzas?

select customer_id,
       order_id,
       runner_id,
       rating,
       order_time,
       pickup_time,
       TIMESTAMPDIFF(MINUTE, order_time, pickup_time) pick_up_time,
       duration AS delivery_duration,
       round(distance*60/duration, 2) AS average_speed,
       count(pizza_id) AS total_pizza_count
from customer_orders join runner_orders using(order_id) join runner_rating using (order_id)
group by 1,2,3,4,5,6,7,8,9
order by order_id

#5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
;with pizza_sum as (
select order_id ,sum(case when pizza_id = 1 then 12 else 10 end ) as total_earnings
from customer_orders 
left join runner_orders  using (order_id)
where cancellation is null 
group by order_id),
runner_sum as (
select order_id ,sum(distance)*0.30 as 'runner_charge'
from runner_orders
where cancellation is null
group by 1
)
select concat('$',sum( pizza_sum.total_earnings)) as 'pizza earning',
concat('$',sum(runner_sum.runner_charge)) as 'runner costs',
concat('$' ,sum(pizza_sum.total_earnings)-sum(runner_sum.runner_charge)) as 'amount left'
from  pizza_sum
join runner_sum using (order_id);



