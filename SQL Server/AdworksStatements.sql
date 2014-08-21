SELECT ISNULL(FirstName,'')+' '+ISNULL(MiddleName,'')+' '+ISNULL(LastName,'') 
AS [Full Name]
FROM DimEmployee 

SELECT DISTINCT ISNULL(FirstName,'')+' '+ISNULL(MiddleName,'')+' '+ISNULL(LastName,'') 
AS [Full Name]
FROM DimEmployee 

SELECT COALESCE (FirstName+' '+MiddleName+' '+LastName, 
FirstName+' '+LastName, FirstName+' '+MiddleName, MiddleName+' '+LastName) 
AS [Full Name] 
FROM DimEmployee

SELECT * FROM DimEmployee;

SELECT [ProductCategoryKey]
  FROM [Ad works].[dbo].[DimProductCategory]
  WHERE [EnglishProductCategoryName] = 'Clothing'
  
  
SELECT [ProductSubcategoryKey]
  FROM [Ad works].[dbo].[DimProductSubcategory]
  WHERE [ProductCategoryKey] = (SELECT [ProductCategoryKey]
  FROM [Ad works].[dbo].[DimProductCategory]
  WHERE [EnglishProductCategoryName] = 'Clothing' )
  
  /*Using Where Clause*/
 SELECT [ProductKey]
      ,[ProductAlternateKey]
      ,[EnglishProductName]
      
  FROM [Ad works].[dbo].[DimProduct]
  WHERE [ProductSubcategoryKey] IN 
  (  
	SELECT [ProductSubcategoryKey]
	FROM [Ad works].[dbo].[DimProductSubcategory]
	WHERE [ProductCategoryKey] = (SELECT [ProductCategoryKey]
	FROM [Ad works].[dbo].[DimProductCategory]
	WHERE [EnglishProductCategoryName] = 'Clothing' ))
	
/*Without Using the Where*/
 SELECT p.[ProductKey]
      ,p.[ProductAlternateKey]
      ,p.[EnglishProductName]
  FROM [Ad works].[dbo].[DimProductSubcategory] psc
  JOIN [Ad works].[dbo].[DimProduct] p
  ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
  JOIN [Ad works].[dbo].[DimProductCategory] pc
  ON pc.ProductCategoryKey = psc.ProductCategoryKey AND pc.EnglishProductCategoryName = 'Clothing'
  
  /*DISTINCT VALUES*/
 SELECT DISTINCT p.[ProductAlternateKey]
     ,p.[EnglishProductName]
  FROM [Ad works].[dbo].[DimProductSubcategory] psc
  JOIN [Ad works].[dbo].[DimProduct] p
  ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
  JOIN [Ad works].[dbo].[DimProductCategory] pc
  ON pc.ProductCategoryKey = psc.ProductCategoryKey AND pc.EnglishProductCategoryName = 'Clothing'
  
  /*Add a Col [FactInternetSalesReason]*/
  SELECT * FROM [FactInternetSalesReason]
  
  ALTER TABLE [FactInternetSalesReason]
  ADD [SalesReasonStatus] CHAR(1) 
  
  /*WIth USING WHERE*/
  UPDATE [dbo].[FactInternetSalesReason]
  SET	SalesReasonStatus ='Y'
  WHERE [dbo].[FactInternetSalesReason].SalesReasonKey 
  IN (SELECT [SalesReasonKey]
  FROM [dbo].[DimSalesReason]
  WHERE  [SalesReasonReasonType]='Other')
  
  /*USING JOINs*/
  UPDATE [dbo].[FactInternetSalesReason]
  SET	SalesReasonStatus ='Y'
  FROM [dbo].[FactInternetSalesReason] AS [FISR]
  JOIN [dbo].[DimSalesReason] AS [DSR]
  ON DSR.SalesReasonKey = FISR.SalesReasonKey AND DSR.[SalesReasonReasonType]='Other'
  
  /*Ex12: Contd*/
  SELECT FIS.SalesOrderNumber, FIS.SalesOrderLineNumber, DC.FirstName 
  AS [Customer], DP.EnglishProductName
  FROM [dbo].[FactInternetSales] [FIS]
  LEFT JOIN [dbo].[FactInternetSalesReason] [FISR]
  ON (FIS.SalesOrderNumber = [FISR].SalesOrderNumber 
	AND FIS.SalesOrderLineNumber = [FISR].SalesOrderLineNumber)
  JOIN [dbo].[DimCustomer] [DC]
  ON DC.CustomerKey = FIS.CustomerKey
  JOIN [dbo].[DimProduct] [DP]
  ON DP.ProductKey = FIS.ProductKey
  WHERE [FISR].[SalesReasonKey] IS NULL
    
  /*ALTERNATIVE WAY*/
  SELECT [FIS].[SalesOrderNumber], [FIS].[SalesOrderLineNumber], [DC].[FirstName]
  AS [Customer], [DP].[EnglishProductName]
  FROM [dbo].[FactInternetSales] [FIS]
  LEFT JOIN [dbo].[FactInternetSalesReason] [FISR]
  ON ([FIS].[SalesOrderNumber] = [FISR].[SalesOrderNumber] 
	AND [FIS].[SalesOrderLineNumber] = [FISR].SalesOrderLineNumber)
  JOIN [dbo].[DimCustomer] [DC]
  ON [DC].[CustomerKey] = [FIS].[CustomerKey]
  JOIN [dbo].[DimProduct] [DP]
  ON [DP].[ProductKey] = [FIS].[ProductKey]
  WHERE [FISR].[SalesOrderNumber] IS NULL AND [FISR].[SalesOrderLineNumber] IS NULL
  
  SELECT DISTINCT SalesReasonKey FROM [dbo].[FactInternetSalesReason]
  SELECT DISTINCT SalesOrderNumber FROM [dbo].[FactInternetSalesReason]
  SELECT DISTINCT SalesOrderLineNumber FROM [dbo].[FactInternetSalesReason]
  
  /*DELETING*/
  DELETE FROM [Ad works].[dbo].[FactInternetSalesReason]
  WHERE [SalesReasonKey] IN (
	SELECT [DSR].[SalesReasonKey] 
		FROM [FactInternetSalesReason] [FIRS]
		JOIN [DimSalesReason] [DSR]
		ON FIRS.SalesReasonKey = DSR.SalesReasonKey
		WHERE DSR.SalesReasonName = 'Review'
  )

/*USING DELETE and JOIN together*/
DELETE FIRS FROM [FactInternetSalesReason] [FIRS]
JOIN [DimSalesReason] [DSR]
ON FIRS.SalesReasonKey = DSR.SalesReasonKey
WHERE DSR.SalesReasonName = 'Review'
  
SELECT COUNT(*) FROM DimEmployee
 
/*SELF JOIN EXAMPLE */
SELECT COALESCE(d.FirstName+' '+d.LastName+'--ID: '+CAST(d.EmployeeKey AS VARCHAR(5)),'')
	AS [Employee Details]
	, COALESCE(d1.FirstName+' '+d1.LastName+'--ID: '+CAST(d1.EmployeeKey AS VARCHAR(5)),'') 
	AS [Manager Details]
	 FROM DimEmployee d
JOIN DimEmployee d1
ON d.ParentEmployeeKey = d1.EmployeeKey

/*MORE SELF JOINS*/
SELECT TOP 10 d1.FirstName AS [MANAGER NAME], COUNT(d.EmployeeKey) AS [NUMBER OF EMPLOYEES]
	 FROM DimEmployee d
JOIN DimEmployee d1
ON d.ParentEmployeeKey = d1.EmployeeKey
GROUP BY d1.EmployeeKey,d1.FirstName
ORDER BY COUNT(d.EmployeeKey)DESC, d1.FirstName

/*USING THE RANK FUNCTION*/
SELECT TOP 10 d1.FirstName AS [MANAGER NAME], COUNT(d.EmployeeKey) AS [NUMBER OF EMPLOYEES]
	, RANK() OVER (ORDER BY COUNT(d.EmployeeKey)DESC,d1.FirstName) AS [Rank]
	 FROM DimEmployee d
JOIN DimEmployee d1
ON d.ParentEmployeeKey = d1.EmployeeKey
GROUP BY d1.EmployeeKey,d1.FirstName

/*USING THE LENGTH OF THE MANAGER NAME*/
SELECT TOP 10 d1.FirstName AS [MANAGER NAME], COUNT(d.EmployeeKey) AS [NUMBER OF EMPLOYEES]
	, ROW_NUMBER() OVER (ORDER BY COUNT(d.EmployeeKey)DESC,LEN(d1.FirstName)) AS [Rank]
	 FROM DimEmployee d
JOIN DimEmployee d1
ON d.ParentEmployeeKey = d1.EmployeeKey
GROUP BY d1.EmployeeKey,d1.FirstName

/*USING PARTITION BY in the RANK Function*/
SELECT d1.FirstName AS [MANAGER NAME], COUNT(d.EmployeeKey) AS [NUMBER OF EMPLOYEES]
	, RANK() OVER (PARTITION BY COUNT(d.EmployeeKey) ORDER BY (d1.FirstName)) AS [Rank]
	 FROM DimEmployee d
JOIN DimEmployee d1
ON d.ParentEmployeeKey = d1.EmployeeKey
GROUP BY d1.EmployeeKey,d1.FirstName

SELECT * FROM DimEmployee

SELECT ISNULL(FirstName,'')+' '+ISNULL(MiddleName,'')+' '+ISNULL(LastName,'') 
AS [Full Name]
FROM DimEmployee 

DECLARE @intFLAG INT
SET @intFlag = 1
DECLARE @Name varchar(50)
WHILE(@intFLAG < 11)
BEGIN
	(SELECT @Name =  
	('Emplyee Name :'
	+ISNULL(FirstName,'')
	+' '
	+ISNULL(MiddleName,'')
	+' '
	+ISNULL(LastName,'') )
    FROM [dbo].[DimEmployee] WHERE EmployeeKey = @intFLAG)
    
    PRINT @Name
    SET @intFlag = @intFlag + 1
END
