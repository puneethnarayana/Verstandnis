USE [TrainingDB]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_load_country]
(
	@country_Code VARCHAR(30) ,
	@country_Desc VARCHAR(30) 	
) 
AS 
BEGIN

IF(@country_Code IS NOT NULL AND @country_Desc IS NOT NULL)
BEGIN
INSERT INTO [TrainingDB].[dbo].[dim_country]
(
	[country_code]
	,[country_desc]
) 
VALUES
(
	@country_Code
	,@country_Desc
)
END

ELSE
BEGIN

INSERT INTO [TrainingDB].[dbo].[dim_country]
(
	[country_code]
	,[country_desc]
) 
SELECT DISTINCT [SCCM].[country_code], [SCCM].[country_desc]
FROM [TrainingDB].[stage].[source_city_country_mapping] [SCCM]
LEFT JOIN [TrainingDB].[dbo].[dim_country] [DC]
ON [DC].[country_code] = [SCCM].[country_code]
WHERE [SCCM].[country_code] IS NOT NULL 
AND [DC].[country_code] IS NULL
END


END
GO