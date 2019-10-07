----------------------------------
--Constraints in SQL Server
----------------------------------
--Unique Constraints
DROP TABLE IF EXISTS Products_2
GO
CREATE TABLE Products_2 
( 
    ProductID int PRIMARY KEY,
    ProductName nvarchar (40) Constraint IX_ProductName UNIQUE
)
 --OR
 DROP TABLE IF EXISTS Products_2
 GO
 CREATE TABLE Products_2 
( 
    ProductID int PRIMARY KEY,
    ProductName nvarchar (40),
    CONSTRAINT IX_ProductName UNIQUE(ProductName) 
)
--OR
DROP TABLE IF EXISTS Products_2
GO
CREATE TABLE Products_2
( 
   ProductID int PRIMARY KEY,
   ProductName nvarchar (40)
)

ALTER TABLE Products_2 
    ADD CONSTRAINT IX_ProductName UNIQUE (ProductName)

--Check Constraints
DROP TABLE IF EXISTS Products_2
GO
CREATE TABLE Products_2
(
    ProductID int PRIMARY KEY,
    UnitPrice money CHECK(UnitPrice > 0 AND UnitPrice < 100)
)
--OR
DROP TABLE IF EXISTS Products_2
GO
CREATE TABLE Products_2
(
    ProductID int PRIMARY KEY,
    UnitPrice money,
    CONSTRAINT CK_UnitPrice2 CHECK(UnitPrice > 0 AND UnitPrice < 100)
)
--OR
DROP TABLE IF EXISTS Customers_2
GO
CREATE TABLE Customers_2 
(
    CustomerID int,
    Phone varchar(24),
    Fax varchar(24), 
    CONSTRAINT CK_PhoneOrFax 
           CHECK(Fax IS NOT NULL OR PHONE IS NOT NULL)
)
--OR
DROP TABLE IF EXISTS Employees_2
GO
CREATE TABLE Employees_2
(
    EmployeeID int,
    HireDate datetime
)

ALTER TABLE Employees_2
  ADD CONSTRAINT CK_HireDate CHECK(hiredate < GETDATE())

 --Check Constraints and Existing Values
 DROP TABLE IF EXISTS Employees_2
 GO
 CREATE TABLE Employees_2
(
    EmployeeID int,
    Salary money
)

INSERT INTO Employees_2 VALUES(1, -1)

ALTER TABLE Employees_2 WITH NOCHECK  ADD CONSTRAINT CK_Salary CHECK(Salary > 0)

--Check Constraints and NULL Values
INSERT INTO Employees_2 (EmployeeID, Salary) VALUES(2, NULL)

--NULL Constraints
 DROP TABLE IF EXISTS Employees_2
 GO
CREATE TABLE Employees_2 
(
    EmployeeID int PRIMARY KEY,
    FirstName varchar(50) NULL,
    LastName varchar(50) NOT NULL,
)

INSERT INTO Employees_2 VALUES(1, 'Geddy', 'Lee')
INSERT INTO Employees_2 VALUES(2, NULL, 'Lifeson')

--Default Constraints
 DROP TABLE IF EXISTS Orders_2
 GO
CREATE TABLE Orders_2
(
    OrderID int IDENTITY NOT NULL ,
    EmployeeID int NOT NULL ,
    OrderDate datetime NULL DEFAULT(GETDATE()),
    Freight money NULL DEFAULT (0) CHECK(Freight >= 0),
    ShipAddress nvarchar (60) NULL DEFAULT('NO SHIPPING ADDRESS'),
    EnteredBy nvarchar (60) NOT NULL DEFAULT(SUSER_SNAME())
)

INSERT INTO Orders_2 (EmployeeID, Freight) VALUES(1, NULL)
------------------------------------------------------------------
--Dropping Constraints
------------------------------------------------------------------
 DROP TABLE IF EXISTS Employees_2
 GO
 CREATE TABLE Employees_2
(
    EmployeeID int,
    Salary money
)
INSERT INTO Employees_2 VALUES(1, -1)
ALTER TABLE Employees_2 WITH NOCHECK  ADD CONSTRAINT CK_Salary CHECK(Salary > 0)

--Dropping Constraints
ALTER TABLE [dbo].[Employees_2] DROP CONSTRAINT [CK_Salary]
------------------------------------------------------------------
--Disabling Constraints
-----------------------------------------------------------------
DROP TABLE IF EXISTS Employees_2
 GO
 CREATE TABLE Employees_2
(
    EmployeeID int,
    Salary money
)
INSERT INTO Employees_2 VALUES(1, -1)
ALTER TABLE Employees_2 WITH NOCHECK  ADD CONSTRAINT CK_Salary CHECK(Salary > 0)

ALTER TABLE [Employees_2] NOCHECK CONSTRAINT [CK_Salary] 
ALTER TABLE [Employees_2] NOCHECK CONSTRAINT ALL

ALTER TABLE [Employees_2] CHECK CONSTRAINT [CK_Salary]
ALTER TABLE [Employees_2] CHECK CONSTRAINT ALL


--The order of Integrity checks is as follows:

--Defaults are applied as appropriate.
--NOT NULL violations are raised.
--CHECK constraints are evaluated.
--FOREIGN KEY checks of referencing tables are applied.
--FOREIGN KEY checks of referenced tables are applied.
--UNIQUE/PRIMARY KEY is checked for correctness.
--Triggers fire.

-------------------------------------------------------
--LIMPIAR CODIGO
-------------------------------------------------------
DROP TABLE IF EXISTS Products_2
DROP TABLE IF EXISTS Orders_2
DROP TABLE IF EXISTS Customers_2
DROP TABLE IF EXISTS Employees_2
