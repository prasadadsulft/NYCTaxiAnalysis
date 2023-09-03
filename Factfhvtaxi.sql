ALTER DATABASE SCOPED CONFIGURATION SET DW_COMPATIBILITY_LEVEL = 50;

--- Creating a FACT table for FhvTaxis
CREATE table dbo.FactFhvTaxis
( LicenseNum_key BIGINT,
  PULocation_key BIGINT,
  DOLocation_key BIGINT,
  pickup_datetime DATETIME,
  dropoff_datetime DATETIME,
  SR_Flag BIGINT)
WITH
(
    DISTRIBUTION = HASH(LicenseNum_key, PULocation_key, DOLocation_key),
    CLUSTERED COLUMNSTORE INDEX
);

INSERT INTO dbo.FactFhvTaxis
SELECT  
      (SELECT MAX(b.LicenseNumber)
      FROM dbo.DimBases b
      WHERE trim(lower(b.AltLicenseNumber)) = trim(lower(ft.dispatching_base_num))) as LicenseNum_key,
      (SELECT MAX(tz.LocationID)
      FROM dbo.DimTaxiZones tz
      WHERE tz.AltLocID = ft.PULocationID) as PULocation_key,
      (SELECT MAX(tz.LocationID)
      FROM dbo.DimTaxiZones tz
      WHERE tz.AltLocID = ft.DOLocationID) as DOLocation_key,
      ft.pickup_datetime,
      ft.dropoff_datetime,
      COALESCE(ft.SR_Flag,0) as SR_Flag
FROM dbo.FhvTaxis as ft;

SELECT TOP 100
* FROM dbo.FactFhvTaxis;