USE RealEstateAgency;

-- create views
CREATE VIEW EstatesForSale
AS
	SELECT * FROM Estate
	WHERE type = 'sale'
WITH CHECK OPTION;

CREATE VIEW EstatesForRent
AS
	SELECT * FROM Estate
	WHERE type = 'rent'
WITH CHECK OPTION;

CREATE VIEW RealEstateAgents
AS 
	SELECT * FROM Employee
	WHERE position = 'agent'
WITH CHECK OPTION;

-- get all estates for sale which are not already sold
SELECT * FROM EstatesForSale
WHERE id NOT IN (SELECT estate FROM Deal);

-- get all estates for rent which are not already rented
SELECT * FROM EstatesForRent
WHERE id NOT IN (SELECT estate FROM Deal);

-- get all real estate agents who made at least one deal for more than 1000 leva
SELECT * FROM RealEstateAgents AS a
WHERE a.EGN IN (SELECT d.realEstateAgent FROM Deal AS d
				WHERE d.price > 1000);
			
-- create index in employee for position
CREATE NONCLUSTERED INDEX employee_position_idx
ON Employee(position);
