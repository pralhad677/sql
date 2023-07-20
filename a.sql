-- Create Employees table
CREATE TABLE Employees (
    EmployeeID int PRIMARY KEY,
    FirstName varchar(50),
    LastName varchar(50),
    DepartmentID int,
    HireDate date
);

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID int PRIMARY KEY,
    DepartmentName varchar(100),
    ManagerID int
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID int PRIMARY KEY,
    EmployeeID int,
    OrderDate date,
    TotalAmount decimal(10, 2)
);

-- Insert data into Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, HireDate)
VALUES
    (1, 'John', 'Doe', 1, '2020-01-15'),
    (2, 'Jane', 'Smith', 2, '2019-05-20'),
    (3, 'Michael', 'Johnson', 1, '2021-03-10'),
    (4, 'Emily', 'Williams', 3, '2022-02-01');

-- Insert data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID)
VALUES
    (1, 'Finance', 3),
    (2, 'Marketing', 2),
    (3, 'Sales', 4);

-- Insert data into Orders table
INSERT INTO Orders (OrderID, EmployeeID, OrderDate, TotalAmount)
VALUES
    (101, 1, '2022-12-05', 150.25),
    (102, 2, '2023-01-10', 300.50),
    (103, 3, '2023-02-20', 50.75),
    (104, 4, '2023-03-15', 75.30);
 
 select * from dbo.Departments;
 select * from dbo.Employees;
 select * from dbo.Orders;


 --1)Select all employees' first and last names.

 select concat(FirstName,' ',LastName) as FullName
 from dbo.Employees;

 --Retrieve the total number of employees.

 select count(*)  as totalEmployee
 from dbo.Employees;

 --List the first names of employees hired on or after '2022-01-01'.
 select FirstName 
 from dbo.Employees
 where HireDate > '2022-01-01';

 --Get the department names along with their manager's first and last names.

 select D.DepartmentName,E.FirstName,E.LastName 
 from dbo.Departments as D
 join dbo.Employees as E on D.DepartmentID = E.DepartmentID;

 --Find the average hire date year for employees in each department.

  select D.DepartmentName,avg(year(E.HireDate)) as avgYear
  from dbo.Employees as E
  join dbo.Departments as D on E.DepartmentID = D.DepartmentId
  group by D.DepartmentName;

  --Retrieve the order ID, employee's first and last name, and order date for all orders.

  select O.OrderId,concat(E.FirstName,' ',E.LastName) as FullName,O.OrderDate
  from Orders as O
  join Employees as E on E.EmployeeId=O.EmployeeId;

  
--List the employee's first name, last name, and department name for orders placed in 2023.

select E.FirstName,E.LastName,D.DepartmentName,O.OrderDate
from dbo.Employees as E
join dbo.Departments as D on D.DepartmentID = E.DepartmentID
join dbo.Orders as O on E.EmployeeId=o.EmployeeId
where OrderDate like '2023%';

--Find the highest order amount in the Orders table.
select max(TotalAmount) as maxAmount
from dbo.Orders;

--Get the employee with the most recent hire date
select top 1 * from dbo.Employees
order by HireDate desc; 

--Find the total number of orders placed by each employee.
select   E.FirstName,E.LastName,E.EmployeeId,count(O.OrderId) as totalOrders
from dbo.Employees as E
join dbo.Orders as O on E.EmployeeId=O.EmployeeId
group by E.FirstName,E.LastName,E.EmployeeId;


--Calculate the total amount of all orders for each department.
select D.DepartmentID,D.DepartmentName,D.ManagerID,count(O.OrderId) as OrdersId
from dbo.Departments as D
join dbo.Employees as E on D.DepartmentID=E.DepartmentID
join dbo.Orders as o on E.EmployeeID = O.EmployeeID
group by D.DepartmentID,D.DepartmentName,D.ManagerID
--group by D.DepartmentID,D.DepartmentName;

--List the first names of employees who haven't placed any orders.
select FirstName as DidnotOrder 
from dbo.Employees E
 where E.EmployeeId not in (
						select EmployeeID
						from dbo.Orders
 )

 select *
 from dbo.Employees as E
 where  not exists (
							select 1
							from dbo.Orders as O
							where O.EmployeeID = E.EmployeeID
 )


 --Retrieve the first and last names of employees who are managers.
 SELECT
    E.FirstName,
    E.LastName
FROM
    Employees E
JOIN
    Departments D ON E.EmployeeID = D.ManagerID;

   --Find the employee who has placed the highest number of orders.

   select top 1 E.EmployeeId,E.FirstName,E.LastName,count(O.OrderID) as maxOrders
   from Employees as E
   join Orders as O on E.EmployeeID=O.EmployeeID
   group by E.EmployeeId,E.FirstName,E.LastName
   order by maxOrders desc


   --Get the order IDs and total amounts of orders placed in 2023,
   --sorted by the total amount in ascending order.

	select OrderID,TotalAmount 
	from Orders
	where OrderDate like '2023%'
	order by TotalAmount  


