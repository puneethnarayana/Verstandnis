ALTER TABLE [Fact_Sales]
ADD [Created_Date] DATETIME

ALTER TABLE [Fact_Sales]
ADD [Updated_Date] DATETIME

INSERT INTO Fact_Sales
(
	[Sales_Volume]
)
VALUES
(
	8
)

UPDATE Fact_Sales
SET [Updated_Date] = GETDATE()
WHERE [Sales_Volume] = 512


SELECT  FirstName as [Employee Name], [1] as [Q1],[2] as [Q2], [3] as [Q3], [4] as [Q4]
FROM 
(SELECT e.FirstName, t.CalendarQuarter AS quarter, SUM(SalesAmountQuota) AS salesquota
FROM FactSalesQuota f
INNER JOIN [dbo].[DimDate] t
ON t.[DateKey] = f.[DateKey]
INNER JOIN [dbo].[DimEmployee] e
ON e.EmployeeKey = f.EmployeeKey
WHERE t.CalendarYear = 2006
GROUP BY  e.FirstName, t.CalendarQuarter
) s
PIVOT
(
SUM (salesquota)
FOR quarter IN
([1],[2],[3],[4])
) AS pvt
ORDER BY pvt.FirstName;

/****************************************/
DECLARE @num nvarchar(4)
DECLARE @input nvarchar(4)
DECLARE @col nvarchar(25)
DECLARE @inputcol nvarchar(25)

DECLARE @SQLString nvarchar(500)

SET @inputcol = 'SalesTerritoryKey';
SET @input = '5';

SET @col = @inputcol
SET @num = @input 

SET @SQLString = N' SELECT TOP '+ @num +' e.FirstName, e.LastName,'+ @col+'
FROM DimEmployee e'

EXECUTE sp_executesql @SQLString
/*****************************************/

, @num=@input, @col=@inputcol;

CREATE FUNCTION fn_get_last_date
RETURNS scalar_return_data_type
AS
BEGIN
     FN_BODY
     RETURN SCALAR_EXPR    
END

CREATE FUNCTION ufn_getlastdate (@DATE datetime)
RETURNS int
AS BEGIN

CREATE FUNCTION [dbo].[udf_GetLastDayOfMonth] 
(
    @Date DATETIME
)
RETURNS DATETIME
AS
BEGIN

    RETURN DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @Date) + 1, 0))

END

SELECT [dbo].[udf_GetLastDayOfMonth](GETDATE());

SELECT DATEDIFF(m, 0, GETDATE())
SELECT DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)