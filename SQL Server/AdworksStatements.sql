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

