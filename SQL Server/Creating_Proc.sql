USE [TrainingDB]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_Update_Dim_Product]
AS 
BEGIN
 
/*----------Updated the product color table-------------*/
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

/*----Updates the product Size table-----*/
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

/*Update Dim Product*/
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

/*inserting new members*/
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

/--DELETING N -/
DELETE FROM [Dim_Product] 
FROM [Dim_Product] [DP]
JOIN [TrainingDB].[stage].[source_dim_product] [SDP]
ON [SDP].[product_code] = [DP].[product_code]
WHERE [SDP].[available_in_market] = 'N'
 
END
GO