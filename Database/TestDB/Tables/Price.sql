CREATE TABLE [dbo].[Price]
(
	[PriceId] INT IDENTITY(1,1) NOT NULL CONSTRAINT UQ_Price_PriceId UNIQUE ,  -- This will create unique non clustered index
	StoreId INT NOT NULL CONSTRAINT FK_Price_Store_StoreId REFERENCES dbo.Store(StoreId),
	ProductId INT NOT NULL CONSTRAINT FK_Price_ProductId REFERENCES dbo.Product(ProductId),
	PriceValue [utMoney] NOT NULL CONSTRAINT DF_Price_PriceValue DEFAULT(0), -- Informaticaa and QV support only 16 significant digits.  (20,4) requires 4 more bytes per value comparing to (19,4)
																			     -- Don't change to MONEY. MONEY type is legacy and has rounding error issue.
	[UpdatedBy] VARCHAR(50) NOT NULL CONSTRAINT DF_Price_UpdatedBy DEFAULT (SUSER_SNAME()), 
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT DF_Price_UpdatedDate DEFAULT (GETUTCDATE()), 
    
	CONSTRAINT [PK_Price]  PRIMARY KEY CLUSTERED (StoreId, ProductId) -- Primary KEY clustered index
, 
    CONSTRAINT [CK_Price_PriceValue] CHECK (PriceValue >= 0)) -- Price could not be negative
