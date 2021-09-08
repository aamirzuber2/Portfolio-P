--Data cleaning

Select*
From Nashville

-- Sale Data

Select SaleDate
From Nashville


Alter Table Nashville
Add SaleDate1 Date;

Update Nashville
Set SaleDate1 = Convert(Date, SaleDate)

Select SaleDate1
From Nashville

-- Property Address 

Select PropertyAddress
From Nashville

Select PropertyAddress
From Nashville
Where PropertyAddress is Null

Select *
From Nashville
Where PropertyAddress is Null


--Populating Property Address


Select*
From Nashville
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Nashville a
JOin Nashville B
	on a.ParcelID = B.ParcelID
	And a.[UniqueID ]<> B.[UniqueID ]
Where a.PropertyAddress is Null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Nashville a
JOin Nashville B
	on a.ParcelID = B.ParcelID
	And a.[UniqueID ]<> B.[UniqueID ]
Where a.PropertyAddress is Null

-- Check if it's updated

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Nashville a
JOin Nashville B
	on a.ParcelID = B.ParcelID
	And a.[UniqueID ]<> B.[UniqueID ]
Where a.PropertyAddress is Null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Nashville a
JOin Nashville B
	on a.ParcelID = B.ParcelID
	And a.[UniqueID ]<> B.[UniqueID ]


--Breaking the Address

Select PropertyAddress
From Nashville


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From Nashville

--Adding New Column for Address


Alter Table Nashville
Add PropertyAddress1 nvarchar(255);

Update Nashville
Set PropertyAddress1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table Nashville
Add City nvarchar(255);

Update Nashville
Set City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From Nashville


-- A Different way to split the String (ParseName)

Select OwnerAddress
From Nashville

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From Nashville

--Adding new columns for the owner address


Alter Table Nashville
Add OwnerAdd nvarchar(255);

Update Nashville
Set OwnerAdd = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table Nashville
Add OwneCity nvarchar(255);

Update Nashville
Set OwneCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table Nashville
Add State nvarchar(255);

Update Nashville
Set State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select*
From Nashville


-- Changing 'Y' and 'N' to 'Yes' and 'No'

Select Distinct(SoldAsVacant)
From Nashville

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Nashville
Group By SoldAsVacant
Order By 2


Select SoldAsVacant,
Case 
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
From Nashville

Update Nashville
Set SoldAsVacant = Case 
					When SoldAsVacant = 'Y' Then 'Yes'
					When SoldAsVacant = 'N' Then 'No'
					Else SoldAsVacant
					End
From Nashville



Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Nashville
Group By SoldAsVacant


-- Remove Duplicates

With RowNumCTE as(
Select*,
	Row_Number() over (
	Partition By ParcelID,
				PropertyAddress,
				SaleDate1,
				SalePrice,
				LandValue
				Order By UniqueID
				) Row_Num
From Nashville
)
Select*
From RowNumCTE
Where Row_Num > 1



With RowNumCTE as(
Select*,
	Row_Number() over (
	Partition By ParcelID,
				PropertyAddress,
				SaleDate1,
				SalePrice,
				LandValue
				Order By UniqueID
				) Row_Num
From Nashville
)
Delete
From RowNumCTE
Where Row_Num > 1


With RowNumCTE as(
Select*,
	Row_Number() over (
	Partition By ParcelID,
				PropertyAddress,
				SaleDate1,
				SalePrice,
				LandValue
				Order By UniqueID
				) Row_Num
From Nashville
)
Select*
From RowNumCTE
Where Row_Num > 1




--Delete Unusable Columns


Select*
From Nashville

Alter Table Nashville
Drop Column PropertyAddress, SaleDate, TaxDistrict, OwnerAddress