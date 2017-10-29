CREATE TABLE [dbo].[City]
(
	[CityId] INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_City_CityId PRIMARY KEY,
	State CHAR(2) NOT NULL, 
	CountryCode CHAR(2) NOT NULL CONSTRAINT FK_City_Country REFERENCES dbo.Country(CountryCode),
	PostalCode VARCHAR(10) NOT NULL, -- Canada and GB have non numeric postal codes
	CityName VARCHAR(255) NOT NULL
)

GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_City_CountryCode_PostalCode] ON [dbo].[City] (CountryCode, PostalCode)
