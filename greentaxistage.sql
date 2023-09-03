IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'greentaxistage' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.greentaxistage
	(
	 [VendorID] int,
	 [lpep_pickup_datetime] datetime2(7),
	 [lpep_dropoff_datetime] datetime2(7),
	 [store_and_fwd_flag] nvarchar(4000),
	 [RatecodeID] int,
	 [PULocationID] int,
	 [DOLocationID] int,
	 [passenger_count] int,
	 [trip_distance] real,
	 [fare_amount] real,
	 [total_amount] real,
	 [payment_type] nvarchar(4000),
	 [trip_type] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_greentaxistage
--AS
--BEGIN
COPY INTO dbo.greentaxistage
(VendorID 1, lpep_pickup_datetime 2, lpep_dropoff_datetime 3, store_and_fwd_flag 4, RatecodeID 5, PULocationID 6, DOLocationID 7, passenger_count 8, trip_distance 9, fare_amount 10, total_amount 11, payment_type 12, trip_type 13)
FROM 'https://myprojectstorageadls98.dfs.core.windows.net/taxidata/part-00000-ca10ac26-0a75-4b8e-a5cd-30739b645ff3-c000.snappy.parquet'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 5
)
--END
GO

SELECT TOP 100 * FROM dbo.greentaxistage
GO