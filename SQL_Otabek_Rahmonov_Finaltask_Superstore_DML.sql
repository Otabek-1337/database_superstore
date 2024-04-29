-- 1. Populate Segments Table
INSERT INTO Segments (SegmentName)
SELECT DISTINCT "Segment" FROM super_store;

-- 2. Populate Countries Table
INSERT INTO Countries (CountryName)
SELECT DISTINCT "Country" FROM super_store WHERE "Country" IS NOT NULL;

-- 3. Populate Regions Table
INSERT INTO Regions (RegionName)
SELECT DISTINCT "Region" FROM super_store;

-- 4. Populate States Table
INSERT INTO States (StateName, RegionID)
SELECT DISTINCT "State", r.RegionID
FROM super_store s
         JOIN Regions r ON s."Region" = r.RegionName;

-- 5. Populate Cities Table
INSERT INTO Cities (CityName, StateID)
SELECT DISTINCT ss."City", st.StateID
FROM super_store ss
         JOIN States st ON st.StateName = ss."State";

-- 6. Populate Categories Table
INSERT INTO Categories (CategoryName)
SELECT DISTINCT "Category" FROM super_store;

-- 7. Populate SubCategories Table
INSERT INTO SubCategories (SubCategoryName)
SELECT DISTINCT "Sub-Category" FROM super_store;

-- 8. Populate Products Table
INSERT INTO Products (ProductId, CategoryID, SubCategoryID, ProductName)
SELECT DISTINCT s."Product ID", c.CategoryID, sc.SubCategoryID, s."Product Name"
FROM super_store s
         JOIN Categories c ON s."Category" = c.CategoryName
         JOIN SubCategories sc ON s."Sub-Category" = sc.SubCategoryName
ON CONFLICT (ProductId) DO NOTHING;


-- 9. Populate Customers Table
INSERT INTO Customers (CustomerID, CustomerName, SegmentID, CountryID, StateID, CityID)
SELECT DISTINCT
    ss."Customer ID" AS CustomerID,
    ss."Customer Name",
    seg.SegmentID,
    co.CountryID,
    st.StateID,
    ci.CityID
FROM
    super_store ss
        JOIN
    Segments seg ON ss."Segment" = seg.SegmentName
        JOIN
    Countries co ON ss."Country" = co.CountryName
        JOIN
    States st ON ss."State" = st.StateName
        JOIN
    Cities ci ON ss."City" = ci.CityName
ON CONFLICT (CustomerID) DO NOTHING;


-- 10. Populate Orders Table
INSERT INTO Orders (OrderID, OrderDate, ShipDate, ShipMode, CustomerID, Sales, Quantity, Profit)
SELECT
    s."Order ID" AS OrderID,
    TO_DATE(s."Order Date", 'MM/DD/YYYY'),
    TO_DATE(s."Ship Date", 'MM/DD/YYYY'),
    s."Ship Mode",
    s."Customer ID" AS CustomerID,
    s."Sales",
    s."Quantity",
    s."Profit"
FROM
    super_store s
WHERE
    s."Order ID" IS NOT NULL
  AND s."Customer ID" IS NOT NULL
  AND s."Order Date" IS NOT NULL
  AND s."Ship Date" IS NOT NULL
  AND s."Sales" IS NOT NULL
  AND s."Quantity" IS NOT NULL
  AND s."Profit" IS NOT NULL
ON CONFLICT (orderid) DO NOTHING;



-- 11. Populate Shipments Table
INSERT INTO Shipments (OrderID, ProductID, ShipDate, ShipMode, Quantity)
SELECT o.OrderID, p.ProductID, TO_DATE(s."Ship Date", 'MM/DD/YYYY'), s."Ship Mode", s."Quantity"
FROM super_store s
         JOIN Orders o ON s."Order ID" = o.OrderID
         JOIN Products p ON s."Product ID" = p.ProductID;

