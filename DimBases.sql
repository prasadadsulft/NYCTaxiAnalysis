CREATE TABLE dbo.DimBases
WITH
(
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
)
AS 
SELECT ROW_NUMBER()OVER(ORDER BY BaseLicenseId) AS LicenseNumber,
	 BaseLicenseId as AltLicenseNumber,
	 BaseType,
	 AddressBuilding,
	 AddressStreet,
	 AddressCity,
	 AddressState,
	 AddressPostalCode
FROM dbo.StageBases;

SELECT TOP 100
* FROM dbo.DimBases 
ORDER BY 1;
