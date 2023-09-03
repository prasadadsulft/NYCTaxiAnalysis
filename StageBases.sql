IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'StageBases' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.StageBases
	(
	 [BaseLicenseId] nvarchar(4000),
	 [BaseType] nvarchar(4000),
	 [AddressBuilding] nvarchar(4000),
	 [AddressStreet] nvarchar(4000),
	 [AddressCity] nvarchar(4000),
	 [AddressState] nvarchar(4000),
	 [AddressPostalCode] bigint
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_StageBases
--AS
--BEGIN
COPY INTO dbo.StageBases
(BaseLicenseId 1, BaseType 2, AddressBuilding 3, AddressStreet 4, AddressCity 5, AddressState 6, AddressPostalCode 7)
FROM 'https://myprojectstorageadls98.dfs.core.windows.net/taxidata/Dimensions/FhvBases.parquet'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 5
)
--END
GO

SELECT TOP 100 * FROM dbo.StageBases
GO