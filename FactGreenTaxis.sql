-- Fact table for GreenTaxis
CREATE table dbo.FactGreenTaxi
(VendorID INT,
 lpep_pickup_datetime DATETIME2,
 lpep_dropoff_datetime DATETIME2,
 passengerCount INT,
 TripType INT,
 tripDistance FLOAT,
 Ratecode_key INT,
 store_and_fwd_flag VARCHAR(4000),
 PULocation_key INT,
 DOLocation_key INT,
 PaymentType INT,
 FareAmount FLOAT,
 TotalAmount FLOAT)
WITH
(
    DISTRIBUTION = HASH(VendorID, Ratecode_key, PULocation_key, DOLocation_key),
    CLUSTERED COLUMNSTORE INDEX
);

INSERT INTO dbo.FactGreenTaxi
SELECT  gt.VendorID,
        gt.lpep_pickup_datetime,
        gt.lpep_dropoff_datetime,
        gt.passenger_count as passengerCount,
        gt.trip_distance as tripDistance,
        cast(gt.trip_type as INT) as TripType,
        (SELECT MAX(a.RateCodeId)
         FROM dbo.DimRateCodes a
         WHERE a.AltRateCodeId = gt.RatecodeID) as Ratecode_key,
        gt.store_and_fwd_flag,
        (SELECT MAX(b.LocationID)
        FROM dbo.DimTaxiZones b
        WHERE b.AltLocID = gt.PULocationID) as PULocation_key,
        (SELECT MAX(c.LocationID)
        FROM dbo.DimTaxiZones c
        WHERE c.AltLocID = gt.DOLocationID) as DOLocation_key,
        gt.payment_type as PaymentType,
        gt.fare_amount as FareAmount,
        gt.total_amount as TotalAmount
        
FROM dbo.greentaxistage as gt;

SELECT TOP 100 *
FROM dbo.FactGreenTaxi;