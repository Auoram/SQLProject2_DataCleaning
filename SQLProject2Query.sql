
--Cleaning Cafe Sales Dataset

Select * from dirty_cafe_sales;

--Check the Transaction_Date that are not in date format

select Transaction_Date , Count(*) from dirty_cafe_sales where Transaction_Date not like '%-%-%' group by Transaction_Date;

--Replace the Values that are not dates with null values

UPDATE dirty_cafe_sales
SET Transaction_Date = NULL
WHERE Transaction_Date IN ('ERROR', 'UNKNOWN') OR TRY_CAST(Transaction_Date AS DATE) IS NULL;

--Create 3 new columns to have the year , the month and the day

ALTER TABLE dirty_cafe_sales ADD Year INT, Month INT, Day INT;

UPDATE dirty_cafe_sales
SET Year = YEAR(Transaction_Date), Month = MONTH(Transaction_Date), Day = DAY(Transaction_Date)
WHERE Transaction_Date IS NOT NULL;

--Replace the Values that are not valid item names with null values

UPDATE dirty_cafe_sales
SET Item = NULL
WHERE Item IN ('ERROR', 'UNKNOWN') OR Item IS NULL;

--Replace the Values that are not valid values with null values

UPDATE dirty_cafe_sales
SET Quantity = NULL
WHERE Quantity IN ('ERROR', 'UNKNOWN') OR Quantity IS NULL;

UPDATE dirty_cafe_sales
SET Price_Per_Unit = NULL
WHERE Price_Per_Unit IN ('ERROR', 'UNKNOWN') OR Price_Per_Unit IS NULL;

UPDATE dirty_cafe_sales
SET Total_Spent = NULL
WHERE Total_Spent IN ('ERROR', 'UNKNOWN') OR Total_Spent IS NULL;

UPDATE dirty_cafe_sales
SET Payment_Method = NULL
WHERE Payment_Method IN ('ERROR', 'UNKNOWN') OR Payment_Method IS NULL;

--Then replace the null values with calculated values

UPDATE dirty_cafe_sales
SET Quantity = CAST(Cast(Total_Spent AS float) / Cast(Price_Per_Unit AS float) AS nvarchar)
WHERE Quantity IS NULL AND Total_Spent IS NOT NULL AND Price_Per_Unit IS NOT NULL AND Cast(Price_Per_Unit AS float) != 0;

UPDATE dirty_cafe_sales
SET Price_Per_Unit = CAST(Cast(Total_Spent AS float) / Cast(Quantity AS float) AS nvarchar)
WHERE Price_Per_Unit IS NULL AND Total_Spent IS NOT NULL AND Quantity IS NOT NULL AND Cast(Quantity AS float) != 0;

UPDATE dirty_cafe_sales
SET Total_Spent = CAST(Cast(Price_Per_Unit AS float) * Cast(Quantity AS float) AS nvarchar)
WHERE Total_Spent IS NULL AND Price_Per_Unit IS NOT NULL AND Quantity IS NOT NULL;

--Change the values calculated and displayed as integers to a float format

UPDATE dirty_cafe_sales
SET Price_Per_Unit = FORMAT(TRY_CAST(Price_Per_Unit AS FLOAT), 'N1')
WHERE Price_Per_Unit NOT LIKE '%.%';

UPDATE dirty_cafe_sales
SET Total_Spent = FORMAT(TRY_CAST(Total_Spent AS FLOAT), 'N1')
WHERE Total_Spent NOT LIKE '%.%';

--Checking the usual price of each item


Select Item,Price_Per_Unit,Count(*) as OccurrenceOfPricePerItem 
from dirty_cafe_sales 
WHERE Price_Per_Unit IS NOT NULL AND Item IS NOT NULL 
group by Item,Price_Per_Unit 
order by Item, OccurrenceOfPricePerItem DESC;

--Replace the Price_Per_Unit in the rows with known Item name with its usual price

UPDATE dirty_cafe_sales
SET Price_Per_Unit = (
    SELECT Max(D.Price_Per_Unit)
    FROM dirty_cafe_sales D
    WHERE D.Item = dirty_cafe_sales.Item AND D.Price_Per_Unit IS NOT NULL
)
WHERE Price_Per_Unit IS NULL AND Item IS NOT NULL;