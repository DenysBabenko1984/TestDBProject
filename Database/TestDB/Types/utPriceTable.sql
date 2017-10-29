CREATE TYPE [dbo].[utPriceTable] AS TABLE
(
	RowId INT IDENTITY(1,1),
	PriceId	INT NULL,
	StoreId INT NOT NULL, 
	ProductId INT NOT NULL,
	PriceValue utMoney NOT NULL
)
