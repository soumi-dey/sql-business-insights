create database pw_aug;
use pw_aug;

-- Dataset : Customer 
CREATE TABLE Customers (
    CustomerID INT,
    CustomerName VARCHAR(50),
    City VARCHAR(30),
    JoinDate DATE
);

INSERT INTO Customers VALUES
(101, 'Rahul Sharma', 'Bangalore', '2023-01-15'),
(102, 'Priya Mehta', 'Mumbai', '2024-03-20'),
(103, 'Arjun Nair', 'Chennai', '2025-01-12'),
(104, 'Sneha Gupta', 'Delhi', '2022-07-10'),
(105, 'Kavya Reddy', 'Hyderabad', '2024-08-15'),
(106, 'Amit Verma', 'Pune', '2023-11-05'),
(107, 'Rohan Singh', 'Kolkata', '2024-05-18'),
(108, 'Simran Kaur', 'Delhi', '2025-02-01'),
(109, 'Anjali Jain', 'Mumbai', '2023-09-22'),
(110, 'Vikram Patel', 'Ahmedabad', '2022-12-30');

select * from customers;

-- Dataset : Orders
CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2),
    Status VARCHAR(20)
);

INSERT INTO Orders VALUES
(5001,101,'2025-01-05',12000,'Delivered'),
(5002,102,'2025-01-15',8500,'Pending'),
(5003,101,'2025-02-10',22000,'Delivered'),
(5004,104,'2025-02-15',4500,'Cancelled'),
(5005,103,'2025-03-01',17500,'Delivered'),
(5006,105,'2025-03-10',9800,'Pending'),
(5007,106,'2025-03-18',25000,'Delivered'),
(5008,107,'2025-04-02',14500,'Delivered'),
(5009,101,'2025-04-10',30000,'Delivered'),
(5010,109,'2025-04-15',6500,'Pending'),
(5011,110,'2025-05-01',42000,'Delivered'),
(5012,104,'2025-05-08',18000,'Delivered'),
(5013,106,'2025-05-15',7000,'Cancelled'),
(5014,102,'2025-05-20',27000,'Delivered'),
(5015,107,'2025-06-01',15500,'Pending');

select * from orders;

-- Dataset : Employees
CREATE TABLE Employees (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    ManagerID INT,
    Department VARCHAR(30),
    JoiningDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1, 'Rajesh Kumar', NULL, 'Management', '2018-01-10', 150000),
(2, 'Neha Sharma', 1, 'Sales', '2020-03-15', 90000),
(3, 'Amit Gupta', 1, 'IT', '2019-06-20', 110000),
(4, 'Priyanka Singh', 2, 'Sales', '2022-01-12', 65000),
(5, 'Vikas Patel', 2, 'Sales', '2021-09-18', 70000),
(6, 'Rohit Jain', 3, 'IT', '2023-02-05', 60000),
(7, 'Anjali Verma', 3, 'IT', '2022-11-10', 62000),
(8, 'Karan Mehta', 1, 'HR', '2021-05-25', 80000),
(9, 'Sneha Kapoor', 8, 'HR', '2024-01-05', 50000),
(10, 'Arjun Malhotra', 3, 'IT', '2024-04-15', 55000);

select * from employees;


-- Question 1 : Top 5 highest value orders along with customer names

show tables;
select * from customers; -- CustomerID
select * from orders; -- CustomerID

select c.CustomerName , o.OrderAmount
from customers c inner join orders o
on c.CustomerID =o.CustomerID 
order by o .orderAmount desc 
limit 5 ;

-- Question 2: Names Starting with A,r, or s ( Without multiple OR)

select CustomerName from customers where LEFT(CustomerName,1) IN ('A','R','S');

-- Question 3 : Pending Orders > 10,000 

select c.CustomerName , o.OrderID , o.OrderAmount , o.status
from customers c inner join orders o
on c.CustomerID =o.CustomerID 
where OrderAmount > 10000 and status = 'Pending';

-- Question 4 – Customers Joined More Than 365 Days Ago

select CustomerID , CustomerName , JoinDate , datediff(curdate(), JoinDate) as Total_Service_Days
from customers where datediff(curdate(), JoinDate) > 365;

-- Question 5 – Revenue Report with GST

SELECT OrderID, OrderAmount AS CurrentAmount,
OrderAmount * 0.18 AS GST,
OrderAmount + (OrderAmount * 0.18) AS TotalAmountAfterGST,
date_add(OrderDate, interval 15 day) AS ExpectedCollectionDate
FROM Orders ;

-- Question 6 – Customers Ranked 11th to 20th by Order Amount

SELECT c.CustomerName, o.OrderID, o.OrderAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderAmount DESC
LIMIT 10 OFFSET 10;

-- Question 7 – Customers Who Never Placed Orders

SELECT c.CustomerID, c.CustomerName, c.JoinDate,
DATEDIFF(CURDATE(), c.JoinDate) AS DaysSinceRegistration
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- Question 8 – Employee Hierarchy

select e.EmployeeName , m.employeeName as ManagerName, e.Department
 from employees e left join Employees m 
 on e.ManagerID = m.EmployeeID;

-- Question 9 – Orders Within 30 Days of Joining

select c.CustomerName , c.JoinDate , o.OrderDate , datediff(o.OrderDate , c.JoinDate) as Days_Taken_To_Place_First_Order
from customers c inner join orders o on c.CustomerID = o.OrderID 
where  datediff(o.OrderDate , c.JoinDate) <= 30 ;

-- Question 10 – Loyalty & Spending Category

SELECT c.CustomerName,sum(o.OrderAmount) AS TotalPurchaseAmount,
       if(SUM(o.OrderAmount) > 50000, 'Premium', IF(SUM(o.OrderAmount) >= 20000, 'Gold', 'Silver')) AS SpendingCategory,
       if(c.JoinDate < '2024-01-01', 'Loyal Customer', 'New Customer') as LoyaltyStatus
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
group by c.CustomerName, c.JoinDate;

-- Question 11 – Orders Above Average Order Amount

select avg(o.OrderAmount) from orders o;-- 17320

SELECT c.CustomerName, o.OrderID, o.OrderAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
where o.OrderAmount > (select avg(o.OrderAmount) from orders o);

-- Question 12 – 2nd to 6th Highest Orders

SELECT c.CustomerName, o.OrderID, o.OrderAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderAmount DESC
LIMIT 5 OFFSET 1;