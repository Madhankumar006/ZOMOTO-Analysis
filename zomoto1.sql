drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);




SELECT * FROM goldusers_signup;
SELECT * FROM sales ; 
SELECT * FROM users;
SELECT * FROM product;


--1) What is the total amount of each customer spent on zomoto ?


SELECT  s.userid,
		SUM(p.price) AS AMOUNTSPEND 
FROM sales s 
join product p on s.product_id = p.product_id
GROUP BY  s.userid


--2) HOw many days has each customer visited zomoto ?
SELECT s.userid,
	COUNT(*) as CUSTOMERVISIT 
FROM sales s
GROUP BY userid

--3) What was the first product of the each customer 

SELECT s.userid,s.product_id as firstproduct ,p.product_name
FROM sales s 
JOIN product p ON s.product_id = p.product_id
GROUP BY userid
ORDER BY created_date ASC 

--4)What is most purchased itam 
with MostPOP as (
SELECT s.product_id,COUNT(s.product_id) as mostpur,P.product_name
FROM sales s
JOIN product P ON s.product_id = P.product_id
GROUP BY s.product_id
)
SELECT product_id,MAX(mostpur),product_name
FROM MostPOP 



--5) WHICH PRODUCT IS MOST POPULAR for each customer 
WITH cte as (
	SELECT s.userid,s.product_id,COUNT(product_id) OVER(PARTITION BY userid ,product_id) as cnt_product  
	FROM sales s
),
cte1 as (
	SELECT *,row_number() OVER(PARTITION BY userid order by cnt_product DESC) as rn FROM
		cte )
select c.userid,c.product_id,c.cnt_product,p.product_name from cte1 c 
join product p on c.product_id = p.product_id
WHERE c.rn = 1
ORDER BY c.userid

--6) which item was purchased first by customer after they become a member ?
WITH cte as (
	SELECT u.userid,u.signup_date,s.product_id,s.created_date
	FROM sales s
	JOIN users u on s.userid=u.userid and s.created_date >= u.signup_date
)
SELECT * FROM (
SELECT *,row_number() OVER(PARTITION BY userid ORDER BY created_date) rn from cte
) AS T 
WHERE rn =1 


--7 which item was purchased just before the customer became a member?
WITH cte as (
	SELECT u.userid,u.signup_date,s.product_id,s.created_date
	FROM sales s
	JOIN users u on s.userid=u.userid and s.created_date <= u.signup_date
)
SELECT * FROM (
SELECT *,row_number() OVER(PARTITION BY userid ORDER BY created_date) rn from cte
) AS T 
WHERE rn =1 



















