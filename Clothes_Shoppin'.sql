SELECT SERVERPROPERTY('IsIntegratedSecurityOnly') AS AuthenticationMode;
ALTER LOGIN sa WITH PASSWORD = 'NewStrongPassword';
ALTER LOGIN sa ENABLE;

-- DROP TABLES IN ORDER TO AVOID FK VIOLATIONS
DROP TABLE IF EXISTS tblPurchase;
DROP TABLE IF EXISTS tblOrderProducts;
DROP TABLE IF EXISTS tblProductSizeQuantity;
DROP TABLE IF EXISTS tblProductImages;
DROP TABLE IF EXISTS tblCart;
DROP TABLE IF EXISTS tblProducts;
DROP TABLE IF EXISTS tblSizes;
DROP TABLE IF EXISTS tblSubCategory;
DROP TABLE IF EXISTS tblCategory;
DROP TABLE IF EXISTS tblBrands;
DROP TABLE IF EXISTS tblGender;
DROP TABLE IF EXISTS ForgotPass;
DROP TABLE IF EXISTS tblOrders;
DROP TABLE IF EXISTS tblUsers;

-- CREATE DATABASE
CREATE DATABASE Shopping_database;
GO
USE Shopping_database;
GO

-- CREATE TABLES

CREATE TABLE tblUsers (
    Uid INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(100),
    Password VARCHAR(100),
    Email VARCHAR(100),
    Name VARCHAR(100)
);
ALTER TABLE tblUsers ADD Role VARCHAR(50) NOT NULL DEFAULT 'User';
UPDATE tblUsers SET Role = 'Admin' WHERE Username = 'admin';


CREATE TABLE ForgotPass (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Uid INT,
    RequestDateTime DATETIME,
    FOREIGN KEY (Uid) REFERENCES tblUsers(Uid)
);

CREATE TABLE tblGender (
    GenderID INT IDENTITY(1,1) PRIMARY KEY,
    GenderName VARCHAR(50)
);

CREATE TABLE tblBrands (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    BrandName VARCHAR(100)
);

CREATE TABLE tblCategory (
    CatID INT IDENTITY(1,1) PRIMARY KEY,
    CatName VARCHAR(100)
);

CREATE TABLE tblSubCategory (
    SubCatID INT IDENTITY(1,1) PRIMARY KEY,
    SubCatName VARCHAR(100),
    MainCatID INT,
    FOREIGN KEY (MainCatID) REFERENCES tblCategory(CatID)
);

CREATE TABLE tblSizes (
    SizeID INT IDENTITY(1,1) PRIMARY KEY,
    SizeName VARCHAR(50),
    BrandID INT,
    CategoryID INT,
    SubCategoryID INT,
    FOREIGN KEY (BrandID) REFERENCES tblBrands(BrandID),
    FOREIGN KEY (CategoryID) REFERENCES tblCategory(CatID),
    FOREIGN KEY (SubCategoryID) REFERENCES tblSubCategory(SubCatID)
);

CREATE TABLE tblProducts (
    Pid INT IDENTITY(1,1) PRIMARY KEY,
    Pname VARCHAR(100),
    Pprice DECIMAL(10,2),
    PsellPrice DECIMAL(10,2),
    PbrandId INT,
    PcategoryId INT, -- optional: only add if you use it in the model
    PsubCatId INT,
    Pgender INT,
    Pdescription TEXT,
    PproductDetails TEXT,
    PmaterialCare TEXT,
    FreeDelivery BIT,
    _30dayRet BIT,
    Cod BIT,
    Pimage VARCHAR(255),

    -- Foreign Keys
    FOREIGN KEY (PbrandId) REFERENCES tblBrands(BrandID),
    FOREIGN KEY (PsubCatId) REFERENCES tblSubCategory(SubCatID),
    FOREIGN KEY (Pgender) REFERENCES tblGender(GenderID)
);

CREATE TABLE tblProductImages (
    PIMSID INT IDENTITY(1,1) PRIMARY KEY,
    PID INT,
    Name VARCHAR(255),
    FOREIGN KEY (PID) REFERENCES tblProducts(PID)
);

CREATE TABLE tblProductSizeQuantity (
    ProSizeQuantID INT IDENTITY(1,1) PRIMARY KEY,
    PID INT,
    SizeID INT,
    Quant INT,
    FOREIGN KEY (PID) REFERENCES tblProducts(PID),
    FOREIGN KEY (SizeID) REFERENCES tblSizes(SizeID)
);

CREATE TABLE tblCart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UID INT,
    PID INT,
    PName VARCHAR(100),
    PPrice DECIMAL(10,2),
    PSellPrice DECIMAL(10,2),
    SubPAmount DECIMAL(10,2),
    FOREIGN KEY (UID) REFERENCES tblUsers(Uid),
    FOREIGN KEY (PID) REFERENCES tblProducts(PID)
);

CREATE TABLE tblOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    EMail VARCHAR(100),
    CartAmount DECIMAL(10,2),
    CartDiscount DECIMAL(10,2),
    TotalPaid DECIMAL(10,2),
    FOREIGN KEY (UserID) REFERENCES tblUsers(Uid)
);

CREATE TABLE tblOrderProducts (
    OrderProID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    PID INT,
    Products VARCHAR(100),
    Quantity INT,
    OrderPID INT,
    FOREIGN KEY (UserID) REFERENCES tblUsers(Uid),
    FOREIGN KEY (PID) REFERENCES tblProducts(PID),
    FOREIGN KEY (OrderPID) REFERENCES tblOrders(OrderID)
);

CREATE TABLE tblPurchase (
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    PIDSizeID INT,
    CartAmount DECIMAL(10,2),
    CartDiscount DECIMAL(10,2),
    TotalPaid DECIMAL(10,2),
    PaymentType VARCHAR(50),
    PaymentStatus VARCHAR(50),
    DateOfPurchase DATETIME,
    FOREIGN KEY (UserID) REFERENCES tblUsers(Uid),
    FOREIGN KEY (PIDSizeID) REFERENCES tblProductSizeQuantity(ProSizeQuantID)
);

-- INSERT DATA

-- Users
INSERT INTO tblUsers (Username, Password, Email, Name)
VALUES 
('admin', 'admin123', 'admin@example.com', 'Admin User'),
('john_doe', '123456', 'john@example.com', 'John Doe');

-- Gender
INSERT INTO tblGender (GenderName)
VALUES ('Male'), ('Female'), ('Unisex');

-- Brands
INSERT INTO tblBrands (BrandName)
VALUES ('Nike'), ('Adidas'), ('Puma');

-- Category
INSERT INTO tblCategory (CatName)
VALUES ('Tops'), ('Shoes'), ('Accessories');

-- SubCategory
INSERT INTO tblSubCategory (SubCatName, MainCatID)
VALUES ('T-Shirts', 1), ('Sneakers', 2), ('Bags', 3);

-- Sizes
INSERT INTO tblSizes (SizeName, BrandID, CategoryID, SubCategoryID)
VALUES 
('S', 1, 1, 1),
('M', 1, 1, 1),
('L', 1, 1, 1),
('8', 2, 2, 2),
('9', 2, 2, 2);

-- Products
INSERT INTO tblProducts (
    PName, PPrice, PSellPrice, PBrandID, PSubCatID, PGender,
    PDescription, PProductDetails, PMaterialCare, FreeDelivery, _30dayRet, COD)
VALUES 
('Nike T-Shirt', 1000.00, 800.00, 1, 1, 1, 
 'Soft cotton Nike tee', 'Perfect for casual wear', 'Machine wash', 1, 1, 1),
('Adidas Sneakers', 3000.00, 2500.00, 2, 2, 3,
 'Comfortable running shoes', 'Breathable and lightweight', 'Wipe clean', 1, 1, 1);

-- Product Images
INSERT INTO tblProductImages (PID, Name)
VALUES 
(1, 'nike-tshirt.jpg'),
(2, 'adidas-sneakers.jpg');

-- Product Size Quantity
INSERT INTO tblProductSizeQuantity (PID, SizeID, Quant)
VALUES 
(1, 1, 10),
(2, 3, 5);

-- Cart
INSERT INTO tblCart (UID, PID, PName, PPrice, PSellPrice, SubPAmount)
VALUES 
(2, 1, 'Nike T-Shirt', 1000.00, 800.00, 800.00);

-- Orders
INSERT INTO tblOrders (UserID, EMail, CartAmount, CartDiscount, TotalPaid)
VALUES 
(2, 'john@example.com', 1000.00, 200.00, 800.00);

-- Order Products
INSERT INTO tblOrderProducts (UserID, PID, Products, Quantity, OrderPID)
VALUES 
(2, 1, 'Nike T-Shirt', 1, 1);

-- Purchase
INSERT INTO tblPurchase (UserID, PIDSizeID, CartAmount, CartDiscount, TotalPaid, PaymentType, PaymentStatus, DateOfPurchase)
VALUES 
(2, 1, 1000.00, 200.00, 800.00, 'Credit Card', 'Paid', GETDATE());

-- VIEW TABLE STRUCTURE (OPTIONAL)
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tblProducts';

SELECT * FROM tblProducts