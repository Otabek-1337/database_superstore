-- 1. Create Segments Table
CREATE TABLE Segments (
                          SegmentID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                          SegmentName VARCHAR(255)
);

-- 2. Create Countries Table
CREATE TABLE Countries (
                           CountryID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                           CountryName VARCHAR(255)
);

-- 3. Create Regions Table
CREATE TABLE Regions (
                         RegionID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                         RegionName VARCHAR(255)
);

-- 4. Create States Table
CREATE TABLE States (
                        StateID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                        StateName VARCHAR(255),
                        RegionID INT,
                        FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
);

-- 5. Create Cities Table
CREATE TABLE Cities (
                        CityID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                        CityName VARCHAR(255),
                        StateID INT,
                        FOREIGN KEY (StateID) REFERENCES States(StateID)
);

-- 6. Create Categories Table
CREATE TABLE Categories (
                            CategoryID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                            CategoryName VARCHAR(255)
);

-- 7. Create SubCategories Table
CREATE TABLE SubCategories (
                               SubCategoryID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                               SubCategoryName VARCHAR(255)
);

-- 8. Create Products Table
CREATE TABLE Products (
                          ProductID VARCHAR(255) PRIMARY KEY, -- Adjust the length according to the maximum length of your Product IDs
                          CategoryID INT,
                          SubCategoryID INT,
                          ProductName VARCHAR(255),
                          FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
                          FOREIGN KEY (SubCategoryID) REFERENCES SubCategories(SubCategoryID)
);


-- 9. Create Customers Table
CREATE TABLE Customers (
                           CustomerID VARCHAR(255) PRIMARY KEY,
                           CustomerName VARCHAR(255),
                           SegmentID INT,
                           CountryID INT,
                           StateID INT,
                           CityID INT,
                           FOREIGN KEY (SegmentID) REFERENCES Segments(SegmentID),
                           FOREIGN KEY (CountryID) REFERENCES Countries(CountryID),
                           FOREIGN KEY (StateID) REFERENCES States(StateID),
                           FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

-- 10. Create Orders Table
CREATE TABLE Orders (
                        OrderID VARCHAR(255) PRIMARY KEY,
                        OrderDate DATE,
                        ShipDate DATE,
                        ShipMode VARCHAR(255),
                        CustomerID VARCHAR(255),
                        Sales DECIMAL(10, 2),
                        Quantity INT,
                        Profit DECIMAL(10, 4),
                        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- 11. Create Shipments Table
CREATE TABLE Shipments (
                           ShipmentID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                           OrderID varchar,
                           ProductID VARCHAR(255), -- Match the data type with the Products table
                           ShipDate DATE,
                           ShipMode VARCHAR(255),
                           Quantity INT,
                           FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
                           FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- 12. create denormalized db

CREATE TABLE denormalized_data_mart AS
SELECT
    co.countryname,
    s1.statename,
    c.cityname,
    r.regionname,
    cat.categoryname,
    sc.subcategoryname,
    p.productname,
    cu.customername,
    seg.segmentname,
    o.orderdate,
    o.shipdate,
    o.shipmode,
    o.sales,
    o.quantity,
    o.profit
FROM orders o
         JOIN customers cu ON o.customerid = cu.customerid
         JOIN segments seg ON seg.segmentid = cu.segmentid
         JOIN shipments sh ON sh.orderid = o.orderid
         JOIN products p ON p.productid = sh.productid
         JOIN subcategories sc ON p.subcategoryid = sc.subcategoryid
         JOIN categories cat ON p.categoryid = cat.categoryid
         JOIN subcategories s2 ON s2.subcategoryid = p.subcategoryid
         JOIN cities c ON cu.cityid = c.cityid
         JOIN states s1 ON c.stateid = s1.stateid
         JOIN regions r ON s1.regionid = r.regionid
         JOIN countries co ON cu.countryid = co.countryid
         JOIN regions r2 ON r2.regionid = r.regionid;