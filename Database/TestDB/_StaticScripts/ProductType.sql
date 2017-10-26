;MERGE dbo.ProductType as T
USING (VALUES
			('Book',		'Paper books'),
			('Toys',		'Toys'),
			('Clothes',		'Clothes')
		) as S(ProductTypeCode, ProductTypeDescription)
ON T.ProductTypeCode = S.ProductTypeCode
WHEN NOT MATCHED THEN
	INSERT (ProductTypeCode, ProductTypeDescription)
	VALUES (ProductTypeCode, ProductTypeDescription)
WHEN MATCHED THEN
	UPDATE SET
		T.ProductTypeDescription = S.ProductTypeDescription
;
			