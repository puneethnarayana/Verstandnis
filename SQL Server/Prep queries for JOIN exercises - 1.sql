/* Creating table dim_product_colour */
CREATE TABLE [dim_product_colour]
(	  [product_colour_id]	INT PRIMARY KEY IDENTITY(1,1)
	, [product_colour_code] VARCHAR(30) UNIQUE NOT NULL
	, [product_colour_desc]	VARCHAR(30) 
)

-- Creating table dim_product_size
CREATE TABLE [dim_product_size]
(	  [product_size_id]	INT PRIMARY KEY IDENTITY(1,1)
	, [product_size_desc]	VARCHAR(30) 
)

/*Creating schema stage */
CREATE SCHEMA [stage]

/* Creating stage table for product */
CREATE TABLE [stage].[source_dim_product]
(
	  [product_code] VARCHAR(30) 
	, [product_desc] VARCHAR(30) 
	, [product_colour_code] VARCHAR(30)
	, [product_colour_desc]	VARCHAR(30) 
	, [product_size] VARCHAR(30)
	, [available_in_market] CHAR(1)
)

/* Add new columns to the [dim_product] table */
ALTER TABLE [dim_product]
ADD	[product_code] VARCHAR(30) 

ALTER TABLE [dim_product]
ADD	[product_colour_id] INT 

ALTER TABLE [dim_product]
ADD	[product_size_id] INT

ALTER TABLE [dim_product]
ADD	[available_in_market] CHAR(1)

/* Add constraints for new columns in the [dim_product] table */
ALTER TABLE [dim_product]
ADD CONSTRAINT [fk_dim_product_product_colour_id_dim_product_colour_product_colour_id] 
FOREIGN KEY ([product_colour_id])
REFERENCES [dim_product_colour] ([product_colour_id])

ALTER TABLE [dim_product]
ADD CONSTRAINT [fk_dim_product_product_size_id_dim_product_size_product_size_id] 
FOREIGN KEY ([product_size_id])
REFERENCES [dim_product_size] ([product_size_id])

/* Inserting rows fdor stage.source_dim_product */
INSERT INTO [stage].[source_dim_product]
	( [product_code], [product_desc], [product_colour_code], [product_colour_desc], [product_size], [available_in_market] )
VALUES 
	  ( 'A001', 'Axe', 'R', 'Red', 'Large','Y')
	, ( 'A002', 'Axe mini', 'R', 'Red', 'Small','Y')
	, ( 'A003', 'Axe sensation', 'B', 'Blue', 'Medium','Y')
	, ( 'A104', 'Axe formula', 'V', 'Violet', 'XL','Y')
	, ( 'D001', 'Dove', 'W', 'White', 'Medium','Y')
	, ( 'D002', 'Dove extra', 'W', 'White', 'Large','Y')
	, ( 'D003', 'Dove natural', 'G', 'Green', 'XS','N')


INSERT INTO [stage].[source_dim_product]
	( [product_code], [product_desc], [product_colour_code], [product_colour_desc], [product_size], [available_in_market] )
VALUES 
	( 'A001', 'Axe Raaks', 'R', 'Red', 'Small','Y')
	
INSERT INTO [dbo].[Dim_Product]
	( [product_code], [product_name] )
VALUES 
	( 'A001', 'Axe Rocks')