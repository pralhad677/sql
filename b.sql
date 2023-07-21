CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
VALUES
    (1, 'John', 'Doe', 101),
    (2, 'Jane', 'Smith', 102),
    (3, 'Michael', 'Johnson', 101),
    (4, 'Emily', 'Williams', 103),
    (5, 'Robert', 'Brown', 102);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName, Location)
VALUES
    (101, 'HR', 'New York'),
    (102, 'Finance', 'Chicago'),
    (103, 'IT', 'San Francisco');
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    StartDate DATE,
    EndDate DATE
);

INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate)
VALUES
    (1, 'Project A', '2023-01-15', '2023-05-30'),
    (2, 'Project B', '2023-03-01', '2023-08-15'),
    (3, 'Project C', '2023-06-10', '2023-11-20');


CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    HoursWorked INT,
    CONSTRAINT FK_EmployeeProjects_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
    CONSTRAINT FK_EmployeeProjects_Projects FOREIGN KEY (ProjectID) REFERENCES Projects (ProjectID)
);

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
VALUES
    (1, 1, 120),
    (1, 2, 200),
    (2, 1, 180),
    (3, 3, 250),
    (5, 2, 160);

 select * from dbo.Departments;
 select * from EmployeeProjects;
 select * from Employees;
 select * from Projects;

 --How do you retrieve all employees who work in the 'Finance' department?
 select E.FirstName,E.LastName
 from dbo.Employees as E
 join dbo.Departments as D on D.DepartmentId=E.DepartmentID
 where D.DepartmentName='Finance';

--Write a query to get the total number of hours worked by each employee across all projects.
select E.EmployeeID,E.FirstName,E.LastName,sum(Ep.HoursWorked) as totalHoursOfWork
from dbo.Employees as E
join dbo.EmployeeProjects as Ep on E.EmployeeID=Ep.EmployeeId
group by E.EmployeeID,E.FirstName,E.LastName
	
--Can you provide a list of projects along with the number of employees assigned to each project?
select P.ProjectName,count(E.EmployeeId) as numberOfEmployeeAssigned
from dbo.EmployeeProjects as EP
join dbo.Projects as P on EP.ProjectID=P.ProjectID
join dbo.Employees as E on Ep.EmployeeID=E.EmployeeID
group by P.ProjectName;


--How would you find the employees who have not worked on any projects yet?
select *
from dbo.Employees as E
where not exists(
			select 1
			from dbo.EmployeeProjects as EP
			join dbo.Projects as P on EP.ProjectID=P.ProjectID
			 where E.EmployeeID=EP.EmployeeID
);

--Write a query to calculate the average number of hours worked on projects for each department.
select D.DepartMentID,D.DepartmentName,avg(EP.HoursWorked) as  averageWorkOnEachDepartments
 from dbo.Employees as E
join dbo.Departments as D  on E.DepartmentID=D.DepartmentID
join dbo.EmployeeProjects as Ep   on  Ep.EmployeeID=E.EmployeeID
join dbo.Projects as P on P.ProjectID=EP.ProjectID
group by D.DepartMentID,D.DepartmentName;

--How can you get the list of employees and their corresponding project names
--for all the projects they are working on?
select FullName,string_agg(ProjectName, ',') as Project
from (select concat(E.FirstName,' ',E.LastName) as FullName,P.ProjectName
from
dbo.Employees as E
join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EMployeeID
join dbo.Projects as P on P.ProjectID=EP.ProjectID) as ABC
group by FullName ;


--Explain the differences between INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN.
--inner join
select * 
from dbo.Employees as E
inner join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID;

--left join
select * 
from dbo.Employees as E
left join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID;

--right join
select * 
from dbo.Employees as E
right join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID;

--full join
select * 
from dbo.Employees as E
full join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID;

--How do you retrieve the
--names of employees who worked on 'Project A' along with the number of hours they worked?


select concat(E.FirstName,' ',E.LastName) as FullName,ProjectName,HoursWorked
from dbo.Employees as E
join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID
join dbo.Projects as P on P.ProjectID=EP.ProjectID
where P.ProjectName='Project A';
 

 --Write a query to find the project that has the maximum number of employees assigned to it.
 --select top 1 *
 select top 1  *
 from(
 select ProjectName,NumberOfEmployee,Row_Number() over (order by NumberOfEmployee) as nm 
 from(
 select  P.ProjectName,count(E.EmployeeID) as NumberOfEmployee
 from dbo.Employees as E
 join dbo.EmployeeProjects as EP on E.EmployeeID=EP.EmployeeID
 join dbo.Projects as P on P.ProjectID=EP.ProjectID
 group by P.ProjectName) as abc) as cbd
 order by nm desc; 

 --How can you update the department name for employees who work in the 'HR' department to 'Human Resources'?
 update   dbo.Departments 
 set DepartmentName='Human Resources'
 where DepartmentName='HR';

 --Write a query to get the names of employees who worked on projects that started in the year 2023.
 select E.FirstName,E.LastName
 from dbo.Employees as E
 join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID
 join dbo.Projects as P on EP.ProjectID=p.ProjectID
 where P.StartDate like '2023%';
 

 --Can you retrieve a list of employees and the total number of hours they have worked on projects, 
 --even if they haven't worked on any projects?

 select FirstName,LastName,isnull(sum(HoursWorked),0) as totalHoursOfWork
 from(
 select   EP.HoursWorked,E.FirstName,E.LastName
 from dbo.Employees as E
 left join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID
 --join dbo.Projects as P on EP.ProjectID=p.ProjectID
 ) as asd
 group by FirstName,LastName;

 --How do you find the project with the longest duration (in terms of days) and the project with the shortest duration?
 select *, DATEDIFF(DAY, StartDate, EndDate) AS DurationInDays
 from dbo.Projects 
  where datediff(day,StartDate,EndDate)=(select max(datediff(day,StartDate,EndDate)) from dbo.Projects) or
										DATEDIFF(DAY, StartDate, EndDate)=
        (SELECT MIN(DATEDIFF(DAY, StartDate, EndDate)) FROM Projects);

--Write a query to get the names of employees and the projects they worked on,
--sorted alphabetically by employee last name.
select  E.FirstName,E.LastName,P.ProjectName
from dbo.Employees as E
join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID
join dbo.Projects as P on P.ProjectID=EP.ProjectID
order by E.LastName asc;

--How can you get the names of employees who worked on projects for which the end date is after '2023-07-01'?

select concat(E.FirstName,' ',E.LastName) as FullName,P.EndDate
from dbo.Employees as E
join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID
join dbo.Projects as P on P.ProjectID=EP.ProjectID
where P.EndDate > '2023-07-01';

--Write a query to calculate the total number of hours worked on each project,
--considering only the projects that started after '2023-03-01'.
	select      P.ProjectID,
    P.ProjectName,
    SUM(EP.HoursWorked) AS TotalHoursWorked
	from dbo.EmployeeProjects as EP
	join dbo.Projects as P on EP.ProjectID=P.ProjectID
	where P.StartDate > '2023-03-01'
	GROUP BY
    P.ProjectID,
    P.ProjectName;


	--How do you find the project with the highest total number of hours worked by employees?
	select top 1 E.EmployeeID,E.FirstName,E.LastName,sum(HoursWorked)   as totalHoursWorked
	from dbo.Employees as E
join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID
join dbo.Projects as P on P.ProjectID=EP.ProjectID
group by E.EmployeeID,E.FirstName,E.LastName
order by  totalHoursWorked desc

--Write a query to retrieve the names of employees who worked on 'Project B' and their corresponding department names.
select E.FirstName,E.LastName,P.ProjectName,D.DepartmentName
from dbo.Employees as E
join dbo.DepartMents as D on D.DepartmentID=E.DepartmentID
join dbo.EmployeeProjects as EP on EP.EmployeeID=E.EmployeeID
join dbo.Projects as P on P.ProjectID=EP.ProjectID
where ProjectName='Project B'
 