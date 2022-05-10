--Примерни прости заявки
--1) Да се вземат номерата на имотите, който са от тип rent в интервала 2015, 2020, който са в добра(good) кондиция
--2) Да се вземат номерата и комисионната на нотариусите, чиито имоти са на цена под 400лв
--3) Да се вземат булстат номерата и мол на компаниите, чиито има има в себе си "Home" или "Property"
--4) Да се изведът имейлите и телефоните на всички мъже
--5) Да се изведът адресите и цените на имотите, които са в гр. Русе с поне 3 стаи
--6) Да се изведът града, адреса на имотите, които са с цена по-малка от 50 000лв.
--7) Имената на всички хора, които живеят на бул. България
--8) Да се изведът уникалните работните позиции, които получават заплата над 7000лв.
--9) Да се изведе града и адреса на всички имоти, които имат някакви допълнителни условия
--10) Да се изведът всички имоти в много добра кондиция(very good), чиято комисионна е поне 7%
--11) Да се изведът всички работни позиции, подредени по азбучен ред

SELECT DISTINCT position 
FROM Employee
ORDER BY position

--Заявки върху две и повече релации
--1) Да се изведът имената на всички жени на позиция юрист, които получават заплата над 3000лв

SELECT p.name 
FROM Employee e, Person p
WHERE e.position='jurist' AND e.salary >= 3000 AND e.EGN = p.egn AND p.gender='f'

--2) Да се изведът града, адреса и цената на всички имоти, който са в перфектно състояние(Excellent)

SELECT  e.city, e.address, d.price 
FROM Deal d, Estate e
WHERE e.id = d.estate AND d.conditions='Excellent'

--3) Да се изведът имената на агентите, които имат поне 5 имота за продажба 
SELECT DISTINCT p.name 
FROM Employee e, Deal d, Person p
WHERE e.position='agent' AND p.EGN = e.egn AND e.EGN = d.realestateagent AND 
	  (SELECT COUNT(*) 
	  FROM Deal d1 
	  WHERE d1.realEstateAgent = e.egn and d1.id != d.id) >= 5

--4) Да се изведът града, адреса и цената на всички имоти купени от компанията EstateGuardian
SELECT e.city, e.address, d.price 
FROM Company c, Deal_BuyerCompany dbc, Deal d, Estate e
WHERE c.name='EstateGuardian' AND c.bulstat = dbc.buyer AND d.id = dbc.deal AND d.estate = e.id

--5) Да се изведът града и адреса и цената всички сделки с цена над 60 000лв. от тип продажба, подредени в низходящ ред

SELECT e.city, e.address, d.price
FROM Deal_BuyerCompany dbc, Deal d, Estate e
WHERE d.type = 'sale' AND dbc.deal = d.id AND d.price >= 60000 AND e.id = d.estate
	UNION
SELECT e1.city, e1.address, d1.price
FROM Deal_BuyerPerson dbp, Deal d1, Estate e1
WHERE d1.type = 'sale' AND dbp.deal = d1.id AND d1.price >= 60000 AND e1.id = d1.estate
ORDER BY price DESC

--6) Да се изведът имената на всички компании и хора, които са имат сделка за имот, който се намира в гр. Варна
	
SELECT DISTINCT c.name
FROM Deal_BuyerCompany dbc, Deal d, Estate e, Company c
WHERE e.city = 'Varna' AND dbc.deal = e.id AND e.id = d.estate AND c.bulstat = dbc.buyer
	UNION
SELECT DISTINCT p.name
FROM Deal_BuyerPerson dbp, Deal d1, Estate e1, Person p
WHERE e1.city = 'Varna' AND dbp.deal = e1.id AND e1.id = d1.estate AND p.egn = dbp.buyer

--7) Да се изведът фирмите, които продават имоти от тип под наем(rent) както и такива от тип цялостна продажба(sale)
--8) Да се изведът имената на всички собственици на имоти

SELECT DISTINCT p.name 
FROM Estate_Owner e, Person p
WHERE e.owner = p.egn

--9) Да се изведът града и адреса на имотите, чиито сделки са сключени след 2015г. нататък без 2018г. 
--10) Да се изведът имената на фирмите и хората, който имат имоти за продажба само от тип sale

