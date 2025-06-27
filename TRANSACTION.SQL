-- Drop if already exists
IF OBJECT_ID('BankAccounts', 'U') IS NOT NULL
    DROP TABLE BankAccounts;

-- Main table
CREATE TABLE BankAccounts (
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(100) NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL CHECK (Balance >= 0)
);
INSERT INTO BankAccounts (AccountID, AccountHolder, Balance)
VALUES
(1, 'Alice Sharma', 1000.00),
(2, 'Bob Verma', 500.00),
(3, 'Chetan Kumar', 200.00),
(4, 'Divya Singh', 800.00);

select * from BankAccounts

---Transfer ₹200 from Alice (1) to Bob (2):

begin transaction 
    update bankaccounts 
    set balance = balance + 1000
    where accountid = 2;

    update bankaccounts
    set balance = balance - 100
    where accountid = 1

    commit
   
   BEGIN TRY 
begin transaction
    ------ updating balance of account id number 1
        update BankAccounts
        set balance = balance + 500
        where accountid = 1

            ------ updating balance of account id number 2

         update BankAccounts
         set balance = balance - 500
         where accountid = 2

         commit ;
    END TRY 
         BEGIN CATCH 
                    print('An error occured while transaction ' + error_message () )
                    rollback
                 
          END CATCH

SELECT * FROM BankAccounts

BEGIN TRY 
    BEGIN TRANSACTION 
     
         UPDATE BankAccounts
         set balance = balance /0
         where accountid = 1

         commit 
         print 'the transaction is succefull balance is divided by zero'

     END TRY
     BEGIN CATCH
      ROLLBACK;
      PRINT'VALUE CANT BE DIVIDED BY ZERO; '+ ERROR_MESSAGE ()
     END CATCH



     select * from Students

     select * from BankAccounts

BEGIN TRY 
    BEGIN TRANSACTION 
        --UPDATING STUDET ACCOUNT BALANCE BY + 501.50
        UPDATE STUDENTS 
        SET BALANCE = BALANCE + 501.50
        WHERE STUDENTID = 1

        --PUTIING AN ERROR
        DECLARE @X INT = 1 / 0


        COMMIT 
        PRINT 'The banckaccount of student is updated successfully '

END TRY 
BEGIN CATCH 

PRINT 'XACT_STATE = ' + CAST (XACT_STATE () AS VARCHAR )
        if XACT_STATE() = 1 
       begin 
       commit 
       end 
       else if xact_state() = -1
       begin 
       rollback 
       end 
END CATCH;


SELECT * FROM STUDENTS





-- Clean up first (set known balance)
UPDATE STUDENTS SET BALANCE = 1000 WHERE STUDENTID = 1;

SET XACT_ABORT ON ;
-- Error-handling script
BEGIN TRY 
    BEGIN TRANSACTION;
   
    UPDATE STUDENTS 
    SET BALANCE = BALANCE + 501.50
    WHERE STUDENTID = 1;

    DECLARE @X INT = 1 / 0;

    COMMIT;
    PRINT 'SUCCESS';
END TRY 
BEGIN CATCH 
    PRINT 'XACT_STATE = ' + CAST(XACT_STATE() AS VARCHAR);
    PRINT 'ERROR = ' + ERROR_MESSAGE();

    IF XACT_STATE() = 1 
        COMMIT;
    ELSE IF XACT_STATE() = -1
        ROLLBACK;
END CATCH;




-- Drop if exists
DROP TABLE IF EXISTS Students;

-- Create table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Balance DECIMAL(10, 2),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20)
);

-- Insert sample data
INSERT INTO Students VALUES
(1, 'John Doe', 1000.00, 'john@example.com', '1234567890'),
(2, 'Jane Smith', 1200.00, 'jane@example.com', '9876543210');


-- Drop if exists
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PricePerUnit DECIMAL(10,2) NOT NULL CHECK (PricePerUnit > 0),
    TotalAmount AS (Quantity * PricePerUnit) PERSISTED,  -- Calculated
    OrderDate DATETIME NOT NULL DEFAULT GETDATE()
);
-- Sample orders
INSERT INTO Orders (CustomerName, ProductName, Quantity, PricePerUnit)
VALUES
('Ravi Kumar', 'Keyboard', 2, 850.00),
('Meena Sharma', 'Laptop', 1, 55000.00);

SET XACT_aBORT ON 
BEGIN TRY
BEGIN TRANSACTION 
    ----INSERTING A NEW CUSTOMER DETAILS 
    INSERT INTO ORDERS
   VALUES ('Pawan Singh','Mouse',-5,200.00)

   COMMIT
   PRINT 'The insertion has been completed '
END TRY 
BEGIN CATCH 
PRINT 'XACT_STATE = ' +CAST(XACT_STATE() AS VARCHAR)
 if xact_state() = -1
 BEGIN rollback
 print'The inserting is not completed ,Rollbacking the transaction' + error_message() 
 end 
 else if XACT_STATE() =1
 BEGIN 
 COMMIT 
 END 
END CATCH

