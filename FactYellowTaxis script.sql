-- FACT table for Yellow taxis
CREATE table dbo.FactYellowTaxis
(VendorID BIGINT,
 tpep_pickup_datetime DATETIME,
 tpep_dropoff_datetime DATETIME,
 passengerCount INT,
 tripDistance FLOAT,
 Ratecode_key BIGINT,
 store_and_fwd_flag VARCHAR(4000),
 PULocation_key BIGINT,
 DOLocation_key BIGINT,
 PaymentType BIGINT,
 FareAmount FLOAT,
 Extra FLOAT,
 mta_tax FLOAT,
 tip_amount FLOAT,
 tolls_amount FLOAT,
 improvement_surcharge FLOAT,
 TotalAmount FLOAT,
 congestion_surcharge FLOAT)
WITH
(
    DISTRIBUTION = HASH(VendorID, Ratecode_key, PULocation_key, DOLocation_key),
    CLUSTERED COLUMNSTORE INDEX
);

INSERT INTO dbo.FactYellowTaxis
SELECT  yt.VendorID,
        yt.tpep_pickup_datetime,
        yt.tpep_dropoff_datetime,
        yt.passenger_count as passengerCount,
        yt.trip_distance as tripDistance,
        (SELECT MAX(a.RateCodeId)
         FROM dbo.DimRateCodes a
         WHERE a.AltRateCodeId = yt.RatecodeID) as Ratecode_key,
        yt.store_and_fwd_flag,
        (SELECT MAX(b.LocationID)
        FROM dbo.DimTaxiZones b
        WHERE b.AltLocID = yt.PULocationID) as PULocation_key,
        (SELECT MAX(c.LocationID)
        FROM dbo.DimTaxiZones c
        WHERE c.AltLocID = yt.DOLocationID) as DOLocation_key,
        yt.payment_type as PaymentType,
        yt.fare_amount as FareAmount,
        yt.extra as Extra,
        yt.mta_tax,
        yt.tip_amount,
        yt.tolls_amount,
        yt.improvement_surcharge,
        yt.total_amount as TotalAmount,
        yt.congestion_surcharge
FROM dbo.taxi_yellow yt;

Select TOP 100 *
FROM dbo.FactYellowTaxis;