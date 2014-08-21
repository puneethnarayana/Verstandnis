/* Add constraints for new columns in the [dim_geography] table */
ALTER TABLE [dim_geography]
ADD CONSTRAINT [fk_dim_geography_country_id_dim_geography_country_country_id] 
FOREIGN KEY ([country_id])
REFERENCES [dim_geography_country] ([country_id])

/* Scripts for exercise 2 */

ALTER TABLE [stage].[source_city_country_mapping]
ADD [city_name] VARCHAR(30)
	
TRUNCATE TABLE [stage].[source_city_country_mapping]

INSERT INTO [stage].[source_city_country_mapping]
	([city_code], [city_name], [country_code],[country_desc])
VALUES
	  ('LUS', 'Lussane', 'SUI','Switzerland') -- Changed country mapping.
	  -- Removed entry for bangalore.
	, ('LDN', 'London2', 'UK','United Kingdom') -- Changed city description
	, ('NY',  'New York', 'USA','United States')
	, ('DEL', 'Delhi', 'IND','India')
	, ('BRI', 'Bristol', 'UK','United Kingdom')
	, ('HYD', 'Hyderabad', 'IND','India') -- New entry for hyderabad.
