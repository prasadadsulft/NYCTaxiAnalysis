
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 FIRST_ROW = 11,
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'taxidata_myprojectstorageadls98_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [taxidata_myprojectstorageadls98_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://taxidata@myprojectstorageadls98.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE dbo.stage_taxizones (
	[LocationID] nvarchar(4000),
	[Borough] nvarchar(4000),
	[Zone] nvarchar(4000),
	[service_zone] nvarchar(4000)
	)
	WITH (
	LOCATION = 'zonestaxi',
	DATA_SOURCE = [taxidata_myprojectstorageadls98_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.stage_taxizone
GO