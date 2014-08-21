USE [TrainingDB]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_load_city_v3]

AS 
BEGIN

IF EXISTS (SELECT * FROM sysobjects WHERE name  = 'ARCHIVE')
BEGIN
DROP TABLE ARCHIVE
END

--SELECT * FROM sysobjects WHERE name  = 'ARCHIVE'

CREATE TABLE ARCHIVE
(
	[actions] varchar(10)
	
	,[City_ID] int
	,[City_Code] varchar(15)
	,[City_Name] varchar(15)
	,[Population_Type] varchar(20)
	,[country_id] int
	
	,[D_City_ID] int
	,[D_City_Code] varchar(15)
	,[D_City_Name] varchar(15)
	,[D_Population_Type] varchar(20)
	,[D_country_id] int


)

MERGE [dbo].[Dim_City] [DCity]
USING
(
SELECT [SCCM].[city_code]
,[SCCM].[city_name]
,[SCCM].[Country_Code]
,[DC].[country_id]
FROM [TrainingDB].[stage].[source_city_country_mapping] [SCCM]
JOIN [TrainingDB].[dbo].[dim_country] [DC] 
ON [SCCM].[country_code] = [DC].[country_code]
) AS J

ON (J.city_code = [DCity].city_code)

WHEN MATCHED AND (DCity.[city_name] <> J.[city_name]
OR	ISNULL([DCity].[country_id],'') <> ISNULL(J.[country_id],0))
THEN UPDATE
	SET [DCity].[city_name] = [J].[city_name]
	, [DCity].[country_id] = J.country_id
	
WHEN NOT MATCHED 
THEN INSERT(
	[City_Code]
	,[City_Name]
)
VALUES 
(
	J.[city_code]
	,J.[city_name]
)

OUTPUT $action, inserted.*,deleted.* INTO dbo.ARCHIVE
;

PRINT @@ROWCOUNT
END
GO