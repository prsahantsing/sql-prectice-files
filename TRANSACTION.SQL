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










