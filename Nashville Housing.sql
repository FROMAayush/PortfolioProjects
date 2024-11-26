SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]



  --Cleaning Data in SQL Queries
  SELECT *
  FROM PortfolioProject..NashvilleHousing
  
  .....................................................................

  --Standarize Data Format
  SELECT SaleDateConverted
  FROM PortfolioProject.dbo.NashvilleHousing

  SELECT SaleDate, 
  CONVERT(DATE, SaleDate)
  FROM PortfolioProject..NashvilleHousing

  UPDATE NashvilleHousing
  SET SaleDate = CONVERT (DATE, SaleDate)

  ALTER TABLE NashvilleHousing
  ADD SaleDateConverted DATE;

  UPDATE NashvilleHousing
  SET SaleDateConverted = CONVERT (DATE, SaleDate)

  ......................................................................

  --Populate Property Address Data
  
  SELECT*
  FROM PortfolioProject..NashvilleHousing
  ORDER BY ParcelID

  SELECT ParcelID, PropertyAddress
  FROM PortfolioProject.dbo.NashvilleHousing
  WHERE PropertyAddress IS NULL

  
  SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
  FROM PortfolioProject.dbo.NashvilleHousing a
  JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
  WHERE a.PropertyAddress IS NULL

    SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM PortfolioProject.dbo.NashvilleHousing a
  JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
  WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

SELECT*
FROM PortfolioProject..NashvilleHousing
  ......................................................................

--Breaking down address into individual column (Address,City, State)
-- For Property Address using SUBSTRING 
SELECT*
FROM PortfolioProject..NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))
  
 SELECT*
 FROM PortfolioProject.dbo.NashvilleHousing

--For Owner Address using PARSENAME

 SELECT*
 FROM PortfolioProject.dbo.NashvilleHousing

 SELECT PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
		PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
		PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
 FROM PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnerSplitAddress NVARCHAR(255)

 UPDATE PortfolioProject.dbo.NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnerSplitCity NVARCHAR(255)

 UPDATE  NashvilleHousing
 SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

  ......................................................................
  
  -- Select Y and N to Yes and No in 'SoldAsVacant' field

  SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM PortfolioProject.dbo.NashvilleHousing
  GROUP BY SoldAsVacant;

 SELECT SoldAsVacant,
 CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN  'No'
		ELSE SoldAsVacant
 END
  FROM PortfolioProject.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant =
CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN  'No'
		ELSE SoldAsVacant
 END
FROM PortfolioProject.dbo.NashvilleHousing;

    ......................................................................

  -- Remove Duplicates

  -- Looking for the number of duplicate rows
  SELECT*
  FROM PortfolioProject.dbo.NashvilleHousing

  SELECT *, 
  ROW_NUMBER()
  OVER(
  PARTITION BY
	ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY UniqueID) AS Row_num
	FROM PortfolioProject.dbo.NashvilleHousing
	ORDER BY ParcelID

-- Creating CTEs to find Row_num>1 and Deleting it 
WITH RowNumCTE AS(
  SELECT *, 
  ROW_NUMBER()
  OVER(
  PARTITION BY
	ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY UniqueID) AS Row_num
	FROM PortfolioProject.dbo.NashvilleHousing
	)

	SELECT *
	FROM RowNumCTE
	WHERE Row_num>1

-- and Deleting it 

	WITH RowNumCTE AS(
  SELECT *, 
  ROW_NUMBER()
  OVER(
  PARTITION BY
	ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY UniqueID) AS Row_num
	FROM PortfolioProject.dbo.NashvilleHousing
	)

	DELETE
	FROM RowNumCTE
	WHERE Row_num>1

	 ......................................................................

--Delete Unused Columns

SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress,Saledate, OwnerAddress, TaxDistrict

	 ......................................................................
