USE RealEstateAgency;

--- On deletion in Employee, column has_quit changes to yes and prints all deals done by this agent
GO
CREATE TRIGGER delete_employee ON Employee 
INSTEAD OF DELETE
AS
UPDATE Employee
SET hasQuit = 'yes' --- default value for column has_quit is 'no'
WHERE EGN IN (SELECT EGN FROM DELETED)
BEGIN
	SELECT id,notary,estate,date,price,conditions,realEstateAgent,commissionPersentage 
	FROM Deal
	JOIN Employee
	ON realEstateAgent=EGN
	WHERE EGN=(SELECT EGN FROM DELETED)
END
GO

--- Example
SELECT * FROM Employee
WHERE EGN = '0024336282'
DELETE FROM Employee
WHERE EGN = '0024336282'
SELECT * FROM Employee
WHERE EGN = '0024336282'


--- On creation in deal if conditions were very good or excellent, agent gets a raise of 5% on his current salary
GO
CREATE TRIGGER create_deal ON Deal
AFTER INSERT
AS
UPDATE Employee
SET salary = salary*105/100
WHERE EGN IN (SELECT realEstateAgent FROM INSERTED) AND 
((SELECT conditions FROM INSERTED) = 'Excellent' OR (SELECT conditions FROM INSERTED) = 'Very Good')
GO

---Example
SELECT * FROM Employee
WHERE EGN = '1740948824'
INSERT INTO Deal
VALUES ('8371073496',2,'2016-11-23',136948,'Very Good','1740948824',6.11)
SELECT * FROM Employee
WHERE EGN = '1740948824'

--- On deleting an agent all of his deals are being transfered to the agent with least deals

GO
CREATE TRIGGER employee_quit ON Employee 
INSTEAD OF DELETE
AS
UPDATE Deal
SET realestateagent = (SELECT TOP 1 realestateagent from Deal
                       GROUP BY realestateagent
                       ORDER BY COUNT(realestateagent))
WHERE realestateagent IN (SELECT EGN FROM DELETED)
BEGIN
	SELECT id,notary,estate,date,price,conditions,realEstateAgent,commissionPersentage 
	FROM Deal
	JOIN Employee
	ON realEstateAgent=EGN
	WHERE EGN=(SELECT EGN FROM DELETED)
END
GO

---Example
SELECT * 
FROM Deal 
WHERE realestateagent = '3709558378'

DELETE FROM Employee 
WHERE egn = '3709558378'

SELECT * 
FROM Deal 
WHERE realestateagent = '3709558378'
