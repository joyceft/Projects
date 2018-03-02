CREATE TABLE user(
user_id int,
gender varchar(100),
age int,
PRIMARY KEY (user_id));
INSERT INTO user
SELECT * FROM user_raw;

CREATE TABLE orders(
order_id int,
user_id int,
order_dow int,
order_number int,
order_hour int,
days_since_prior_order int,
PRIMARY KEY (order_id));
#
INSERT INTO orders
SELECT * FROM order_raw;

CREATE TABLE product(
product_id int,
product_name varchar(100),
aisle_id int,
department_id int,
PRIMARY KEY (product_id));
#
INSERT INTO product
SELECT * FROM products_raw;

CREATE TABLE aisle(
aisle_id int,
aisle_name varchar(100),
PRIMARY KEY (aisle_id));
#
INSERT INTO aisle
SELECT * FROM aisles_raw;

CREATE TABLE department(
department_id int,
department_name varchar(100));
#
INSERT INTO department
SELECT * FROM departments_raw;

CREATE TABLE order_product(
order_id int,
product_id int,
add_to_cart_order int,
reordered int,
PRIMARY KEY (order_id, product_id));
INSERT INTO order_product
SELECT * FROM order_product_raw;


######################******#######################
###find top 3 popular departments with largest ordered product
SELECT op.product_id, p.product_name, p.department_id, d.department_name, COUNT(op.product_id) AS totalnumberindept
FROM department AS d
INNER JOIN product AS p
ON d.department_id = p.department_id
INNER JOIN order_product AS op
ON p.product_id = op.product_id
GROUP BY d.department_id
ORDER BY totalnumberindept DESC;
LIMIT 3;

###find top 3 the amount of reordered product for each department, 
SELECT d.department_name, p.product_id, p.product_name, COUNT(op.product_id) AS amount FROM product AS p
INNER JOIN department AS d
ON d.department_id = p.department_id
INNER JOIN order_product AS op
ON op.product_id = p.product_id
WHERE op.reordered <> 0
GROUP BY d.department_id
ORDER BY amount DESC;
####****#####

###2.Find the amount of order in afternoon for both male and female
SELECT u.gender, COUNT(o.order_id) AS amount, o.order_hour FROM orders AS o
right JOIN user AS u
ON u.user_id = o.user_id
WHERE o.order_hour >12 AND o.order_hour < 18 
GROUP BY o.order_hour, u.gender
ORDER BY COUNT(*) DESC;
######*****####


###find top 3 reordered product within last 10 days for average age larger than total age
SELECT AVG(u.age) AS aveage FROM user AS u
INNER JOIN orders AS o 
ON o.user_id = u.user_id
WHERE o.days_since_prior_order <= 10 AND ;

###3.find the most popular product add to cart and be reordered
SELECT * FROM order_product AS op
WHERE op.reordered <> 0
GROUP BY op.add_to_cart_order
;
###############***######
###4.popular day and hour for middle age customer
SELECT y.order_dow, y.order_hour FROM orders AS y
INNER JOIN orders AS t
ON y.order_id = t.order_id
GROUP BY t,order_id
WHERE t.order_hour
###########shenshen
SELECT op.product_ID, d.department_ID,d.department_name,COUNT(op.product_ID) AS frequency FROM order_product op
INNER JOIN product p
ON op.product_ID=p.product_ID
INNER JOIN department d
ON p.deptartment_ID=d.department_ID
GROUP BY op.product_ID
ORDER BY frequency DESC;

















