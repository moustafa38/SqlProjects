--Cleaning Data in SQL Queries

select * from mydb..house

-- change saledata data type to date 

ALTER TABLE mydb..house
ALTER COLUMN SaleDate date;

-- Populate Property Address data

Select *
From mydb..house
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From mydb.dbo.house a
JOIN mydb.dbo.house b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From mydb.dbo.house a
JOIN mydb.dbo.house b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- spilt adress to 2 columns ( address , city )
select PropertyAddress from mydb..house

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as city

From mydb..house

ALTER TABLE mydb..house
Add PropertySplitAddress Nvarchar(255);

Update mydb..house
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE mydb..house
Add PropertySplitCity Nvarchar(255);

Update mydb..house
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select *
from mydb..house


-- spilt owner address to 2 columns ( address , city )

select OwnerAddress
from mydb..house


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as city
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)as state
From mydb..house 

ALTER TABLE mydb..house
Add OwnerSplitAddress Nvarchar(255);

Update mydb..house
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE mydb..house
Add OwnerSplitCity Nvarchar(255);

Update mydb..house
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) 

ALTER TABLE mydb..house
Add OwnerSplitState Nvarchar(255);

Update mydb..house
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) 

select *
from mydb..house

-- modify soldasvalue and make all value to just  Yes and No

select distinct(SoldAsVacant) , COUNT(SoldAsVacant)
from mydb..house
group by SoldAsVacant
order by 2

select SoldAsVacant ,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end 
from mydb..house

update mydb..house
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end 

select distinct(SoldAsVacant) , COUNT(SoldAsVacant)
from mydb..house
group by SoldAsVacant
order by 2

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From mydb..house
--order by ParcelID
)
select *
From RowNumCTE
--Where row_num > 1
--Order by PropertyAddress

-- Delete Unused Columns



Select *
From mydb..house


ALTER TABLE mydb..house
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From mydb..house