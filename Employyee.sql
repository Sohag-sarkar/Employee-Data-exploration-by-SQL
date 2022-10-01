SELECT * FROM world.emp1;
SELECT * FROM world.empr;

-- Finding Duplicates
select emp_id, name, dept , count(*) as count
from world.emp1
group by emp_id, name, dept
having count>1 ;

-- Removing Duplicates with same rows and different column valuse like different id

delete from world.emp where emp_id in(
(select emp_id from
(select *, row_number() over(partition by emp_id,name, dept, salary, age) as rownum  from world.emp1)
where rownum>1)) ;

-- Removing Duplicates with same rows and same column values 

WITH rownumCTE as (
select *, row_number() over(partition by emp_id,name, dept, salary, age) as rownum  from world.emp1
)
delete from rownumCTE
where rownum >1;

use  world;
create table emp_new as
select distinct * from world.emp1;
alter table emp_new rename to empc;
select * from empc;


use world;
create table emp_bkp as 
select * from emp1; 
select * from emp_bkp;
truncate table emp1;
insert into emp1 
select * from emp_bkp;
drop table emp_bkp;
select * from emp1;


--  Union and Union all
select emp_id, name, dept ,sex, age from emp1
union 
select * from empr;

select emp_id, name, dept ,sex, age from emp1
union all
select * from empr;


-- Rank, Row_Number and Dense Rank
select *, rank() over (partition by dept order by salary asc) AS B
 from world.emp1;

select *, row_number() over (partition by dept order by salary) as rownum
from world.emp1;

select *, dense_rank() over ( order by salary asc) AS B
 from world.emp1;


-- Find records in table which are not present in another table
select * from emp1 where emp_id not in
(select emp_id from empr);


-- Find second highest salary employees in each department 

select * from 
(select emp_id, name, dept,salary, dense_rank() over (partition by  dept order by salary desc) as salaryord
from emp1) as t
where salaryord = 2 ;


-- Find employees with salary more than their manager's salary
select * from emp1 where salary> 
(select salary from emp1 where name="sohag");


-- inner and left join 
-- inner join
select * 
from emp1 a
inner join empr b
on a.emp_id= b.emp_id;

select * 
from emp1 a
join empr b
on a.emp_id= b.emp_id;

-- left join
select * 
from emp1 a
left join empr b
on a.emp_id= b.emp_id;

-- update table and swap gender values
update emp1 set sex=
case
when sex="M" then "F"
WHEN sex="F" then "M"
end ;
select * from emp1;
 
-- Number of records in output with different kinds of join  
-- right join
select * 
from emp1 a
right join empr b
on a.emp_id= b.emp_id;

-- full outer join
select * 
from emp1 a
left join empr b
on a.emp_id= b.emp_id
union 
select * 
from emp1 a
right join empr b
on a.emp_id= b.emp_id;

-- cross join
select * 
from emp1 a
cross join empr b;

