USE Northwind

--20) For this problem, we’d like to see the total number of
--products in each category. Sort the results by the total
--number of products, in descending order.
SELECT	cat.CategoryName, COUNT(*) AS NumberOfProducts
FROM Products AS pro
INNER JOIN Categories AS cat ON cat.CategoryID = pro.CategoryID
GROUP BY cat.CategoryName
ORDER BY NumberOfProducts DESC


--21) In the Customers table, show the total number of
--customers per Country and City.
SELECT Country, City, COUNT(*) AS AmountCustomers
FROM Customers
GROUP BY Country,City
ORDER BY  AmountCustomers DESC,Country, City


--22)What products do we have in our inventory that
--should be reordered? For now, just use the fields
--UnitsInStock and ReorderLevel, where UnitsInStock
--is less than the ReorderLevel, ignoring the fields
--UnitsOnOrder and Discontinued.
--Order the results by ProductID.
SELECT	ProductName, UnitsInStock,ReorderLevel
FROM Products
WHERE UnitsInStock < ReorderLevel
ORDER BY ProductID


--23)Now we need to incorporate these fields—
--UnitsInStock, UnitsOnOrder, ReorderLevel,
--Discontinued—into our calculation. We’ll define
--“products that need reordering” with the following:
--UnitsInStock plus UnitsOnOrder are less than
--or equal to ReorderLevel
--The Discontinued flag is false (0).
SELECT	ProductName, UnitsInStock,ReorderLevel
FROM Products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel
AND Discontinued = 0
ORDER BY ProductID


--24)A salesperson for Northwind is going on a business
--trip to visit customers, and would like to see a list of
--all customers, sorted by region, alphabetically.
--However, he wants the customers with no region
--(null in the Region field) to be at the end, instead of
--at the top, where you’d normally find the null values.
--Within the same region, companies should be sorted
--by CustomerID.
SELECT	CustomerID,Region,1 AS TRegion,CompanyName
FROM Customers
WHERE Region IS NOT NULL
UNION
SELECT	CustomerID,Region, 0 AS TRegion,CompanyName
FROM Customers
WHERE Region IS NULL
ORDER BY TRegion DESC,Region,CustomerID



--25)Some of the countries we ship to have very high
--freight charges. We'd like to investigate some more
--shipping options for our customers, to be able to
--offer them lower freight charges. Return the three
--ship countries with the highest average freight
--overall, in descending order by average freight.
SELECT	TOP 3 ord.ShipCountry, 
		AVG(ord.Freight) AS Average
FROM Orders AS ord
INNER JOIN Shippers AS shi ON shi.ShipperID = ord.ShipVia
GROUP BY ord.ShipCountry
ORDER BY Average DESC


--26)We're continuing on the question above on high
--freight charges. Now, instead of using all the orders
--we have, we only want to see orders from the year
--2015.
SELECT	TOP 3 ord.ShipCountry, 
		AVG(ord.Freight) AS Average
FROM Orders AS ord
INNER JOIN Shippers AS shi ON shi.ShipperID = ord.ShipVia
WHERE YEAR(ord.OrderDate) = '2015'
GROUP BY ord.ShipCountry
ORDER BY Average DESC


--27)Notice when you run this, it gives Sweden as the
--ShipCountry with the third highest freight charges.
--However, this is wrong - it should be France.
--What is the OrderID of the order that the (incorrect)
--answer above is missing?
SELECT *
FROM Orders AS ord
WHERE YEAR(ord.OrderDate) = '2015'
EXCEPT
SELECT *
FROM Orders 
WHERE OrderDate BETWEEN '1/1/2015' AND '12/31/2015'


--28)We're continuing to work on high freight charges.
--We now want to get the three ship countries with the
--highest average freight charges. But instead of
--filtering for a particular year, we want to use the last
--12 months of order data, using as the end date the last
--OrderDate in Orders.
SELECT	TOP 3 ord.ShipCountry, 
		AVG(ord.Freight) AS Average
FROM Orders AS ord
INNER JOIN Shippers AS shi ON shi.ShipperID = ord.ShipVia
WHERE ord.OrderDate BETWEEN (
	CAST(CONCAT( 
		(SELECT TOP 1 YEAR(OrderDate)-1 FROM Orders ORDER BY OrderDate DESC),'-',
		(SELECT TOP 1 MONTH(OrderDate) FROM Orders ORDER BY OrderDate DESC),'-',
		'1'
		) AS DATE)
	)
AND
	(CAST(CONCAT( 
		(SELECT TOP 1 YEAR(OrderDate) FROM Orders ORDER BY OrderDate DESC),'-',
		(SELECT TOP 1 MONTH(OrderDate) FROM Orders ORDER BY OrderDate DESC),'-',
		'1'
		) AS DATE)
	)
GROUP BY ord.ShipCountry
ORDER BY Average DESC

--Answer with hints
--option 1
SELECT	TOP 3 ord.ShipCountry, 
		AVG(ord.Freight) AS Average
FROM Orders AS ord
INNER JOIN Shippers AS shi ON shi.ShipperID = ord.ShipVia
WHERE ord.OrderDate BETWEEN
	(SELECT DATEADD(YEAR,-1,(SELECT MAX(OrderDate) FROM Orders)))
	AND
	(SELECT MAX(OrderDate) FROM Orders)
GROUP BY ord.ShipCountry
ORDER BY Average DESC
--option 2
SELECT	TOP 3 ord.ShipCountry, 
		AVG(ord.Freight) AS Average
FROM Orders AS ord
INNER JOIN Shippers AS shi ON shi.ShipperID = ord.ShipVia
WHERE ord.OrderDate > (SELECT DATEADD(YEAR,-1,(SELECT MAX(OrderDate) FROM Orders)))
GROUP BY ord.ShipCountry
ORDER BY Average DESC


--29)We're doing inventory, and need to show information
--like the below, for all orders. Sort by OrderID and
--Product ID.
SELECT	emp.EmployeeID, emp.LastName, ord.OrderID,
		pro.ProductName, odd.Quantity
FROM Orders AS ord
INNER JOIN Employees AS emp ON emp.EmployeeID = ord.EmployeeID
INNER JOIN OrderDetails AS odd ON odd.OrderID = ord.OrderID
INNER JOIN Products AS pro ON pro.ProductID = odd.ProductID
ORDER BY ord.OrderID, odd.ProductID


--30)There are some customers who have never actually
--placed an order. Show these customers.
SELECT	CompanyName
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders)
--option with hints
SELECT	CustomerID = cus.CustomerID, 
		OrderID = ord.OrderID
FROM Customers AS cus
LEFT JOIN Orders AS ord ON ord.CustomerID = cus.CustomerID
WHERE ord.OrderID IS NULL 


--31) One employee (Margaret Peacock, EmployeeID 4)
--has placed the most orders. However, there are some
--customers who've never placed an order with her.
--Show only those customers who have never placed
--an order with her.
SELECT DISTINCT cus.CustomerID
FROM Customers AS cus
INNER JOIN Orders AS ord ON ord.CustomerID = ord.CustomerID
WHERE cus.CustomerID
NOT IN (SELECT DISTINCT CustomerID FROM Orders WHERE EmployeeID = 4)


