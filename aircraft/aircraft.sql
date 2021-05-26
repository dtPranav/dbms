create database aircraft;
use aircraft;	
create table flights(
	flno int,
    pfrom varchar(30),
    pto varchar(30),
    distance int ,
    departs time,
    arrives time,
    price int,
    constraint f_air primary key(flno),
    constraint ff_air foreign key (flno) references aircraft(aid) on delete cascade on update cascade 
);
create table aircraft (
	aid int ,
    aname varchar(15),
    cruisingrange int,
    constraint primary key (aid)
);

create table employees(
	eid int ,
    ename varchar(30),
    salary int,
    constraint e_eid primary key(eid)
);

create table certified(
	eid int ,
    aid int,
    constraint c_eid foreign key (eid) references employees(eid) on delete cascade on update cascade,
    constraint c_aid foreign key (aid) references aircraft (aid) on delete cascade on update cascade
);

-- i Find the names of aircraft such that all pilots certified to operate them have salaries more than Rs.80,000. 
select distinct(a.aname) from aircraft a where a.aid in (select c.aid from certified c where c.eid in (select e.eid from employee e where e.salary>80000));

-- ii.For each pilot who is certified for more than three aircrafts, find the eid and the maximum cruisingrange of the aircraft for which she or he is certified.
-- select c.eid,a.cruisingrange from airport a,certified c where c.eid in (select ca.eid from certified ca group by ca.eid having count(c.aid)>3) and ;
-- select c.eid from certified c where c.aid in (select * from aircraft a where a.aid in (select ca.aid from certified ca where ca.eid=c.eid) order by cruisingrange limit 1  )  group by c.eid  having count(c.aid)>3 
select ca.aid from certified ca where exists (select c.aid from certified c where ca.eid=c.eid group by c.eid having count(c.aid)>3);


-- iii.Find the names of pilots whose salary is less than the price of the cheapest route from Bengaluru to Frankfurt.
select e.eid from employees e where e.salary<(select min(f.price) from flights f where f.pfrom='Bengaluru' and f.pto='Frankfurt');

-- iv.For all aircraft with cruisingrange over 1000 Kms, find the name of the aircraft and the average salary of all pilots certified for this aircraft 
select avg(e.salary) from employees e where e.eid in (select c.eid from certfied c where exists (select * from aircraft a where a.aid=c.aid and a.cruisingrange>1000) group by c.aid);  

-- v.Find the names of pilots certified for some Boeing aircraft.
select distinct(e.ename) from employees e where exists (select c.eid from certified c where c.eid=e.eid and c.aid in (select a.aid where a.aname='Boeing'));

-- vi. Find the aids of all aircraft that can be used on routes from Bengaluru to New Delhi.   
select a.aid from aircraft a where a.cruisingrange >= (select f.distance from flight f where pfrom='Bengaluru' and f.pto='New Delhi');

-- vii. A customer wants to travel from Madison to New York with no more than two changes of flight. List the choice of departure times from Madison if the customer wants to arrive in New York by 6 p.m 
select f1.departs from flights f1,flights f2 where f1.pfrom='Madison' and f2.pto='New York' and f2.arrives<'18:00';
