select * from [Nashville housing]

----- Standardize Date Format
select SaleDate, CONVERT(date, saleDate) 
from [Nashville housing]

update [Nashville housing]
set SaleDate = CONVERT(date, saleDate)

alter table [Nashville housing]
add saledateconverted date;

update [Nashville housing]
set saledateconverted = CONVERT(date, saleDate)


----populate property address data

select PropertyAddress
from [Nashville housing]
--where PropertyAddress is null
order by ParcelID


select *
from [Nashville housing]
--where PropertyAddress is null
order by ParcelID

select a. ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from [Nashville housing] a
join [Nashville housing] b
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a. ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville housing] a
join [Nashville housing] b
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a 
set PropertyAddress=  ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville housing] a
join [Nashville housing] b
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




---breaking address into individual columns( address, city,state)

select PropertyAddress
from [Nashville housing]

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)) as address
from [Nashville housing]

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as address
from [Nashville housing]

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len( PropertyAddress)) as address
from [Nashville housing]



alter table [Nashville housing]
add propertysplitaddress nvarchar(255);

update [Nashville housing]
set propertysplitaddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

alter table [Nashville housing]
add propertysplitcity nvarchar(255);

update [Nashville housing]
set propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len( PropertyAddress))

select propertysplitcity,propertysplitaddress
from [Nashville housing]



Select OwnerAddress
From [Nashville housing]

--parse name uses periods (.)

Select 
 PARSENAME(OwnerAddress,1)
From [Nashville housing]

Select 
 PARSENAME(replace(OwnerAddress,',','.'),1),
 PARSENAME(replace(OwnerAddress,',','.'),2),
 PARSENAME(replace(OwnerAddress,',','.'),3)
From [Nashville housing]

alter table [Nashville housing]
add ownersplitaddress  nvarchar(255);

update [Nashville housing]
set ownersplitaddress =  PARSENAME(replace(OwnerAddress,',','.'),3)



alter table [Nashville housing]
add ownersplitcity nvarchar(255);

update [Nashville housing]
set ownersplitcity = PARSENAME(replace(OwnerAddress,',','.'),2)


alter table [Nashville housing]
add ownercitysplitstate nvarchar(255);

update [Nashville housing]
set ownercitysplitstate = PARSENAME(replace(OwnerAddress,',','.'),1)

select ownersplitcity, ownercitysplitstate, ownersplitaddress
from [Nashville housing]




------------------------------------------------------------------------------------------------



-- Change Y and N to Yes and No in "Sold as Vacant" field

select *
from [Nashville housing]

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Nashville housing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant, 
  case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end 
from [Nashville housing]


update [Nashville housing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end 
from [Nashville housing]


------------------------------------------------------------

-- Remove Duplicates

select *
from [Nashville housing]
 
select *, 
    row_number() 
	over (partition by ParcelID, 
	                   propertyAddress,
					   saledate,
					   saleprice,
					   legalreference
					   order by 
					   UniqueID) row_num
from [Nashville housing]
order by ParcelID


 WITH RowNumCTE AS(
select *, 
    row_number() 
	over (partition by ParcelID, 
	                   propertyAddress,
					   saledate,
					   saleprice,
					   legalreference
					   order by 
					   UniqueID) row_num
from [Nashville housing]
 )
 select *
from RowNumCTE
where row_num >1

  WITH RowNumCTE AS(
select *, 
    row_number() 
	over (partition by ParcelID, 
	                   propertyAddress,
					   saledate,
					   saleprice,
					   legalreference
					   order by 
					   UniqueID) row_num
from [Nashville housing]
 )
 Delete 
from RowNumCTE
where row_num >1


---------------------------------
---delete unused columns

alter table[Nashville housing]
drop column owneraddress, taxdistrict,propertyAddress,saleDate