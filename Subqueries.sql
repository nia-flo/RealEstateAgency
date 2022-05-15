-- 1) Да се изведат имената на агентите, които са участвали в сделка за имот, чийто собственик живее на бул. България
SELECT DISTINCT agent.name
FROM Deal d
JOIN Person agent ON d.realEstateAgent = agent.EGN
WHERE d.estate IN ( SELECT eo.estate
									FROM Estate_Owner eo
									JOIN Person p ON eo.owner  = p.EGN
									WHERE p.address LIKE 'bul. Bulgaria %' )


-- 2) Да се изведат в низходящ ред по стойността на комисионната идентификационния номер на сделките, името на купувача (физическо или юридическо лице) и комисионната 
--    за всички сделки с комисионна по-голяма от максималната комисионна за сделките, в които е участвал агентът Alina Huber
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


-- 3) Да се изведат името на купувача и ЕГН-то му за всички сделки, в които продавача е сключвал сделка и преди това
SELECT DISTINCT p.name, p.EGN
FROM Deal_BuyerPerson bp
	JOIN Person p ON bp.buyer = p.EGN
	JOIN Deal d ON bp.deal = d.id
	JOIN Deal_Seller ds ON ds.deal = d.id
	WHERE d.date > ANY ( SELECT d2.date
									FROM Deal_Seller ds2 
									JOIN Deal d2 ON ds2.deal = d2.id
									WHERE ds.seller = ds2.seller )



-- 4) Да се изведат подредени във възходящ ред града и адресите на всички имоти, продадени след последната сделка, в която е участвал агентът Cole George
SELECT e.city, e.address
FROM Deal d
JOIN Estate e ON e.id = d.estate
WHERE d.date > ALL ( SELECT d2.date
								FROM Deal d2
								JOIN Person a ON a.EGN = d2.realEstateAgent
								WHERE a.name = 'Cole George')
	AND e.type = 'sale'
ORDER BY e.city, e.address


-- 5) Да се изведат имената и имейлите на агентите, които са участвали в сделка с комисионна по-голяма от комисионните при сделките, сключени за имоти в Пловдив
SELECT DISTINCT p.name, p.email
FROM Deal d
JOIN Person p ON d.realEstateAgent = p.EGN
WHERE d.commissionPersentage > ALL ( SELECT d2.commissionPersentage 
																FROM Deal d2
																JOIN Estate e ON e.id = d2.estate
																WHERE e.city = 'Plovdiv')



