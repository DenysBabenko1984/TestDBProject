CREATE TABLE [dbo].[Product]
(
	[ProductId] INT IDENTITY(1,1) CONSTRAINT PK_Product NOT NULL PRIMARY KEY CLUSTERED,
	ProductTypeId INT NOT NULL CONSTRAINT FK_Product_ProductType_ProductTypeId FOREIGN KEY REFERENCES dbo.ProductType (ProductTypeId),
	ProductName VARCHAR(1000) NOT NULL, 
    [UpdatedBy] VARCHAR(50) NOT NULL CONSTRAINT DF_Product_UpdatedBy DEFAULT (SUSER_SNAME()), 
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT DF_Product_UpdatedDate DEFAULT (GETUTCDATE())
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Product_ProductTypeId_ProductName] ON [dbo].[Product] (ProductTypeId, ProductName)
GO
CREATE NONCLUSTERED INDEX [IX_Product_ProductName] ON [dbo].[Product] (ProductName)
GO