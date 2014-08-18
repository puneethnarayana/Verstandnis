CREATE TABLE [dbo].[Dim_Product]
(
	[Product_ID] INT IDENTITY PRIMARY KEY
  ,	[Product_Code] Varchar(20)UNIQUE NOT NULL
  , [Product_Name] Varchar(20) NOT NULL
)

--DROP TABLE [dbo].[Dim_Product]