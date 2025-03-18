**Summary of Work
Nashville Housing: Data Cleaning and Transformation in SQL**
This project involved a comprehensive cleanup and transformation of the Nashville Housing Dataset to ensure consistent data formatting, improved usability, and better analytical capabilities. 
Below is an outline of the steps performed and their purpose:

**1. Standardizing Data Formats**
Objective: Convert inconsistent date formats into a uniform structure.
Actions:
- Used the CONVERT function to format dates in the SaleDate column to DATE.
- Created a new column, SaleDateConverted, for the formatted date values.
- Populated the new column using an UPDATE statement to preserve data integrity.
**2. Populating Missing Property Address Data**
Objective: Fill null values in the PropertyAddress field.
Actions:
- Identified missing PropertyAddress values.
- Used a self-join on the dataset based on ParcelID to pull corresponding non-null addresses from other rows.
- Updated null values with the corresponding address using the ISNULL function and an UPDATE query.
**3. Splitting Address Fields**
Objective: Break down complex address fields into more granular columns for better usability.
Actions:
- Split PropertyAddress into PropertySplitAddress and PropertySplitCity using the SUBSTRING and CHARINDEX functions.
- Applied the PARSENAME function to split OwnerAddress into OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState.
**4. Standardizing Boolean Values**
Objective: Enhance readability of the SoldAsVacant column, which had values as Y and N.
Actions:
- Updated the column to store Yes and No instead of Y and N using a CASE statement.
**5. Removing Duplicate Records**
Objective: Eliminate redundant rows to ensure data accuracy.
Actions:
- Identified duplicate rows by using the ROW_NUMBER function with a PARTITION BY clause on key columns (ParcelID, LandUse, etc.).
- Used a Common Table Expression (CTE) to filter out and delete rows where the row number was greater than 1.
**6. Dropping Unnecessary Columns**
Objective: Remove redundant columns to streamline the dataset.
Actions:
- Dropped the PropertyAddress, SaleDate, OwnerAddress, and TaxDistrict columns after their data was cleaned and appropriately distributed into new columns.

**Tools and Techniques**
SQL Functions: CONVERT, SUBSTRING, CHARINDEX, PARSENAME, ISNULL, CASE, and ROW_NUMBER.
Query Optimization: Used WITH statements (CTEs) for better readability and management of complex queries.
Data Integrity: Ensured no original data was overwritten without creating backups or transitional columns.

**Outcome**
The dataset is now:
- Free of null values in key fields like PropertyAddress.
- Standardized in its date and boolean value formats.
- More granular, with individual columns for address components (PropertySplitAddress, OwnerSplitCity, etc.).
- Devoid of duplicate records, ensuring unique and accurate entries.
- Optimized for analysis and reporting, with unnecessary columns removed.
  
**Next Steps**
Perform data visualization or analysis on the cleaned dataset.
Document any additional data transformation requirements identified during analysis.
This work demonstrates a structured approach to cleaning and transforming data, making it suitable for analytics and ensuring data quality.
