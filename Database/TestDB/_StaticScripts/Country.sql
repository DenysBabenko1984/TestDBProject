;MERGE dbo.Country as T
USING (VALUES
			('US',		'United States of America'),
			('GE',		'Geormany'),
			('FR',		'France')
		) as S(CountryCode, CountryName)
ON T.CountryCode = S.CountryName
WHEN NOT MATCHED THEN
	INSERT (CountryCode, CountryName)
	VALUES (CountryCode, CountryName)
WHEN MATCHED THEN
	UPDATE SET
		T.CountryName = S.CountryName
;
			