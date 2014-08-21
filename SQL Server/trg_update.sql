ALTER TRIGGER [trg_updatedates]
ON [dbo].[Fact_Sales]
FOR UPDATE
AS
BEGIN
	IF( (SELECT COUNT(*) FROM inserted) > 0
	AND  (SELECT COUNT(*) FROM deleted) > 0)
	BEGIN
	UPDATE [dbo].[Fact_Sales]
	SET [Updated_Date] = GETDATE()
	FROM [dbo].[Fact_Sales] [FS]
	JOIN [inserted] [I]
	ON [FS].[Fact_Sales_ID] = [I].[Fact_Sales_ID]
	END
END
GO
