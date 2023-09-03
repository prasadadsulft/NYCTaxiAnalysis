CREATE TABLE dbo.Dim_RateCodes
WITH
	(
	DISTRIBUTION = REPLICATE,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
AS

SELECT ROW_NUMBER() OVER(ORDER BY RateCodeId) AS RateCodeID,
    RateCodeId AS RatecodeIDAlternate,
	RateCode,
	IsApproved
FROM 
dbo.RateCodes;

SELECT * FROM dbo.Dim_RateCodes