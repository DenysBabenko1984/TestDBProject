;MERGE dbo.City as T
USING (VALUES
			('US',	'NY',	'00123345', 'New York'),
			('US',	'MA',	'00123678', 'Boston'),
			('US',	'CA',	'00123009', 'San Jose')
		) as S(CountryCode, State, PostalCode, CityName)
ON T.CountryCode = S.CountryCode AND s.PostalCode = T.PostalCode
WHEN NOT MATCHED THEN
	INSERT (CountryCode, State, PostalCode, CityName)
	VALUES (CountryCode, State, PostalCode, CityName)
WHEN MATCHED THEN
	UPDATE SET
		T.CityName = S.CityName
		,t.State = s.State
;
			