CREATE TABLE [dbo].[ProductType]
(
	[ProductTypeId] INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductType PRIMARY KEY CLUSTERED,
	ProductTypeCode VARCHAR(30) NOT NULL CONSTRAINT UQ_ProductType_ProductTypeCode UNIQUE,
	ProductTypeDescription VARCHAR(1000) NULL
)
