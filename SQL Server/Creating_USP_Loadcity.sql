USE [TrainingDB]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_load_city]

AS 
BEGIN

BEGIN
UPDATE [TrainingDB].[dbo].[Dim_City] 
SET [country_id] = [DC].[country_id]
FROM [TrainingDB].[dbo].[Dim_City] [DCity]
JOIN  [TrainingDB].[stage].[source_city_country_mapping] [SCCM]
ON [DCity].[City_Code] = [SCCM].[city_code]
JOIN [TrainingDB].[dbo].[dim_country] [DC] 
ON [SCCM].[country_code] = [DC].[country_code]
WHERE [DCity].[country_id] IS NULL AND [SCCM].[country_code] = [DC].[country_code]
END

BEGIN
INSERT INTO [TrainingDB].[dbo].[Dim_City]
(
	[City_Code]
	,[City_Name]
) 
SELECT [SCCM].[city_code],[SCCM].[city_code]
FROM [TrainingDB].[stage].[source_city_country_mapping] [SCCM]
LEFT JOIN [TrainingDB].[dbo].[Dim_City] [DCity]
ON [DCity].[City_Code] = [SCCM].[city_code]
WHERE [SCCM].[city_code] IS NOT NULL 
AND [DCity].[City_Code] IS NULL 
END

END
GO