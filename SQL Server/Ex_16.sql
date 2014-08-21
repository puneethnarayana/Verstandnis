USE[Ad Works]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_load_fact_finance]
AS
BEGIN TRY

	BEGIN TRANSACTION 
	
	/*
	DELETE FROM [dbo].[FactFinance]
	WHERE [DateKey] 
	IN 
		(
		SELECT DISTINCT CONVERT(VARCHAR(20),[SFF].[Date],112) 
		FROM [dbo].[stage_fact_finance] [SFF]
		)
		*/
	
	DELETE [FF] FROM [dbo].[FactFinance] [FF]
	JOIN [dbo].[stage_fact_finance] [SFF]
	ON CONVERT(VARCHAR(20),[SFF].[Date],112) = [FF].[DateKey]
	
	--WHERE [DateKey] =  CONVERT(VARCHAR(20),[SFF].[Date],112) 
	
	INSERT INTO [dbo].[FactFinance]
	(
		[DateKey]
      ,[OrganizationKey]
      ,[DepartmentGroupKey]
      ,[ScenarioKey]
      ,[AccountKey]
      ,[Amount]	
	)
	SELECT CONVERT(VARCHAR(20),[SFF].[Date],112)
		,[DO].[OrganizationKey]
		,[DDG].[DepartmentGroupKey]
		,[DS].[ScenarioKey]
		,[DA].[AccountKey]
		,[SFF].[Amount]
	FROM [Ad works].[dbo].[stage_fact_finance] [SFF]
	JOIN [dbo].[DimOrganization] [DO]
	ON [SFF].[Organization_Name] = [DO].[OrganizationName]
	JOIN [dbo].[DimDepartmentGroup] [DDG]
	ON [SFF].[Department_Group_Name] = [DDG].[DepartmentGroupName]
	JOIN [dbo].[DimScenario] [DS]
	ON [SFF].[Scenario_Name] = [DS].[ScenarioName]
	JOIN [dbo].[DimAccount] [DA]
	ON [SFF].[Account_Description] = [DA].[AccountDescription]
	--JOIN [dbo].[FactFinance] [FF]
	--ON CONVERT(VARCHAR(20),[SFF].[Date],112) = [FF].[DateKey]
	--WHERE  CONVERT(VARCHAR(20),[SFF].[Date],112) NOT IN (SELECT DISTINCT [DateKey] FROM [dbo].[FactFinance])

COMMIT TRANSACTION

END TRY

BEGIN CATCH

	ROLLBACK TRANSACTION

END CATCH

--SELECT CONVERT(VARCHAR(20),GETDATE(),112)