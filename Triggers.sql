USE RealEstateAgency;

--- On deletion in Employee, column has_quit changes to yes and prints all deals done by this agent
GO
CREATE TRIGGER delete_employee ON Employee 
INSTEAD OF DELETE
AS
UPDATE Employee
SET has_quit = 'yes' --- default value for column has_quit is 'no' or NULL
WHERE EGN IN (SELECT EGN FROM DELETED)
BEGIN
	SELECT id,notary,estate,date,price,conditions,realEstateAgent,commissionPersentage 
	FROM Deal
	JOIN Employee
	ON realEstateAgent=EGN
	WHERE EGN=(SELECT EGN FROM DELETED)
END
GO

--- On creation in deal if conditions were very good or excellent, agent gets a raise of 5% on his current salary
GO
CREATE TRIGGER create_deal ON Deal
AFTER INSERT
AS
UPDATE Employee
SET salary = salary*105/100
WHERE EGN IN (SELECT realEstateAgent FROM INSERTED) AND (SELECT conditions FROM INSERTED) = 'Excellent'
GO
