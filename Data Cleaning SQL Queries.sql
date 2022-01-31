-- Cleaning data in SQL Queries

Select * 
FROM [PortfolioProject].[dbo].[Nashville Housing]

--Standarize Date Format

Select SaleDate
FROM [PortfolioProject].[dbo].[Nashville Housing]



UPDATE [Nashville Housing]
set SaleDate = CONVERT (date, SaleDate)
Select SaleDate
FROM [PortfolioProject].[dbo].[Nashville Housing]

ALTER TABLE [Nashville Housing]
add SaleDateCon date;

UPDATE [Nashville Housing]
set SaleDateCon = CONVERT (date, SaleDate)

select SaleDate, SaleDateCon
FROM [PortfolioProject].[dbo].[Nashville Housing]

--Populate Property Address data
select PropertyAddress
FROM [PortfolioProject].[dbo].[Nashville Housing]
where PropertyAddress is null;

-- Self Joining the table to populate null values with the value 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM [PortfolioProject].[dbo].[Nashville Housing] a
Join [PortfolioProject].[dbo].[Nashville Housing] b
  on  a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

-- Update Property Address field now with the above query to add values to nulls
update a
set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
from [PortfolioProject].[dbo].[Nashville Housing] a
Join [PortfolioProject].[dbo].[Nashville Housing] b
  on  a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

--check if the nulls are filled
select PropertyAddress 
from [PortfolioProject].[dbo].[Nashville Housing]
where PropertyAddress is null

--Breaking out Address into separate columns (address, city, state)
select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Address
from [PortfolioProject].[dbo].[Nashville Housing]

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,len(PropertyAddress)) as City
from [PortfolioProject].[dbo].[Nashville Housing]

-- Now we need to create two columns to add these values in
ALTER TABLE [Nashville Housing]
add PropertySplitAdrress nvarchar(255);

UPDATE [Nashville Housing]
set PropertySplitAdrress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE [Nashville Housing]
add PropertySplitCity nvarchar(255);
UPDATE [Nashville Housing]
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,len(PropertyAddress))

select PropertySplitAdrress , PropertySplitCity
from PortfolioProject.dbo.[Nashville Housing]

/*Another way of doing it is through the PARSENAME function (but it will take Period as a delimiter by default 
so we have to replace it by Coma. Also, it takes the length backwards so have to specify that way */

select OwnerAddress
from PortfolioProject.dbo.[Nashville Housing]

select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.[Nashville Housing]

--Adding these values to the New Splitted Columns
ALTER TABLE [Nashville Housing]
add OwnerSplitAdd nvarchar(255);
UPDATE [Nashville Housing]
set OwnerSplitAdd=PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE [Nashville Housing]
add OwnerSplitCity nvarchar(255);
UPDATE [Nashville Housing]
set OwnerSplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE [Nashville Housing]
add OwnerSplitState nvarchar(255);
UPDATE [Nashville Housing]
set OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)

select OwnerSplitAdd, OwnerSplitCity, OwnerSplitState
from PortfolioProject.dbo.[Nashville Housing]

--Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(SoldAsVacant)
from PortfolioProject.dbo.[Nashville Housing]

select SoldAsVacant, 
Case when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
from PortfolioProject.dbo.[Nashville Housing]

UPDATE [Nashville Housing]
set SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END

Select Distinct (SoldAsVacant)
from PortfolioProject.dbo.[Nashville Housing]

--Removing Duplicates

;WITH RowNumCTE AS (

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
From PortfolioProject.dbo.[Nashville Housing])
--order by ParcelID

Delete from RowNumCTE
where row_num >1
--order by PropertyAddress

--Deleting Unused columns

Alter table PortfolioProject.dbo.[Nashville Housing]
drop column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate