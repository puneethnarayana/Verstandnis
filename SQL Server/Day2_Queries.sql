UPDATE [dbo].[Fact_Sales]
SET [Sales_Volume] = 125
WHERE [Sales_Volume] = 0

SELECT * FROM [dbo].[Fact_Sales]

ALTER TABLE [dbo].[Dim_Product]
ADD  [Unit_Price] NUMERIC(9,2) NOT NULL  
CONSTRAINT [df_unit_price] DEFAULT 0 

ALTER TABLE [dbo].[Dim_Product] DROP COLUMN [Unit_Price]

UPDATE [dbo].[Dim_Product]
SET [Unit_Price] = 
(SELECT AVG([Fact_Sales].[Sales_Volume] )
		FROM [Fact_Sales]
		WHERE [Fact_Sales].[Product_ID] = 
		(
		SELECT [Dim_Product].[Product_ID] FROM 
		[Dim_Product] WHERE 
		[Dim_Product].[Product_Name] = 'Dove'
		))
WHERE  [Product_Name] = 'Dove'
		
			
SELECT [dbo].[Fact_Sales].[Sales_Volume] 
FROM [Fact_Sales]
WHERE [Fact_Sales].[Product_ID] = 
(
		SELECT [Dim_Product].[Product_ID] FROM 
		[Dim_Product] WHERE 
		[Dim_Product].[Product_Name] = 'Dove'
		)
		
DELETE FROM [Fact_Sales]
WHERE [Sales_Volume] >= 300


SELECT * FROM [dbo].[Fact_Sales]
UNION
SELECT * FROM [dbo].[Dim_Product]

SELECT [Product_ID],SUM(Sales_Volume)
FROM [Fact_Sales]
GROUP BY [Product_ID]

SELECT * INTO [dbo].[Fact_Sales_Dummy]
FROM [dbo].[Fact_Sales]

DROP TABLE [dbo].[Fact_Sales_Dummy]

SELECT * FROM [dbo].[Fact_Sales]
UNION
SELECT * FROM [dbo].[Fact_Sales_Dummy]

SELECT * FROM [dbo].[Fact_Sales]
UNION ALL
SELECT * FROM [dbo].[Fact_Sales_Dummy]

SELECT c.[City_Name], fs.[Sales_Volume]
FROM [dbo].[Fact_Sales] fs
INNER JOIN [dbo].[Dim_City] c
ON c.City_ID = fs.City_ID

SELECT c.[City_Name], SUM(fs.[Sales_Volume])
FROM [dbo].[Fact_Sales] fs
INNER JOIN [dbo].[Dim_City] c
ON c.City_ID = fs.City_ID
GROUP BY c.[City_Name]

SELECT DISTINCT c.[City_Name]
FROM [dbo].[Fact_Sales] AS fs
INNER JOIN [dbo].[Dim_City] AS c
ON c.City_ID = fs.City_ID

/*Joining Integer cols to display as one OP
Multiple INNER JOINS
CASTing the integers to display
using LEFT, SUBSTRING functions to manipulate Strings
*/
SELECT p.Product_Name AS [Product_Name]
		, c.[City_Name] AS [City]
		, (t.Month_Name+' '+ CAST(t.Cal_Yr_ID AS VARCHAR(5))) AS [Month] 
		--, (LEFT(t.Month_Name,3)+' '+ CAST(t.Cal_Yr_ID AS VARCHAR(5))) AS [Month] 
		--, (SUBSTRING(t.Month_Name,1,3)+' '+ CAST(t.Cal_Yr_ID AS VARCHAR(5))) AS [Month] 
		, CAST(t.Cal_Yr_ID AS VARCHAR(5))+' '+ CAST(t.Cal_Mon_ID AS VARCHAR(5)) AS [Month]
		, fs.[Sales_Volume] AS [Sales Volume]
FROM [dbo].[Fact_Sales] fs
INNER JOIN [dbo].[Dim_City] c
ON c.City_ID = fs.City_ID
INNER JOIN [dbo].[Dim_Product] p
ON p.Product_ID = fs.Product_ID
INNER JOIN [dbo].[Dim_Time] t
ON t.Time_ID = fs.Time_ID

ALTER TABLE Dim_Time
ADD [DateTIme_Test] DATETIME 

INSERT INTO Dim_Time
(
	  Month_Name
	, DateTIme_Test
)
VALUES(
	'Jan'	,
	GETDATE()
)

SELECT  * FROM [dbo].[Dim_Time]

SELECT  DateTIme_Test FROM [dbo].[Dim_Time]
WHERE Time_ID = 15

SELECT  CONVERT(VARCHAR(10),DateTIme_Test,10) FROM [dbo].[Dim_Time]
WHERE Time_ID = 15

ALTER TABLE [dbo].[Dim_Time]
DROP COLUMN [DateTIme_Test]

SELECT CONVERT(VARCHAR(19),GETDATE())AS [Default]
SELECT CONVERT(VARCHAR(19),GETDATE(),101)AS [Type 1]
SELECT CONVERT(VARCHAR(19),GETDATE(),101)AS [Type 101]
SELECT CONVERT(VARCHAR(19),GETDATE(),5)AS [Type 5]
SELECT CONVERT(VARCHAR(19),GETDATE(),105)AS [Type 105]
SELECT CONVERT(VARCHAR(19),GETDATE(),6)AS [Type 6]
SELECT CONVERT(VARCHAR(19),GETDATE(),106)AS [Type 106]
SELECT CONVERT(VARCHAR(10),GETDATE(),10)
SELECT CONVERT(VARCHAR(10),GETDATE(),110)
SELECT CONVERT(VARCHAR(11),GETDATE(),6)
SELECT CONVERT(VARCHAR(11),GETDATE(),106)
SELECT CONVERT(VARCHAR(24),GETDATE(),113)

/* USING ORDER BY in Conjunction with GROUP BY AND INNER JOIN*/
SELECT (t.Month_Name+' '+ CAST(t.Cal_Yr_ID AS VARCHAR(5))) AS [Month]
		, SUM(fs.Sales_Volume) AS [Sales in the Month]
FROM Fact_Sales fs
INNER JOIN Dim_Product p
ON p.Product_ID = fs.Product_ID
INNER JOIN Dim_Time t
ON t.Time_ID = fs.Time_ID
WHERE p.Product_Name = 'Axe'
GROUP BY t.Month_Name, t.Cal_Yr_ID, t.Cal_Mon_ID
ORDER BY t.Cal_Yr_ID,t.Cal_Mon_ID

SELECT (t.Month_Name+' '+ CAST(t.Cal_Yr_ID AS VARCHAR(5))) AS [Month], fs.Sales_Volume
FROM Fact_Sales fs
INNER JOIN Dim_Product p
ON p.Product_ID = fs.Product_ID
INNER JOIN Dim_Time t
ON t.Time_ID = fs.Time_ID
WHERE p.Product_Name = 'Axe'

/*USING LEFT AND RIGHT OUTER JOINS*/
SELECT c.City_Name
FROM [dbo].[Dim_City] c
LEFT JOIN [dbo].[Fact_Sales] fs
ON c.City_ID = fs.City_ID
WHERE fs.City_ID IS NULL

SELECT c.City_Name,*
FROM [dbo].[Dim_City] c
LEFT JOIN [dbo].[Fact_Sales] fs
ON c.City_ID = fs.City_ID

SELECT c.City_Name
FROM [dbo].[Fact_Sales] fs
RIGHT JOIN [dbo].[Dim_City] c
ON c.City_ID = fs.City_ID
WHERE fs.City_ID IS NULL


/*ADDITIONAL JOIN EXERCISES*/

/*Populate Size and Color from a third table*/

INSERT INTO [TrainingDB].[dbo].[dim_product_colour] 
(
	product_colour_code
	,product_colour_desc
)
SELECT DISTINCT [SDP].[product_colour_code],[SDP].[product_colour_desc]
FROM [TrainingDB].[stage].[source_dim_product] [SDP]
LEFT JOIN [TrainingDB].[dbo].[dim_product_colour] [DPC]
ON [DPC].[product_colour_code] = [SDP].[product_colour_code]
WHERE [SDP].[available_in_market] LIKE 'Y' AND [SDP].[product_colour_code] IS NOT NULL 
AND [DPC].[product_colour_code] IS NULL

/*----------------------*/
INSERT INTO [TrainingDB].[dbo].[dim_product_size] 
(
	product_size_desc
)
SELECT DISTINCT [SDP].[product_size]
FROM [TrainingDB].[stage].[source_dim_product] [SDP]
LEFT JOIN [TrainingDB].[dbo].[dim_product_size] [DPS]
ON [DPS].[product_size_desc] = [SDP].[product_size]
WHERE [SDP].[available_in_market] LIKE 'Y' AND [SDP].[product_size] IS NOT NULL 
AND [DPS].[product_size_desc] IS NULL

SELECT * FROM [TrainingDB].[dbo].[dim_product_colour] 
SELECT * FROM [TrainingDB].[dbo].[dim_product_size]

DELETE FROM [TrainingDB].[dbo].[dim_product_colour] 

/*Question 2*/
UPDATE [TrainingDB].[dbo].[dim_product] 
SET [product_name] = [SDP].[product_desc]
,	[product_size_id] = [DPS].[product_size_id]
,	[product_colour_id] = [DPC].[product_colour_id]
FROM [TrainingDB].[dbo].[dim_product] [DP]
JOIN [TrainingDB].[stage].[source_dim_product] [SDP]
ON [DP].[product_code] = [SDP].[product_code]
JOIN [TrainingDB].[dbo].[dim_product_size] [DPS]
ON [DPS].[product_size_desc] = [SDP].[product_size]
JOIN [TrainingDB].[dbo].[dim_product_colour] [DPC]
ON [DPC].[product_colour_code] = [SDP].[product_colour_code]
WHERE ISNULL([DP].[Product_Name],0) <> ISNULL([SDP].[product_desc],0)
OR	ISNULL([DP].[product_size_id],0) <> ISNULL([DPS].[product_size_id],0)
OR	ISNULL([DP].[product_colour_id],0) <> ISNULL([DPC].[product_colour_id],0)

/*Question 3*/
INSERT INTO [TrainingDB].[dbo].[dim_product] 
(
	[Product_Code]
	,[Product_Name]
	,[product_colour_id]
	,[product_size_id]
	,[available_in_market]
)
SELECT  [SDP].[product_code]
	,[SDP].[product_desc]
	,[DPC].[product_colour_id]
	,[DPS].[product_size_id]
	,[SDP].[available_in_market]
FROM [TrainingDB].[stage].[source_dim_product] [SDP]
LEFT JOIN [TrainingDB].[dbo].[dim_product] [DP]
ON [DP].[product_code] = [SDP].[product_code]
JOIN [TrainingDB].[dbo].[dim_product_size] [DPS]
ON [DPS].[product_size_desc] = [SDP].[product_size]
JOIN [TrainingDB].[dbo].[dim_product_colour] [DPC]
ON [DPC].[product_colour_code] = [SDP].[product_colour_code]
WHERE [SDP].[available_in_market] LIKE 'Y' 
AND [DP].[product_code] IS NULL


/*Question 4*/
DELETE FROM [Dim_Product] 
FROM [Dim_Product] [DP]
JOIN [TrainingDB].[stage].[source_dim_product] [SDP]
ON [SDP].[product_code] = [DP].[product_code]
WHERE [SDP].[available_in_market] = 'N'

/*GET THE MAX LENGTH DESCRIPTION*/
SELECT TOP 1 product_desc 
FROM [stage].[source_dim_product]
GROUP BY Product_Code,product_desc
ORDER BY LEN(product_desc) DESC

/*USING RANK*/
SELECT product_code,product_desc FROM
(
SELECT product_code,product_desc ,
RANK() OVER (PARTITION BY product_code ORDER BY LEN(product_desc) DESC ) AS [Ratings]
FROM [stage].[source_dim_product]
) a
WHERE a.Ratings=1

/**/
UPDATE [TrainingDB].[dbo].[dim_product] 
SET [product_name] = [S].[product_desc]
,	[product_size_id] = [DPS].[product_size_id]
,	[product_colour_id] = [DPC].[product_colour_id]
--select dp.*
FROM 
(
SELECT product_code,product_desc FROM
(
SELECT product_code,product_desc ,
RANK() OVER (PARTITION BY product_code ORDER BY LEN(product_desc) DESC ) AS [Ratings]
FROM [stage].[source_dim_product]
) a
WHERE a.Ratings=1
) S 
JOIN [TrainingDB].[dbo].[dim_product] [DP]
ON S.product_code = DP.product_code
JOIN [TrainingDB].[stage].[source_dim_product] [SDP]
ON [DP].[product_code] = [SDP].[product_code]
JOIN [TrainingDB].[dbo].[dim_product_size] [DPS]
ON [DPS].[product_size_desc] = [SDP].[product_size]
JOIN [TrainingDB].[dbo].[dim_product_colour] [DPC]
ON [DPC].[product_colour_code] = [SDP].[product_colour_code]
WHERE ISNULL([DP].[Product_Name],0) <> ISNULL([SDP].[product_desc],0)
OR	ISNULL([DP].[product_size_id],0) <> ISNULL([DPS].[product_size_id],0)
OR	ISNULL([DP].[product_colour_id],0) <> ISNULL([DPC].[product_colour_id],0)

SELECT * FROM [dbo].[Dim_Product]
SELECT * FROM [stage].[source_dim_product]

DELETE FROM [stage].[source_dim_product]
WHERE product_desc = 'Axe Mini'