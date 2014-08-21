ALTER TRIGGER [trg_insert_update_dates]
ON [dbo].[Fact_Sales]
FOR INSERT,UPDATE

AS
BEGIN
	IF( (SELECT COUNT(*) FROM inserted) > 0
	AND  (SELECT COUNT(*) FROM deleted) = 0)
	BEGIN
	IF( UPDATE([City_ID]) OR UPDATE([Product_ID]) OR UPDATE([Time_ID]) OR UPDATE(Sales_Volume) ) 
	BEGIN
	UPDATE [dbo].[Fact_Sales] 
	SET [Created_Date] = GETDATE()
	FROM [dbo].[Fact_Sales] [FS]
	JOIN [inserted] [I]
	ON [FS].[Fact_Sales_ID] = [I].[Fact_Sales_ID]
	END
	END
	--WHERE [dbo].[Fact_Sales].[Fact_Sales_ID] = [inserted].[Fact_Sales_ID]
	IF( (SELECT COUNT(*) FROM inserted) > 0
	AND  (SELECT COUNT(*) FROM deleted) > 0)
	BEGIN
	IF( UPDATE([City_ID]) OR UPDATE([Product_ID]) OR UPDATE([Time_ID]) OR UPDATE(Sales_Volume) ) 
	BEGIN
	UPDATE [dbo].[Fact_Sales]
	SET [Updated_Date] = GETDATE()
	FROM [dbo].[Fact_Sales] [FS]
	JOIN [inserted] [I]
	ON [FS].[Fact_Sales_ID] = [I].[Fact_Sales_ID]
	END
	END
END
GO