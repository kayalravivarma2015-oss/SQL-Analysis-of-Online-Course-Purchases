Create database if not exists E_learning_pur_db; -- create new database for e learning purchasing data's
use E_learning_pur_db;

-- crete lerners table and its attribute
create table if not exists tbl_lerners(
 lerner_id  int primary key auto_increment,
full_name varchar(100),
country varchar(200)
);


-- cretate course table and its attributes
create table if not exists tbl_Course(
 course_id int primary key  ,
 course_name varchar(100),
 category varchar(100),
 unit_price decimal(10,2)
);

-- create purchase table
create table if not exists tbl_Purchase(
purchase_id int primary key auto_increment,
course_id int,
lerner_id int,
quantity int,
purchase_date date,
Constraint fk_course_id foreign key (course_id) references tbl_Course(course_id),
Constraint fk_lerners_id foreign key (lerner_id) references tbl_Lerners(lerner_id)
   );

 -- inserting values to lerners tables
   insert into tbl_lerners(full_name,country) values
   ("Amul","India"),
   ("Chales", "Russia"),
   ("Carlin","London"),
   ("Merlin","US"),
   ("Charles","German"),
   ("Zara","Singapore"),
   ("Liya","London"),
   ("Lidiya","Cannada"),
   ("Xing","China"),
  ("Mallinga","Srilanaka");
  
  -- Select * from tbl_lerners;
  
  -- inserting values to Curse
  insert into tbl_course(course_id,course_name,category,unit_price) values
  ("101","CCNA","Networking","1409.56"),
  ("102","SAP","Software Programing","1200.00"),
  ("103","Cload Computing","Networking","2599.56"),
  ("104","Robotics","Inteligence","1200.00"),
  ("105","Animation","Software Programming","2450.00"),
  ("106","AWS","Networking","1409.56"),
  ("107","Python","Software Programming","2500.00"),
  ("108","Big data","Database","2000.00"),
  ("109","Oracle","Database","2200.00"),
  ("110","Java","Software Programing","1850.65"),
  ("111","Dot-net","Software Programing","1560.65"),
  ("112","Testing","Testing-Anaysis","1250.25"),
  ("113","Digital Marketing","Marketing","1670.85"),
  ("114","Data Analysis","Marketing","1770.35"),
  ("115","CADD","Designing","1350.75");
 
 -- select * from  tbl_course;
  
-- inserting values to purchae table
insert into tbl_purchase (course_id,lerner_id,quantity,purchase_date ) values 
(101,1,2,"2022-03-12"),
(103,2,5,"2022-01-20"),
(105,3,3,"2022-05-25"),
(106,5,4,"2022-06-12"),
(107,6,2,"2022-07-09"),
 (108,9,5,"2022-09-22"),
 (109,8,7,"2022-11-19"),
 (102,4,3,"2022-07-05"),
 (110,7,2,"2022-04-24"),
 (109,3,5,"2022-10-25"),
 (102,1,7,"2022-08-18"),
 (114,4,13,"2022-05-05"),
(107,2,3,"2022-07-09"),
(108,9,5,"2022-09-22"),
(106,7,7,"2022-11-19"),
(112,4,3,"2022-07-05"),
(115,2,10,"2022-07-09"),
(104,5,1,"2022-3-22"),
(111,4,2,"2022-02-02"),
(113,10,3,"2022-05-07");

-- ●	Format currency values trfvo 2 decimal places
select unit_price, format(unit_price ,'c', 'en-us') as Currency from tbl_course; -- ●	Format currency values to 2 decimal places

-- ●	Use aliases for column names (e.g., AS total_revenue).
select * from tbl_purchase;
-- Inner join for all 3 tables
Select L.full_name as "Learner Name",C.course_name "Course Name",C.category,P.quantity,C.unit_price ,(C.unit_price* P.quantity) AS total_amount,P.purchase_date
from tbl_Course C
join tbl_purchase P on P.course_id=C.course_id
join tbl_lerners L on L.lerner_id=P.lerner_id
order by P.purchase_date desc;

-- LEFT JOIN ---
Select C.course_id,C.course_name as "Course Name",C.category ,C.unit_price "Unit Price",P.Quantity,(C.unit_price* P.quantity) AS total_amount,P.purchase_date as "Purchase Date"
from tbl_purchase P
left join tbl_course C on C.course_id=P.course_id
left join tbl_lerners L on L.lerner_id=P.lerner_id
order by P.purchase_date desc;

-- Right join
Select C.course_id,C.course_name as "Course Name",C.category ,C.unit_price "Unit Price",P.Quantity,(C.unit_price* P.quantity) AS total_amount,P.purchase_date as "Purchase Date"
from tbl_course C
right join tbl_purchase P  on C.course_id=P.course_id
right join tbl_lerners L on L.lerner_id=P.lerner_id
order by P.purchase_date Asc;

-- Analysis  Queries---

-- Q1.Display each learner’s total spending sum(quantity × unit_price) along with their country.
select L.lerner_id,L.full_name "Lerner Name" ,L.country ,sum((P.quantity*C.unit_price)) as "Total Spending"
from tbl_lerners L
join tbl_purchase P on P.lerner_id=L.lerner_id
join tbl_course C on C.course_id=P.course_id
group by L.lerner_id,L.full_name,L.country
order by sum( (P.quantity*C.unit_price));

-- Q2) Find the top 3 most purchased courses based on total quantity sold
select C.course_name, sum(P.quantity) as " total quantity"
from tbl_course C 
join tbl_purchase P on P.course_id=C.course_id
group by C.course_name,P.quantity
order by sum(P.quantity) desc
limit 3;

-- 3) Show each course category’s total revenue and the number of unique learners who purchased from that category.
select C.category,sum(C.unit_price*P.quantity) as "Total Revenue", count( distinct L.lerner_id) as " Unique Lerner"
from tbl_course C inner join tbl_Purchase P on P.course_id=C.course_id
inner join tbl_Lerners L on L.lerner_id=P.lerner_id
Group by C.category, L.lerner_id
Order by count( distinct L.lerner_id) Asc, sum(C.unit_price*P.quantity) desc;

-- 4) List all learners who have purchased courses from more than one category.
select L.full_name as "Learner Name",L.country ,count(distinct C.category) as "Category"
from tbl_Lerners L
join tbl_purchase P on P.lerner_id=L.lerner_id
join tbl_Course C on C.course_id=P.course_id
group by L.full_name,L.country
Having count(distinct C.category)>1;

-- 5)Identify courses that have not been purchased at all.

select  C.course_name,C.category from tbl_course C
left join tbl_purchase P on P.course_id=C.course_id
where P.course_id is null;
 


