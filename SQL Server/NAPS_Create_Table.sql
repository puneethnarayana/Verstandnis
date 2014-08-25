/*THIS Script creates tables required in the POS Live DB*/
/*		Follows Technical Specs in the document:
		POS Insights Tech Spec v12_SQL
		Author: Puneeth 
		Date: 22nd August 2012
 */

/*1. Creates the table "tbl_Source" */

CREATE TABLE [POS_live].[dbo].[tbl_Source]
(
	[Source_ID]			INT
	,[Source_Desc]		VARCHAR(25)
	,[Week_Loaded_For]	VARCHAR(25)
)

ALTER TABLE [POS_Live].[dbo].[tbl_Source]
ALTER COLUMN [Source_ID] INT NOT NULL

ALTER TABLE [POS_Live].[dbo].[tbl_Source]
ADD CONSTRAINT PK__tbl_Source PRIMARY KEY (Source_ID)

/*2. Creates table "tbl_settings"*/

CREATE TABLE [POS_live].[dbo].[tbl_settings]
(
	 [Setting_ID]		INT
	,[Setting_Name]		VARCHAR(50)
	,[Setting_Value]	VARCHAR(255)
	,[Setting_Desc]		VARCHAR(255)
)

/*3. Creates table "tbl_lookup_file_load_history"*/
/*	Stores all information regarding 
	the data files that have been loaded*/
	
CREATE TABLE [POS_live].[dbo].[tbl_lookup_file_load_history]
(
	 [File_Load_History_ID]			INT
	,[Load_Date]					SMALLDATETIME
	,[Source_Key]					TINYINT
	,[File_Desc]					VARCHAR(50)
	,[Load_ID]						INT
	,[File_Size]					VARCHAR(10)
	,[Total_Records_Source]			INT
	,[Customers_Source]				INT
	,[Products_Source]				INT
	,[Total_Volume_Source]			INT
	,[Total_Retail_Value_Source]	DECIMAL(18,2) 
	,[Total_Records_Checking]		INT
	,[Cusomters_Checking]			INT
	,[Products_Checking]			INT
	,[Total_Volume_Checking]		INT
	,[Total_Retail_Value_Checking]	DECIMAL(18,2)
	,[Week_Key]						INT
)

/*4. Creates table "dbo.dim_time" */
/* Time Dimension table is used as a source for the time dimension views
*  which are in turn used to form the cube dimension: Time
*	ALREADY CREATED
*	[Mart].[Tbl_Dim_Time]
*/

--CREATE TABLE [POS_Live].[dbo].[dim_time]

ALTER TABLE [Mart].[Tbl_Dim_Time]
ADD CONSTRAINT PK__Tbl_Dim_Time__Time_ID PRIMARY KEY(Time_ID)

/*5. Creates Table "dbo.dim_product"*/
/*	Used as source to build a product view
*	Product view in turn used to build the product cube
*	
*/

CREATE TABLE [POS_Live].[Mart].[dim_product]
(
   	[Product_ID]				INT PRIMARY KEY IDENTITY
	,[SKU]						BIGINT
	,[Product_Desc]				VARCHAR(50)
	,[Brand_Code]				VARCHAR(50)
	,[Brand_Desc]				VARCHAR(50)
	,[Brand_Group_Code]			VARCHAR(50)
	,[Brand_Group_Desc]			VARCHAR(50)
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
	,[Key_Item_Flag]			SMALLINT
	,[Active_Status]			INT
	,[Has_Data]					SMALLINT
	,[created_by]				VARCHAR(50)
	,[created_date]				DATETIME
	,[updated_by]				VARCHAR(50)
	,[updated_date]				DATETIME
)

/*6. Creates Table "dbo.dim_customer" ALREADY DONE
	[Mart].[Tbl_Dim_Customer]
*/

ALTER TABLE [Mart].[Tbl_Dim_Customer]
ADD CONSTRAINT PK__Tbl_Dim_Customer__Customer_ID PRIMARY KEY(Customer_ID)

/*7. Creates Table "dbo.tbl_fact_pos"*/

CREATE TABLE [POS_Live].[dbo].[tbl_fact_pos]
(
	 [Source_ID]		INT
	,[POS_Year_ID]		SMALLINT
	,[POS_Time_ID]		INT
	,[POS_Customer_ID]	INT
	,[POS_Product_ID]	INT
	,[POS_Retail_Value] MONEY
	,[POS_Volume_Unit]	INT
	,[load_log_id]		INT 
)

ALTER TABLE [POS_Live].[dbo].[tbl_fact_pos]
ADD CONSTRAINT FK__tbl_fact_pos__tbl_Source__Source_ID
FOREIGN KEY ([Source_ID])
REFERENCES [dbo].[tbl_Source]([Source_ID])

ALTER TABLE [POS_Live].[dbo].[tbl_fact_pos]
ADD CONSTRAINT FK__tbl_fact_pos__Tbl_Dim_Customer__Customer_ID
FOREIGN KEY ([POS_Customer_ID])
REFERENCES [Mart].[Tbl_Dim_Time]([Time_ID])

ALTER TABLE [POS_Live].[dbo].[tbl_fact_pos]
ADD CONSTRAINT FK__tbl_fact_pos__Tbl_Dim_Time__Time_ID
FOREIGN KEY ([POS_Time_ID])
REFERENCES [Mart].[Tbl_Dim_Time]([Time_ID])

ALTER TABLE [POS_Live].[dbo].[tbl_fact_pos]
ADD CONSTRAINT FK__tbl_fact_pos__dim_product__Product_ID
FOREIGN KEY ([POS_Product_ID])
REFERENCES [Mart].[dim_product]([Product_ID])

ALTER TABLE [POS_Live].[dbo].[tbl_fact_pos]
ADD CONSTRAINT FK__tbl_fact_pos__load_log__load_log_ID
FOREIGN KEY ([load_log_ID])
REFERENCES [logging].[load_log]([load_log_id])

/*8. Creates Table "dbo.tbl_fact_pos_exceptions"*/

CREATE TABLE [POS_Live].[dbo].[tbl_fact_pos_exceptions]
(
	 [Source_Id]		INT
	,[Source_Customer]	VARCHAR(100)
	,[Source_Product]	VARCHAR(100)
	,[Source_Date]		INT
	,[Source_Volume]	INT
	,[Source_Value]		MONEY
	,[Exception_Desc]	VARCHAR(25)
	,[load_lod_id]		INT
)

/*9. Creates Table "logging.load_log"*/

CREATE TABLE [POS_Live].[logging].[load_log]
(
	 [load_log_id]		INT
	,[load_desc]		VARCHAR(200)
	,[Load_start_time]	DATETIME
	,[Load_end_time]	DATETIME
	,[Package_Desc]		VARCHAR(200)
	,[Running_user]		VARCHAR(50)	
	,[Load_status]		CHAR(1) CHECK ([Load_status] IN ('R','S','F'))
)

ALTER TABLE [logging].[load_log]
ALTER COLUMN [load_log_id]INT NOT NULL


ALTER TABLE [logging].[load_log]
ADD CONSTRAINT PK__load_log__load_log_id PRIMARY KEY(load_log_id)

/*10. Creates Table "logging.load_detail_log"*/

CREATE TABLE [POS_Live].[logging].[load_detail_log]
(
	 [Load_ID]			INT
	,[Detail_Load_ID]	INT
	,[Step_no]			INT
	,[Detail_log_Desc]	VARCHAR(100)
	,[Detail_Log_Time]	DATE
	,[Running_User]		VARCHAR(50)
	,[Parent_Name]		VARCHAR(50)
	,[Status_Code]		CHAR(1) CHECK ([Status_Code] IN ('S','F'))
	,[Error_Code]		BIGINT	
	,[Error_Desc]		VARCHAR(200)
	,[Rows_Affected]	INT
)



