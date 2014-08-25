/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [CATG_KEY]
  
      ,[CATG_CODE]
      ,[CATG_DESC]
     
      ,[CATG_GRP_KEY]
  FROM [POS Repo].[Staging].[Category] c
  JOIN [POS Repo].Staging.Category_Strategic cs
  ON c.CATG_KEY = cs.CATG_STRATEGIC_DIR_KEY