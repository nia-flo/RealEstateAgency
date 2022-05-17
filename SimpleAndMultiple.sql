USE RealEstateAgency;

--Примерни прости заявки
--Simple queries examples
--1) Да се вземат номерата на имотите, който са от тип rent в интервала 2018, 2020, който са в добра(good) кондиция
--1) Get the number of esates that are of type rent and in the interval from 2018 to 2020, that are in good condition

SELECT id
FROM Deal
WHERE date > '2018-12-31 23:59:59' AND date < '2020-01-01 00:00:00'

--2) Да се вземат булстат номерата и мол на компаниите, чиито имена съддържат в себе си "Home" или "Property"
--2) Get the bulstat numbers and MOL of companies which names contain "Home" or "Property"

SELECT name
FROM Company
WHERE name LIKE '%Home%' OR name LIKE '%Property%'

--3) Да се изведът имейлите и телефоните на всички мъже
--3) Get the email and phone numbers of all males

SELECT email, phone
FROM Person
WHERE gender = 'm'

--4) Да се изведът адресите и цените на имотите, които са в гр. Русе с поне 3 стаи
--4) Get the addresses and prices of estates that are located in Ruse with at least 3 rooms

SELECT address, price
FROM Estate
WHERE roomscount >= 3 AND city = 'Ruse'

--5) Да се изведът града, адреса на имотите, които са с цена по-малка от 40 000лв и е от тип продажба(sale)
--5) Get the city, address of estates that are with price less than 40 000 lv. with type sale

SELECT city, address, price
FROM Estate
WHERE price < 40000 AND type = 'sale'

--6) Имената на всички хора, които живеят на бул. България
--6) Get the names of all people that live on "bul. Bulgaria"

SELECT name
FROM Person 
WHERE address LIKE '%bul. Bulgaria%'

--7) Да се изведът уникалните работните позиции, които могат да получават заплата над 7000лв.(има поне един такъв)
--7) Get all unique employee positions for which is posible to get salary over 7000 lv.

SELECT DISTINCT position 
FROM Employee
WHERE salary > 7000

--8) Да се изведе града, адреса, цената и какво е допълнително условие на всички имоти, които имат някакви допълнителни условия
--8) Get the city, address, price and the additional information of all estates that have any additional info

SELECT city, address, price, additionalinfo
FROM Estate
WHERE additionalinfo != ''

--9) Да се изведът всички id-та на имоти в много добра кондиция(very good), чиято комисионна е поне 7%
--9) Get all the ids of estates that are in very good condition, which real estate commision is at least 7%

SELECT estate 
FROM Deal
WHERE conditions = 'Very Good' AND commissionpersentage >= 7

--10) Да се изведът всички работни позиции, подредени по азбучен ред
--10) Get all job position, sorted 

SELECT DISTINCT position 
FROM Employee
ORDER BY position


--Заявки върху две и повече релации
--1) Да се изведът имената на всички жени на позиция юрист, които получават заплата над 3000лв
--1) Get the names of all females that are jirists with salary over 3000lv.

SELECT p.name 
FROM Employee e, Person p
WHERE e.position='jurist' AND e.salary >= 3000 AND e.EGN = p.egn AND p.gender='f'

--2) Да се изведът града, адреса и цената на всички имоти, който са в перфектно състояние(Excellent)
--2) Get the city, address and price of all estates which that are in excellent condition

SELECT  e.city, e.address, d.price 
FROM Deal d, Estate e
WHERE e.id = d.estate AND d.conditions='Excellent'

--3) Да се изведът имената на агентите, които имат поне 5 имота за продажба
--3) Get the names of all agents that have at least 5 estates deals

SELECT DISTINCT p.name 
FROM Employee e, Deal d, Person p
WHERE e.position='agent' AND p.EGN = e.egn AND e.EGN = d.realestateagent AND 
	  (SELECT COUNT(*) 
	  FROM Deal d1 
	  WHERE d1.realEstateAgent = e.egn and d1.id != d.id) >= 5

--4) Да се изведът града, адреса и цената на всички имоти купени от компанията EstateGuardian
--4) Get the city, address and price of all estates bought from the company "EstateGuardian"

SELECT e.city, e.address, d.price 
FROM Company c, Deal_BuyerCompany dbc, Deal d, Estate e
WHERE c.name='EstateGuardian' AND c.bulstat = dbc.buyer AND d.id = dbc.deal AND d.estate = e.id

--5) Да се изведът града, адреса и цената всички сделки с цена над 60 000лв, подредени в низходящ ред
--5) Get the city, address and price of all deals with price over 60 000lv, sorted from highest to lowest

SELECT e.city, e.address, d.price
FROM Deal_BuyerCompany dbc, Deal d, Estate e
WHERE dbc.deal = d.id AND d.price >= 60000 AND e.id = d.estate
	UNION
SELECT e1.city, e1.address, d1.price
FROM Deal_BuyerPerson dbp, Deal d1, Estate e1
WHERE dbp.deal = d1.id AND d1.price >= 60000 AND e1.id = d1.estate
ORDER BY price DESC

--6) Да се изведът имената на всички компании и хора, които са имат сделка за имот, който се намира в гр. Варна
--6) Get the names of all companies and people that have deals for estate in Varna
	
SELECT DISTINCT c.name
FROM Deal_BuyerCompany dbc, Deal d, Estate e, Company c
WHERE e.city = 'Varna' AND dbc.deal = e.id AND e.id = d.estate AND c.bulstat = dbc.buyer
	UNION
SELECT DISTINCT p.name
FROM Deal_BuyerPerson dbp, Deal d1, Estate e1, Person p
WHERE e1.city = 'Varna' AND dbp.deal = e1.id AND e1.id = d1.estate AND p.egn = dbp.buyer

--7) Да се изведът имената на всички собственици на имоти от женски пол, чийто имоти са от тип под наем(rent)
--7) Get the names of all female owners of estates, which estate is of type rent 

SELECT DISTINCT p.name 
FROM Estate_Owner eo, Person p, Estate e
WHERE eo.owner = p.egn AND eo.estate = e.id AND e.type = 'rent' AND p.gender = 'f'

--8) Да се изведът името на брокера, цената на имота и името на нотариуса на имотите продадени на компании от брокера Wilson Levy и всички имоти продадени на хора от Cole George
--8) Get the name of the agent, price and notary name, sold to companies from the agent Wilson Levy and all sold to people from agent with name Cole George 

SELECT p.name, d.price, p1.name
from Deal d, Person p, Person p1
WhERE p.name = 'Wilson Levy' and d.realestateagent = p.egn and p1.egn = d.notary
	EXCEPT
SELECt p2.name, d1.price, p3.name
FROM Person p2, Person p3, Deal d1, Deal_BuyerCompany dbc
where p2.name = 'Wilson Levy' and dbc.deal = d1.id and d1.realestateagent = p2.egn and p3.egn = d1.notary
	UNION
SELECT p4.name, d2.price, p5.name
FROM Deal d2, Person p4, Person p5
WhERE p4.name = 'Cole George' and d2.realestateagent = p4.egn and p5.egn = d2.notary
	EXCEPT
SELECt p6.name, d3.price, p7.name
FROM Person p6, Person p7, Deal d3, Deal_BuyerPerson dbp
where p6.name = 'Cole George' and dbp.deal = d3.id and d3.realestateagent = p6.egn and p7.egn = d3.notary

--9) Да се изведът имената на фирмите или хората, който участват в сделки за имоти, който са тристайни
--9) Get the names of companies or people which participate in deals for estates that have exactly 3 rooms

Select DISTINCT c.name
from Company c,  Estate e, Deal_BuyerCompany dbc, Deal d
where c.bulstat = dbc.buyer and dbc.deal = d.id and d.estate = e.id and e.roomscount = 3
	UNION
Select DISTINCT p1.name
from PErson p1, Estate e1, Deal_BuyerPerson dbp, Deal d1
where p1.egn = dbp.buyer and dbp.deal = d1.id and d1.estate = e1.id and e1.roomscount = 3

