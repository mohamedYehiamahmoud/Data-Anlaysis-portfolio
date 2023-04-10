
--CLEANING DATA IN SQL QURIES
SELECT *
FROM NashvilleHousing

--STANDIZINING THE DATA FORMAT

SELECT SaleDateConverted , convert(date,SaleDate)
FROM NashvilleHousing


update NashvilleHousing
set SaleDate = convert(date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data
SELECT *
FROM NashvilleHousing
--where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
Set PropertyAddress =isnull(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out PropertyAddress into indvidual colunms
SELECT
SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',' , PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress ,CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',' , PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress ,CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress))

select *
from NashvilleHousing




select
PARSENAME(replace(OwnerAddress,',' , '.'),3)
,PARSENAME(replace(OwnerAddress,',' , '.'),2)
,PARSENAME(replace(OwnerAddress,',' , '.'),1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',' , '.'),3)

-- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct (SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant
,Case when SoldAsVacant = 'Y' Then 'Yes'
      when SoldAsVacant = 'N' Then 'NO'
	  Else SoldAsVacant
	  END
from NashvilleHousing


update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
      when SoldAsVacant = 'N' Then 'NO'
	  Else SoldAsVacant
	  END

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity =PARSENAME(replace(OwnerAddress,',' , '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState  =PARSENAME(replace(OwnerAddress,',' , '.'),1)


-- Remove Duplicates
with ROWNUMCTE as (
select * ,
ROW_NUMBER() over (
partition by PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 )row_num

from NashvilleHousing
--order by ParcelID
)
Delete
from ROWNUMCTE
where row_num > 1
--order by PropertyAddress


--delete unused colunms
select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
Drop COLUMN  OwnerAddress, TaxDistrict, PropertyAddress, SaleDate 




