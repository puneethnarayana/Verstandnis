		DECLARE @tmpTable TABLE 
		(
		[Product_ID]				INT PRIMARY KEY IDENTITY
	,[SKU]						BIGINT
	,[Product_Desc]				VARCHAR(50)
	,[Brand_Segment_Code]		VARCHAR(50)
	,[Brand_Segment_Desc]		VARCHAR(50)
	,[Business_Unit_Code]		INT
	,[Business_Unit_Desc]		VARCHAR(50)
	,[Category_Code]			VARCHAR(50)
	,[Category_Desc]			VARCHAR(50)
	,[Category_Group_Code]		VARCHAR(50)
	,[Category_Group_Desc]		VARCHAR(50)
	,[Division_Code]			CHAR(2)
	,[Division_Desc]			VARCHAR(50)
	,[Segment_Code]				VARCHAR(50)
	,[Segment_Desc]				VARCHAR(50)
	,[Segment_Sub_Group_Code]	VARCHAR(50)
	,[Segment_Sub_Group_Desc]	VARCHAR(50)
	,[Segment_Group_Code]		VARCHAR(50)
	,[Segment_Group_Desc]		VARCHAR(50)
	,[Sector_Code]				VARCHAR(50)
	,[Sector_Desc]				VARCHAR(50)
	,[Sub_Category_Code]		VARCHAR(50)
	,[Sub_Category_Desc]		VARCHAR(50)
		);
		
		INSERT INTO @tmpTable
		SELECT 
			JP.SKU
			,JP.Product_Desc 
			,JBS.Brand_Segment_Code
			,JBS.Brand_Segment_Code
			,JBU.Business_Unit_Code
			,JBU.Business_Unit_Desc
			,SC.CATG_CODE
			,SC.CATG_DESC
			,SCG.CATG_GRP_CODE
			,SCG.CATG_GRP_DESC
			,JDiv.Division_Code
			,JDiv.Division_Desc
			,SS.SEGMT_CODE
			,SS.SEGMT_DESC
			,SSSG.SEGMT_SUB_GRP_CODE
			,SSSG.SEGMT_SUB_GRP_DESC
			,SSG.SEGMT_GRP_CODE
			,SSG.SEGMT_GRP_DESC
			,SSec.SECTOR_CODE
			,SSec.SECTOR_DESC
			,SSC.SUB_CATG_CODE
			,SSC.SUB_CATG_DESC
		FROM 
		[POS Repo].[Staging].[JDE_Product] JP
		JOIN [POS Repo].[Staging].[XREF_Product] XP
		ON JP.SKU = XP.SKU
		JOIN [POS Repo].[Staging].[XREF_Product_BU] XBU
		ON XBU.JDE_Product_Code = JP.JDE_Product_Code
		JOIN [POS Repo].[Staging].[JDE_Business_Unit] JBU
		ON JBU.Business_Unit_Code = XBU.Business_Unit_Code
		JOIN [POS Repo].[Staging].[Business_Unit] SBU
		ON SBU.BUSS_UNIT_CODE = CAST( JBU.Business_Unit_Code AS VARCHAR(50))
		JOIN [POS Repo].[Staging].[Segment] SS
		ON SS.SEGMT_KEY = SBU.SEGMT_KEY
		JOIN [POS Repo].[Staging].[Segment_Sub_group] SSSG
		ON SSSG.SEGMT_SUB_GRP_KEY = SS.SEGMT_SUB_GRP_KEY
		JOIN [POS Repo].[Staging].[Segment_group] SSG
		ON SSG.SEGMT_GRP_KEY = SSSG.SEGMT_GRP_KEY
		JOIN [POS Repo].[Staging].[Sub_Category] SSC
		ON SSC.SUB_CATG_KEY = SSG.SUB_CATG_KEY
		JOIN [POS Repo].[Staging].[Category] SC
		ON SC.CATG_GRP_KEY = SSC.CATG_KEY
		JOIN [POS Repo].[Staging].[Category_Group] SCG 
		ON SCG.CATG_GRP_KEY = SC.CATG_GRP_KEY
		JOIN [POS Repo].[Staging].[Sector] SSec
		ON SSec.SECTOR_KEY = SCG.SECTOR_KEY
		JOIN [POS Repo].[Staging].[XREF_BU_BS_Division] XDiv
		ON CAST(XDiv.Business_Unit_Code AS VARCHAR(50)) = SBU.BUSS_UNIT_CODE
		JOIN [POS Repo].[Staging].[JDE_Brand_Segment] JBS
		ON JBS.Brand_Segment_Code = XDiv.Brand_Segment_Code
		JOIN [POS Repo].[Staging].[JDE_Division] JDiv
		ON JDiv.Division_Code = XDiv.Division_Code
		
		/*
		LEFT JOIN [POS Repo].[Staging].[Category_Strategic] Strat
		ON Strat.CATG_STRATEGIC_DIR_KEY = SC.CATG_KEY
		*/
		SELECT COUNT(*) FROM @tmpTable
		
		SELECT * FROM @tmpTable tt
		JOIN [POS Repo].Staging.Category_Strategic cs
		ON tt.Category_Code = cs.CATG_STRATEGIC_DIR_CODE
		
			