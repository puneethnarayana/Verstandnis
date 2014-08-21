

/* Test case 1: Run the queries below */
UPDATE [stage].[source_dim_product]
SET	[available_in_market] = 'Y'
WHERE [product_code] = 'D003'

UPDATE [stage].[source_dim_product]
SET	  [product_size] = 'Small'
	, [product_colour_code] = 'W'
	, [product_colour_desc] = 'White'
WHERE [product_code] = 'A001'

INSERT INTO [stage].[source_dim_product]
	( [product_code], [product_desc], [product_colour_code], [product_colour_desc], [product_size], [available_in_market] )
VALUES 
	  ( 'R001', 'Rexona basic', 'B', 'Blue', 'Small','Y')
	, ( 'R002', 'Rexona ultra', 'G', 'Green', 'XL','N')