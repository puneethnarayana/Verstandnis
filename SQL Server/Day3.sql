ALTER TABLE [dbo].[Dim_Time]
ADD [Quarter_Name] Varchar(5)

SELECT * FROM [dbo].[Dim_Time]

DELETE FROM [Dim_Time]
WHERE Time_ID = 15

DECLARE @intMonth

UPDATE [dbo].[Dim_Time]
SET [Quarter_Name] = CASE	
					WHEN [Cal_Mon_ID] IN (1,2,3)
					THEN 'Q1'
					WHEN [Cal_Mon_ID] IN (4,5,6)
					THEN 'Q2'
					WHEN [Cal_Mon_ID] IN (7,8,9)
					THEN 'Q3'
					WHEN [Cal_Mon_ID] IN (10,11,12)
					THEN 'Q4'
					END
					
DECLARE @RC int

-- TODO: Set parameter values here.

EXECUTE @RC = [TrainingDB].[dbo].[usp_Update_Dim_Product] 
GO
