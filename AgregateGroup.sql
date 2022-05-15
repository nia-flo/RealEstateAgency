USE RealEstateAgency;

--- Highest paid agent in the agency
SELECT p.name, e.salary AS salary
FROM Person p
JOIN Employee e
ON e.EGN = p.EGN
WHERE e.position = 'agent' AND e.salary = (SELECT MAX(salary) FROM Employee)


--- Deals done from each agent
SELECT p.name , COUNT(d.estate) AS 'deals done'
FROM Person p
JOIN Employee e
ON p.EGN = e.EGN
LEFT JOIN Deal d
ON d.realEstateAgent = p.EGN
GROUP BY p.name


--- Count of female agents in the agency
SELECT COUNT(p.EGN) AS 'female employees'
FROM Person p
JOIN Employee e
ON e.EGN = p.EGN
WHERE p.gender = 'f'


--- Sum of all deals done by each company
SELECT c.name , SUM(d.price) AS 'spent total'
FROM Company c
JOIN Deal_BuyerCompany dc
ON dc.buyer = c.bulstat
JOIN Deal d
ON dc.deal = d.id
GROUP BY c.name


--- Count of deals done for each owner
SELECT p.name, COUNT(eo.estate) AS 'deals done'
FROM Person p
JOIN Estate_Owner eo
ON p.EGN = eo.owner
JOIN Estate e
ON eo.estate = e.id
LEFT JOIN Deal d
ON d.estate = e.id
GROUP BY p.name


--- Count of estates in each city
SELECT e.city, COUNT(e.id) AS 'number of estates'
FROM Estate e
GROUP BY e.city


--- Average number of rooms in rented estates
SELECT AVG(e.roomsCount) AS 'numberOfRooms'
FROM Deal d
JOIN Estate e
ON d.estate = e.id
WHERE e.type = 'rent';


--- The cheapest price of estate and the most expensive price of estate in each city
SELECT e.city, MIN(e.price) AS 'cheapest estate price', MAX(e.price) AS 'priciest estate price'
FROM Estate e
GROUP BY e.city;


--- The average size of sold estates with good or very good condition by city
SELECT e.city, AVG(e.area) AS 'average area'
FROM Deal d
JOIN Estate e
ON d.estate = e.id
WHERE e.type = 'sale' AND (d.conditions = 'Good' OR d.conditions = 'Very Good')
GROUP BY e.city;


--- The minimum commission percentage so far for each agent that had at least 1 deal and the price of the estate
SELECT p.name, d.commissionPersentage AS 'commission %', ee.price AS 'price for estate'
FROM Deal d
JOIN Employee e
ON d.realEstateAgent = e.EGN 
JOIN Person p
ON e.EGN = p.EGN
JOIN Estate ee
ON ee.id = d.estate
WHERE d.commissionPersentage = (SELECT MIN(commissionPersentage) FROM Deal d1 WHERE d.realEstateAgent = d1.realEstateAgent)
ORDER BY p.name;
