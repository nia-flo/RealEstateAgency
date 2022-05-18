-- 1) Names of real estate agents that took part in a deal for an estate with its owner living on bul. Bulgaria
SELECT DISTINCT agent.name
FROM Deal d
JOIN Person agent ON d.realEstateAgent = agent.EGN
WHERE d.estate IN ( SELECT eo.estate
									FROM Estate_Owner eo
									JOIN Person p ON eo.owner  = p.EGN
									WHERE p.address LIKE 'bul. Bulgaria %' )


-- 2) Deal ID, buyer (person or company) name and commision percentage, ordered decreasingly by commission percentage, for deals with commission percentage
--    higher than the max commission percentage for deals with real estate agent Alina Huber
SELECT d.id, buyer.name, d.commissionPersentage
FROM Deal d, (SELECT c.name, bc.deal
							FROM Deal_BuyerCompany bc
							JOIN Company c ON c.bulstat = bc.buyer
								UNION
							SELECT p.name, bp.deal
							FROM Deal_BuyerPerson bp
							JOIN Person p ON bp.buyer = p.EGN ) buyer
WHERE d.id = buyer.deal
	AND d.commissionPersentage > ALL (SELECT d2.commissionPersentage
												FROM Deal d2
												JOIN Person p ON p.EGN = d2.realEstateAgent
												WHERE p.name = 'Alina Huber')
ORDER BY d.commissionPersentage DESC


-- 3) Buyer name and EGN for deals where the buyer has made a deal before
SELECT DISTINCT p.name, p.EGN
FROM Deal_BuyerPerson bp
	JOIN Person p ON bp.buyer = p.EGN
	JOIN Deal d ON bp.deal = d.id
	JOIN Estate e ON e.id = d.estate
	JOIN Estate_Owner eo ON eo.estate = e.id
	WHERE d.date > ANY ( SELECT d2.date
									FROM Deal d2
									JOIN Estate e2 ON e2.id = d2.estate
									JOIN Estate_Owner eo2 ON eo2.estate = e2.id)



-- 4) City and address in alphabetical order for estates sold after real estate agent Cole George's last deal
SELECT e.city, e.address
FROM Deal d
JOIN Estate e ON e.id = d.estate
WHERE d.date > ALL ( SELECT d2.date
								FROM Deal d2
								JOIN Person a ON a.EGN = d2.realEstateAgent
								WHERE a.name = 'Cole George')
	AND e.type = 'sale'
ORDER BY e.city, e.address


-- 5) Names and addresses of real estate agents that took part in a deal with commission percentage higher than 
--    the commission percentages of deals for estates in Plovdiv
SELECT DISTINCT p.name, p.email
FROM Deal d
JOIN Person p ON d.realEstateAgent = p.EGN
WHERE d.commissionPersentage > ALL ( SELECT d2.commissionPersentage 
																FROM Deal d2
																JOIN Estate e ON e.id = d2.estate
																WHERE e.city = 'Plovdiv')



