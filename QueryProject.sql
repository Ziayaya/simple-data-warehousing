-- Safira Nur Fauziah

-- Membuat database
CREATE DATABASE DWH_Project;

-- Menjadikan database sebagai main
USE DWH_Project;

-- Membuat tabel Product Dimension
CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY NOT NULL,
    ProductName VARCHAR(255) NOT NULL,
	ProductCategory VARCHAR(255) NOT NULL,
    ProductUnitPrice INT NOT NULL
);

-- Membuat tabel Customer Dimension
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	NoHp VARCHAR(50) NOT NULL
);

-- Membuat tabel Status Order Dimension
CREATE TABLE DimStatusOrder (
    StatusID INT PRIMARY KEY NOT NULL,
    StatusOrder VARCHAR(50) NOT NULL,
	StatusOrderDesc VARCHAR(50) NOT NULL
);

-- Membuat tabel Sales Order Fact
CREATE TABLE FactSalesOrder (
    OrderID INT PRIMARY KEY NOT NULL,
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES DimCustomer(CustomerID),
	ProductID INT NOT NULL FOREIGN KEY REFERENCES DimProduct(ProductID),
	Quantity INT NOT NULL,
	Amount INT NOT NULL,
	StatusID INT NOT NULL FOREIGN KEY REFERENCES DimStatusOrder(StatusID),
	OrderDate DATE NOT NULL
);

-- Query untuk cek isi tabel ketika selesai dilakukannya transform di dalam Talend
SELECT * FROM DWH_Project.dbo.FactSalesOrder

-- Membuat Summary Order Status
CREATE PROCEDURE summary_order_status
	@StatusID INT 
	AS
	BEGIN
		SELECT
			f.OrderID,
			dc.CustomerName,
			dp.ProductName,
			f.Quantity,
			ds.StatusOrder
		FROM
			DWH_Project.dbo.FactSalesOrder AS f
		JOIN
			DimCustomer AS dc ON f.CustomerID = dc.CustomerID
		JOIN
			DimProduct AS dp ON f.ProductID = dp.ProductID
		JOIN
			DimStatusOrder AS ds ON f.StatusID = ds.StatusID
		WHERE
			f.StatusID = @StatusID
	END;

-- Menggunakan Summary Order Status dengan ID 1
EXEC summary_order_status @StatusID = 1;