USE [Ad works]
GO

/****** Object:  StoredProcedure [dbo].[usp_load_fact_finance]    Script Date: 08/21/2014 10:52:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[usp_load_fact_finance]
AS
/*************************************************************************************************************************************************************************
* Name			:	usp_load_fact_finance
* Purpose		:	This stored procedure updates the FactFinance with data based on Stage_fact_finance
* Method		:	a. 	This stored procedure first identifies the date instances which are common between the stage_fact_finance and FactFinance and deletes 
						the matching records from the FactFinance table.
*				:	   
*				:	b.  Then it inserts all the values from stage_fact_finance into FactFinance. Which are all unique in their timestamp.
*				
*				:
* Input Params	:	None
* Output Params	:	None                                     
* Versions		:	No	Author			Date			    Comments
*				:   --  ------          ----                --------
*				:	0	Puneeth		21-August-2012		Original version.
*
**************************************************************************************************************************************************************************/
BEGIN TRY

	--Begin Transaction
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
	
	/**
	 * STEP 1
	 * This stored procedure first identifies the date instances which are common between 
	 * the stage_fact_finance and FactFinance and deletes 
	 * the matching records from the FactFinance table.
	 */
	 
	DELETE [FF] FROM [dbo].[FactFinance] [FF]
	JOIN [dbo].[stage_fact_finance] [SFF]
	ON CONVERT(VARCHAR(20),[SFF].[Date],112) = [FF].[DateKey]
	
	--WHERE [DateKey] =  CONVERT(VARCHAR(20),[SFF].[Date],112) 
	--select 1/0
	
	/**
	 * STEP 2
	 *
	 * Then it inserts all the values from stage_fact_finance into FactFinance. 
	 * Which are all unique in their timestamp..
	 */
		
	INSERT INTO [dbo].[FactFinance]
	(
		[DateKey]
      ,[OrganizationKey]
      ,[DepartmentGroupKey]
      ,[ScenarioKey]
      ,[AccountKey]
      ,[Amount]	
	)
	SELECT 
	CONVERT(VARCHAR(20),[SFF].[Date],112)
	--[SFF].[Date]
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
	SELECT ERROR_MESSAGE()
	-- Rollback transaction so that no changes are made to the database.
	ROLLBACK TRANSACTION
    PRINT 'ROLLBACK'
END CATCH

--SELECT CONVERT(VARCHAR(20),GETDATE(),112)
GO