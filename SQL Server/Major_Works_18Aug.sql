CREATE TABLE [dbo].[Dim_Time]
(
	[Time_ID] INT IDENTITY PRIMARY KEY
  ,	[Cal_Yr_ID] INT
  , [Cal_Mon_ID] INT
  --, CHECK ( Cal_Mon_ID <13 AND Cal_Mon_ID >0)
  , CHECK ( Cal_Mon_ID BETWEEN 1 AND 12)
)

--DROP TABLE [dbo].[Dim_Time];

CREATE TABLE [dbo].[Dim_City]
(
	[City_ID] INT IDENTITY NOT NULL PRIMARY KEY
,	[City_Code] VARCHAR(15)UNIQUE NOT NULL
,	[City_Name] VARCHAR(15)NOT NULL
,	[Population_Type] VARCHAR(20)
)

ALTER TABLE [dbo].[Dim_Time]
ADD [Month_Name] VARCHAR(9)

ALTER TABLE [dbo].[Dim_Time]
ALTER COLUMN [Month_Name] VARCHAR(9) NOT NULL

ALTER TABLE [dbo].[Dim_Product]
ALTER COLUMN [Product_Name] VARCHAR(50) NOT NULL

ALTER TABLE [dbo].[Dim_City]
DROP CONSTRAINT PK__Dim_City__DE9DE0201BFD2C07

ALTER TABLE [dbo].[Dim_City]
ADD CONSTRAINT PK__Dim_City__City_ID PRIMARY KEY([City_ID])

CREATE TABLE [dbo].[Fact_Sales]
(
	[Fact_Sales_ID] INT IDENTITY NOT NULL PRIMARY KEY
,	[City_ID] INT 
,	[Product_ID] INT
,	[Time_ID] INT
,	[Sales_Volume] NUMERIC(9,2) 
)

ALTER TABLE [dbo].[Fact_Sales]
ADD CONSTRAINT FK__Fact_Sales__Dim_Product FOREIGN KEY([Product_ID])
REFERENCES [Dim_Product] ([Product_ID])

ALTER TABLE [dbo].[Fact_Sales]
ADD CONSTRAINT FK__Fact_Sales__Dim_City FOREIGN KEY([City_ID])
REFERENCES [Dim_City] ([City_ID])

ALTER TABLE [dbo].[Fact_Sales]
ADD CONSTRAINT FK__Fact_Sales__Dim_Time FOREIGN KEY([Time_ID])
REFERENCES [Dim_Time] ([Time_ID])

ALTER TABLE [dbo].[Fact_Sales]
ALTER COLUMN [Sales_Volume] NUMERIC(9,2) NOT NULL

DROP TABLE [dbo].[Dim_City]

ALTER TABLE [dbo].[Fact_Sales]
ADD [Quantity] FLOAT DEFAULT 10

ALTER TABLE [dbo].[Fact_Sales]
DROP COLUMN [Quantity]

ALTER TABLE [dbo].[Fact_Sales]
DROP CONSTRAINT  DF__Fact_Sale__Quant__286302EC

INSERT INTO [dbo].[Dim_Product] 
(
	[Product_Code]
   ,[Product_Name]
)
VALUES
(
	'A001'
   ,'Axe'
)

INSERT INTO [dbo].[Dim_Product] 
(
	[Product_Code]
   ,[Product_Name]
)
VALUES
(
	'R001'
   ,'Rexona'
),
(
	'D001'
   ,'Dove'
)


INSERT INTO [dbo].[Dim_Product] 
(
	[Product_Code]
   ,[Product_Name]
)
VALUES
(
	'D001'
   ,'Dove'
)

SELECT * FROM [dbo].[Dim_Product]

INSERT INTO [dbo].[Dim_Time]
(
	[Cal_Yr_ID]
   ,[Cal_Mon_ID]
   ,[Month_Name]
)
VALUES
(
	2010
   ,1
   ,'Jan'
)
,(
	2010
   ,2
   ,'Feb'
)
,(
	2010
   ,3
   ,'March'
)
,(
	2010
   ,4
   ,'April'
)
,(
	2011
   ,1
   ,'Jan'
)
,(
	2011
   ,2
   ,'Feb'
)
,(
	2011
   ,3
   ,'March'
)
,(
	2011
   ,4
   ,'April'
)
,(
	2012
   ,1
   ,'Jan'
)
,(
	2012
   ,2
   ,'Feb'
)
,(
	2012
   ,3
   ,'March'
)
,(
	2012
   ,4
   ,'April'
)

SELECT * FROM [dbo].[Dim_Time]

TRUNCATE TABLE [dbo].[Dim_Time]

ALTER TABLE [dbo].[Fact_Sales]
DROP CONSTRAINT FK__Fact_Sales__Dim_Time

ALTER TABLE [dbo].[Dim_Time]
ALTER COLUMN [Month_Name] varchar(9) NOT NULL 

/*Way to Implement Enums in T-SQL*/
ALTER TABLE [dbo].[Dim_Time]
ADD CONSTRAINT Month_Check CHECK ([Month_Name] IN ('Jan','Feb','March','April',
'May','June','July','Aug','Sept','Oct','Nov','Dec'))

/*INSERTION*/
INSERT INTO [dbo].[Dim_City] 
(
	[City_Code]
	,[City_Name]
	,[Population_Type]
)
VALUES
(
	'BLR'
	,'Bangalore'
	,'Medium'
)
,(
	'DEL'
	,'Delhi'
	,'Dense'
)
,(
	'CHN'
	,'Chennai'
	,'Rare'
)
,(
	'LON'
	,'London'
	,'Dense'
)
,(
	'BRI'
	,'Bristol'
	,'Rare'
)
,(
	'NY'
	,'New York'
	,'Medium'
)

SELECT * FROM [dbo].[Dim_City]

SELECT 'Hello World!'

CREATE VIEW [Vw_Dim_Time] 
AS
SELECT * FROM [dbo].[Dim_Time]

SELECT * FROM [Vw_Dim_Time] 

DROP VIEW [Vw_Dim_Time]

CREATE VIEW [Vw_Dim_City] 
(
	[City_Code]
   ,[City_Desc]
)
AS
SELECT [dbo].[Dim_City].[City_ID]
	  ,[dbo].[Dim_City].[City_Name]
FROM [dbo].[Dim_City]
 
SELECT * FROM [Vw_Dim_City] 

CREATE VIEW [Vw_Dim_Time_2010] 
AS
SELECT * FROM [dbo].[Dim_Time]
WHERE [dbo].[Dim_Time].[Cal_Yr_ID]=2010

SELECT * FROM [Vw_Dim_Time_2010] 

SELECT * FROM [dbo].[Dim_Time]
WHERE [dbo].[Dim_Time].[Month_Name] IN ('Jan','Feb')

SELECT * 
FROM [dbo].[Dim_Time]
WHERE [Month_Name] LIKE 'Jan' OR [Month_Name] LIKE 'Feb'

SELECT * 
FROM [dbo].[Dim_City]
WHERE [City_Name] LIKE 'B%' 

INSERT INTO [dbo].[Fact_Sales]
VALUES
(
(SELECT City_ID From [dbo].[Dim_City] WHERE [dbo].[Dim_City].[City_Name] like 'Bangalore')
,(SELECT Product_ID From [dbo].[Dim_Product] WHERE [dbo].[Dim_Product].[Product_Name] like 'Dove')
,(SELECT Time_ID From [dbo].[Dim_Time] 
WHERE [dbo].[Dim_Time].[Cal_Yr_ID] = 2010 AND [dbo].[Dim_Time].[Month_Name] like 'Jan')
, 0
)


INSERT INTO [dbo].[Fact_Sales]
VALUES
(	
	1
	,3
	,1
	,0
)
,(	
	1
	,3
	,2
	,220
)
,(	
	3
	,3
	,1
	,220
)
,(	
	6
	,3
	,1
	,275
)
,(	
	4
	,3
	,1
	,300
)

SELECT * FROM [dbo].[Fact_Sales]

(SELECT COUNT(*) FROM [dbo].[Fact_Sales])

DBCC CHECKIDENT ([Fact_Sales],RESEED,5  )

DELETE FROM [dbo].[Fact_Sales] WHERE [Fact_Sales_ID]=6

INSERT INTO [dbo].[Fact_Sales]
VALUES
(
(SELECT City_ID From [dbo].[Dim_City] WHERE [dbo].[Dim_City].[City_Name] like 'Bangalore')
,(SELECT Product_ID From [dbo].[Dim_Product] WHERE [dbo].[Dim_Product].[Product_Name] like 'Axe')
,(SELECT Time_ID From [dbo].[Dim_Time] 
WHERE [dbo].[Dim_Time].[Cal_Yr_ID] = 2010 AND [dbo].[Dim_Time].[Month_Name] like 'Jan')
, 100
)
,(
(SELECT City_ID From [dbo].[Dim_City] WHERE [dbo].[Dim_City].[City_Name] like 'Bangalore')
,(SELECT Product_ID From [dbo].[Dim_Product] WHERE [dbo].[Dim_Product].[Product_Name] like 'Axe')
,(SELECT Time_ID From [dbo].[Dim_Time] 
WHERE [dbo].[Dim_Time].[Cal_Yr_ID] = 2011 AND [dbo].[Dim_Time].[Month_Name] like 'March')
, 150
)
,(
(SELECT City_ID From [dbo].[Dim_City] WHERE [dbo].[Dim_City].[City_Name] like 'Chennai')
,(SELECT Product_ID From [dbo].[Dim_Product] WHERE [dbo].[Dim_Product].[Product_Name] like 'Axe')
,(SELECT Time_ID From [dbo].[Dim_Time] 
WHERE [dbo].[Dim_Time].[Cal_Yr_ID] = 2010 AND [dbo].[Dim_Time].[Month_Name] like 'Feb')
, 0
)
,(
(SELECT City_ID From [dbo].[Dim_City] WHERE [dbo].[Dim_City].[City_Name] like 'New York')
,(SELECT Product_ID From [dbo].[Dim_Product] WHERE [dbo].[Dim_Product].[Product_Name] like 'Axe')
,(SELECT Time_ID From [dbo].[Dim_Time] 
WHERE [dbo].[Dim_Time].[Cal_Yr_ID] = 2012 AND [dbo].[Dim_Time].[Month_Name] like 'Jan')
, 200
)
,(
(SELECT City_ID From [dbo].[Dim_City] WHERE [dbo].[Dim_City].[City_Name] like 'London')
,(SELECT Product_ID From [dbo].[Dim_Product] WHERE [dbo].[Dim_Product].[Product_Name] like 'Axe')
,(SELECT Time_ID From [dbo].[Dim_Time] 
WHERE [dbo].[Dim_Time].[Cal_Yr_ID] = 2011 AND [dbo].[Dim_Time].[Month_Name] like 'Jan')
, 250
)

/*Method 1 to create a new copy*/
SELECT City_ID,City_Code,City_Name 
INTO [DenseCities]
FROM [dbo].[Dim_City] 
WHERE [Dim_City].[Population_Type] like 'Dense'

/*Method 2 to create a new copy*/
CREATE TABLE Dim_Density_City 
(
	[City_ID] INT 
,	[City_Code] VARCHAR(15)UNIQUE NOT NULL
,	[City_Name] VARCHAR(15)NOT NULL
)

INSERT INTO [Dim_Density_City]
(
	[City_ID] 
,	[City_Code] 
,	[City_Name]
)
SELECT City_ID,City_Code,City_Name 
FROM [dbo].[Dim_City] 
WHERE [Dim_City].[Population_Type] like 'Dense'

SELECT * FROM [dbo].[Fact_Sales] AS a
WHERE Product_ID = 
					(SELECT Product_ID
					 FROM [dbo].[Dim_Product] 
					 WHERE [dbo].[Dim_Product].[Product_Name] like 'Axe')
	AND Time_ID = 
					(SELECT Time_ID 
					FROM [dbo].[Dim_Time] 
					WHERE [dbo].[Dim_Time].[Cal_Yr_ID] = 2010 AND 
					[dbo].[Dim_Time].[Month_Name] like 'Feb')
					
SELECT Product_ID,SUM(Sales_Volume) AS [Total Sales] FROM [dbo].[Fact_Sales]
WHERE City_ID = (SELECT City_ID From [dbo].[Dim_City] 
				WHERE [dbo].[Dim_City].[City_Name] like 'Bangalore') 
GROUP BY Product_ID
HAVING SUM(Sales_Volume) BETWEEN 200 AND 300		

SELECT COUNT(0) FROM [dbo].[Fact_Sales];

/*Display the total no of sales and the TOtal Sales VOlume for each city*/
SELECT City_ID,Count(Product_ID) AS [Total Number of Sales] ,SUM(Sales_Volume) AS [Total Sales Volume] 
FROM [dbo].[Fact_Sales]
GROUP BY City_ID

SELECT City_Name FROM [dbo].[Dim_City] WHERE City_ID IN (SELECT DISTINCT City_ID FROM [dbo].[Fact_Sales])
SELECT Product_Name FROM [dbo].[Dim_Product] WHERE Product_ID IN (SELECT Product_ID FROM [dbo].[Fact_Sales])

/*Displaying Product Names for the Group by */
SELECT Product_Name FROM [dbo].[Dim_Product]
WHERE Product_ID IN
(
SELECT Product_ID FROM [dbo].[Fact_Sales]
WHERE City_ID = (SELECT City_ID From [dbo].[Dim_City] 
				WHERE [dbo].[Dim_City].[City_Name] like 'Bangalore') 
GROUP BY Product_ID
HAVING SUM(Sales_Volume) BETWEEN 200 AND 300)

/*City Names in Sales Data*/
SELECT City_Name 
FROM [dbo].[Dim_City] 
WHERE City_ID IN 
(
SELECT City_ID AS [Total Sales] FROM [dbo].[Fact_Sales]
GROUP BY City_ID
)

/*Cities having sales volumes less than 500*/
SELECT City_ID,SUM(Sales_Volume) AS [Total Sales] FROM [dbo].[Fact_Sales]
GROUP BY City_ID
HAVING SUM(Sales_Volume) < 500

/**/
INSERT INTO [dbo].[Dim_City] 
(
	City_Code
	,City_Name
	,Population_Type
)
VALUES
(
	'LON1'
	,'London'
	,'Dense'
)

SELECT TOP 5 * FROM [dbo].[Dim_City] 

/*Finding Duplicate Entries in a Column*/
SELECT City_Name, COUNT(City_Name) FROM [dbo].[Dim_City]
GROUP BY City_Name
HAVING COUNT(City_Name) > 1

/*Medium Population city, Product ascending, Sales descending */
SELECT Product_ID, Time_ID, SUM(Sales_Volume) AS [Sales Volume]
FROM [dbo].[Fact_Sales]
WHERE City_ID IN 
	(
		SELECT City_ID FROM [dbo].[Dim_City]
		WHERE [dbo].[Dim_City].[Population_Type] = 'medium'
	)
GROUP BY Product_ID, Time_ID
ORDER BY Product_ID,[Sales Volume] DESC 
