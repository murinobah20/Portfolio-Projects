-- Cleaning Data in SQL Queries

-- 1. Standarize Data Format
-- 2. Remove Null Data & Duplicate Data
-- 3. Breaking out Addres into individual column (Address,city)
-- 4. Remove duplicates 
-- 5. Delete unused columns



-- 1. Standarize Data Format

SELECT *
FROM [Portofolio Project]..NashvilleHousing ;

SELECT saledateconverted,CONVERT(Date,saledate)
FROM [Portofolio Project]..NashvilleHousing ;

UPDATE NashvilleHousing
SET saledate = CONVERT(date,saledate) ;

ALTER TABLE NashvilleHousing
Add saledateconverted date ;

UPDATE NashvilleHousing
SET saledateconverted = CONVERT(date,saledate) ;


-- 2. Remove Null Data & Duplicate Data
SELECT *
FROM [Portofolio Project]..NashvilleHousing 
WHERE propertyaddress is null
;
SELECT *
FROM [Portofolio Project]..NashvilleHousing 
-- WHERE propertyaddress is null
ORDER BY parcelid
;

SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress,  ISNULL(a.propertyaddress,b.propertyaddress)
FROM [Portofolio Project]..NashvilleHousing as a
JOIN [Portofolio Project]..NashvilleHousing as b
 ON a.parcelid = b.parcelid
 AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress is null
;

UPDATE a
SET propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
FROM [Portofolio Project]..NashvilleHousing as a
JOIN [Portofolio Project]..NashvilleHousing as b
 ON a.parcelid = b.parcelid
 AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress is null
;

SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress 
FROM [Portofolio Project]..NashvilleHousing as a
JOIN [Portofolio Project]..NashvilleHousing as b
 ON a.parcelid = b.parcelid
 AND a.uniqueid <> b.uniqueid
;


-- 3.Breaking out Addres into individual column (Address,city)
SELECT PropertyAddress
FROM [Portofolio Project]..NashvilleHousing 
;

SELECT 
SUBSTRING(Propertyaddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
LTRIM (SUBSTRING(Propertyaddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))) as City
FROM [Portofolio Project].. NashvilleHousing
;

ALTER TABLE [Portofolio Project]..NashvilleHousing
Add PropertySplitAddress NVARCHAR(255) ;

UPDATE [Portofolio Project].. NashvilleHousing
SET PropertySplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',',PropertyAddress) -1) ;

ALTER TABLE [Portofolio Project].. NashvilleHousing
Add PropertySplitCity NVARCHAR(255) ;

UPDATE [Portofolio Project].. NashvilleHousing
SET PropertySplitCity = LTRIM (SUBSTRING(Propertyaddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))) ;


SELECT *
FROM [Portofolio Project]..NashvilleHousing 
;





SELECT OwnerAddress
FROM [Portofolio Project].. NashvilleHousing

SELECT 
 PARSENAME(REPLACE (OwnerAddress, ',' ,'.' ),3 ),
 PARSENAME(REPLACE (OwnerAddress, ',' ,'.' ),2),
 PARSENAME(REPLACE (OwnerAddress, ',' ,'.' ),1 )
FROM [Portofolio Project]..NashvilleHousing

ALTER TABLE [Portofolio Project]..NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255) ;

UPDATE [Portofolio Project].. NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress, ',' ,'.' ),3) ;

ALTER TABLE [Portofolio Project].. NashvilleHousing
Add OwnerSplitCity NVARCHAR(255) ;

UPDATE [Portofolio Project].. NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress, ',' ,'.' ),2) ;

ALTER TABLE [Portofolio Project].. NashvilleHousing
Add OwnerSplitState NVARCHAR(255) ;

UPDATE [Portofolio Project].. NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE (OwnerAddress, ',' ,'.' ),1) ;


SELECT *
FROM [Portofolio Project].. NashvilleHousing



--Change Y and N to Yes and No in 'Sold as Vacant' Field

SELECT DISTINCT (SoldasVacant), COUNT (SoldasVacant)
FROM [Portofolio Project]..NashvilleHousing
GROUP BY SoldasVacant
ORDER BY 2


SELECT SoldasVacant ,
CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
	 WHEN SoldasVacant = 'N' THEN 'No'
	ELSE SoldasVacant
END
FROM [Portofolio Project]..NashvilleHousing

UPDATE [Portofolio Project]..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
	 WHEN SoldasVacant = 'N' THEN 'No'
	ELSE SoldasVacant
END




--4. Remove Duplicates

WITH RowNumCTE AS (
	SELECT *,
		ROW_NUMBER () OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference 
					 ORDER BY 
					 uniqueID )
					 Row_Num
FROM [Portofolio Project]..NashvilleHousing 
)
SELECT * 
FROM RowNumCTE 
WHERE row_num > 1
ORDER BY PropertyAddress -- (See the duplicate by Row_Num)


WITH RowNumCTE AS (
	SELECT *,
		ROW_NUMBER () OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference 
					 ORDER BY 
					 uniqueID )
					 Row_Num
FROM [Portofolio Project]..NashvilleHousing 
)
DELETE -- Delete the duplicate row_num which is 2 row_num
FROM RowNumCTE 
WHERE row_num > 1


WITH RowNumCTE AS (
	SELECT *,
		ROW_NUMBER () OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference 
					 ORDER BY 
					 uniqueID )
					 Row_Num
FROM [Portofolio Project]..NashvilleHousing 
)
SELECT * 
FROM RowNumCTE 
ORDER BY PropertyAddress




--5. Delete Unused Columns

SELECT *
FROM [Portofolio Project]..NashvilleHousing

ALTER TABLE [Portofolio Project]..NashvilleHousing
DROP COLUMN PropertyAddress, TaxDistrict,OwnerAddress


ALTER TABLE [Portofolio Project]..NashvilleHousing
DROP COLUMN SaleDate