-- Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Balance DECIMAL(10, 2)
);

-- Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100),
    SeatsAvailable INT
);

-- Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    CourseID INT
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATETIME DEFAULT GETDATE()
);

-- Sample Data
INSERT INTO Students VALUES (1, 'Prashant', 10000);
INSERT INTO Courses VALUES (101, 'SQL Server Fundamentals', 2);



select * from students
select * from courses
select * from payments
select * from enrollments

BEGIN TRY 
begin transaction;
 
 ------debiting tution fees from students table 
 update students
 set balance = balance - 5000
 where studentid = 1;

 -----updating tution fee to to payment log 
 insert into payments (STUDENTID , AMOUNT)
values (  1 , 5000 );

---saving these  2 transactions 
save transaction transfermoney
---assugning student a course 
insert into enrollments (STUDENTID , COURSEID)
values( 1 , 101 );

--updating seat count from the course 
update courses
set SeatsAvailable = SeatsAvailable - 1
where courseid = 101;

commit 
print 'All transactions has been succesfully updated'
END TRY
BEGIN CATCH 
        ROLLBACK
        print 'The is error occured while transactions : ' + ERROR_MESSAGE () 

END CATCH;



select xact_state()

select * from Students


BEGIN TRANSACTION
    update students 
    set balance = balance + 151
    where studentid = 1

    select xact_State () 
 
 commit;
  














