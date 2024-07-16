USE northwind

--1)We have a table called Shippers. 
--Return all the fields from all the shippers
SELECT *
FROM Shippers

--2)In the Categories table, selecting all the fields using
--this SQL:
--Select * from Categories
--…will return 4 columns. We only want to see two
--columns, CategoryName and Description.
SELECT CategoryName, Description
FROM Categories


--3)We’d like to see just the FirstName, LastName, and
--HireDate of all the employees with the Title of Sales
--Representative. Write a SQL statement that returns
--only those employees.
SELECT	FirstName, LastName, 
		CONVERT(NVARCHAR,CAST(HireDate AS DATE),103) AS HireDate
FROM Employees
WHERE Title = 'Sales representative'


--4)Now we’d like to see the same columns as above, but
--only for those employees that both have the title of
--Sales Representative, and also are in the United
--States.
SELECT	FirstName, LastName, 
		CONVERT(NVARCHAR,CAST(HireDate AS DATE),103) AS HireDate
FROM Employees
WHERE	Title = 'Sales representative' 
		AND Country = 'USA'


--5)Show all the orders placed by a specific employee.
--The EmployeeID for this Employee (Steven
--Buchanan) is 5.
SELECT	ord.OrderID,ord.CustomerID,
		CONCAT(emp.FirstName, emp.LastName) AS Name,OrderDate
FROM Orders AS ord
INNER JOIN Employees AS emp ON emp.EmployeeID = ord.EmployeeID
WHERE ord.EmployeeID = 5


--6)In the Suppliers table, show the SupplierID,
--ContactName, and ContactTitle for those Suppliers
--whose ContactTitle is not Marketing Manager.
SELECT	SupplierID, ContactName, ContactTitle
FROM Suppliers
WHERE NOT ContactTitle = 'Marketing Manager'


--7)In the products table, we’d like to see the ProductID
--and ProductName for those products where the
--ProductName includes the string “queso”.
SELECT	ProductID, ProductName
FROM Products
WHERE ProductName LIKE '%queso%'


--8)Looking at the Orders table, there’s a field called
--ShipCountry. Write a query that shows the OrderID,
--CustomerID, and ShipCountry for the orders where
--the ShipCountry is either France or Belgium.
SELECT	OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('France', 'Belgium')


--9)Now, instead of just wanting to return all the orders
--from France of Belgium, we want to show all the
--orders from any Latin American country. But we
--don’t have a list of Latin American countries in a
--table in the Northwind database. So, we’re going to
--just use this list of Latin American countries that
--happen to be in the Orders table:
--Brazil
--Mexico
--Argentina
--Venezuela
--It doesn’t make sense to use multiple Or statements
--anymore, it would get too convoluted. Use the In
--statement.
SELECT	OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('Mexico', 'Argentina','Venezuela','Brazil')


--10)For all the employees in the Employees table, show
--the FirstName, LastName, Title, and BirthDate.
--Order the results by BirthDate, so we have the oldest
--employees first.
SELECT	FirstName,LastName,Title,BirthDate
FROM Employees
ORDER BY BirthDate ASC


--11)In the output of the query above, showing the
--Employees in order of BirthDate, we see the time of
--the BirthDate field, which we don’t want. Show only
--the date portion of the BirthDate field.
SELECT	FirstName,LastName,Title,CAST(BirthDate AS DATE) AS Birthday
FROM Employees
ORDER BY BirthDate ASC


--12)Show the FirstName and LastName columns from
--the Employees table, and then create a new column
--called FullName, showing FirstName and LastName
--joined together in one column, with a space inbetween.
SELECT	FirstName, LastName, 
		CONCAT_WS(' ',FirstName,LastName) AS FullName
FROM Employees


--13)In the OrderDetails table, we have the fields
--UnitPrice and Quantity. Create a new field,
--TotalPrice, that multiplies these two together. We’ll
--ignore the Discount field for now.
--In addition, show the OrderID, ProductID, UnitPrice,
--and Quantity. Order by OrderID and ProductID.
SELECT	OrderID,ProductID,UnitPrice,Quantity, 
		(UnitPrice*Quantity) AS TotalPrice
FROM OrderDetails
ORDER BY OrderID, ProductID


--14)How many customers do we have in the Customers
--table? Show one value only, and don’t rely on getting
--the recordcount at the end of a resultset.
SELECT COUNT(*) AS CustomerQuantity
FROM Customers


--15)Show the date of the first order ever made in the
--Orders table.
SELECT TOP 1 *
FROM Orders
ORDER BY OrderDate ASC
--#2 option
SELECT MIN(OrderDate)
FROM Orders


--16)Show a list of countries where the Northwind
--company has customers.
SELECT DISTINCT Country
FROM Customers
--#2 option
SELECT Country
FROM Customers
GROUP BY Country


--17)Show a list of all the different values in the
--Customers table for ContactTitles. Also include a
--count for each ContactTitle.
--This is similar in concept to the previous question
--“Countries where there are customers”, except we
--now want a count for each ContactTitle.
SELECT ContactTitle, COUNT(*) AS Count
FROM Customers
GROUP BY ContactTitle
ORDER BY Count DESC


--18)We’d like to show, for each product, the associated
--Supplier. Show the ProductID, ProductName, and the
--CompanyName of the Supplier. Sort by ProductID.
--This question will introduce what may be a new
--concept, the Join clause in SQL. The Join clause is
--used to join two or more relational database tables
--together in a logical way.
--Here’s a data model of the relationship between
--Products and Suppliers.
SELECT	pro.ProductID, pro.ProductName, sup.CompanyName
FROM Products AS pro
INNER JOIN Suppliers AS sup ON sup.SupplierID = pro.SupplierID


--19)We’d like to show a list of the Orders that were
--made, including the Shipper that was used. Show the
--OrderID, OrderDate (date only), and CompanyName
--of the Shipper, and sort by OrderID.
--In order to not show all the orders (there’s more than
--800), show only those rows with an OrderID of less
--than 10300.
SELECT	ord.OrderID,ord.OrderDate,shi.CompanyName
FROM Orders AS ord
INNER JOIN Shippers AS shi ON shi.ShipperID = ord.ShipVia
WHERE OrderID < 10300
ORDER BY OrderID