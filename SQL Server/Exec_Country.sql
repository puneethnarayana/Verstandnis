DECLARE @RC int
DECLARE @country_Code varchar(30)
DECLARE @country_Desc varchar(30)
--SET @country_Code 

-- TODO: Set parameter values here.

EXECUTE @RC = [TrainingDB].[dbo].[usp_load_country] 
   @country_Code = 'FR'
  ,@country_Desc = 'France'
GO


