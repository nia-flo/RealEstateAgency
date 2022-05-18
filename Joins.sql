-- 1) IDs and addresses of all estates for rent without owners
SELECT e.id, e.city, e.address
FROM Estate_Owner eo
RIGHT JOIN Estate e ON eo.estate = e.id
WHERE eo.owner IS NULL
	AND e.type = 'rent';


-- 2) Names of companies that bought an estate for a lower price than the declared
SELECT distinct c.name
FROM Deal d
JOIN Deal_BuyerCompany bc ON bc.deal = d.id
JOIN Company c ON c.bulstat = bc.buyer
JOIN Estate e ON d.estate = e.id
WHERE d.price < e.price
	AND e.type = 'sale';


-- 3) Names of female owners in alphabetical order whose estates haven't been rented or sold 
SELECT DISTINCT p.name
FROM Estate_Owner eo
JOIN Person p ON p.EGN = eo.owner
LEFT JOIN Deal d ON eo.estate = d.estate
WHERE d.id IS NULL
	AND p.gender = 'f'	
ORDER BY p.name;
	

-- 4) Name of the notary from the last deal with a buyer company
SELECT p.name
FROM Deal d 
JOIN Person p ON p.EGN = d.notary
JOIN Deal_BuyerCompany bc ON d.id = bc.deal
WHERE d.date >= ALL ( SELECT d2.date
								FROM Deal d2
								JOIN Deal_BuyerCompany bc2 ON bc2.deal = d2.id);


-- 5) Names of companies that haven't bought or rented an estate between 01/01/2015 and 01/01/2019
SELECT c1.name
FROM Company c1
	EXCEPT
SELECT c2.name
FROM Deal d
JOIN Deal_BuyerCompany bc ON bc.deal = d.id
JOIN Company c2 ON c2.bulstat = bc.buyer
WHERE d.date BETWEEN '2015-01-01' AND '2019-01-01';

