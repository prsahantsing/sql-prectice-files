create table customers 
(customerid int ,
customername varchar(50) , 
phonenumber varchar(20) ,
email varchar(50)
primary key (customerid))

create table products 
(productid varchar(10) ,
productname varchar (30) ,
price decimal(15,2)
primary key (productid))

create table orders
(invoiceid int , 
customerid int , invoicedate date 
primary key (invoiceid )
foreign key(customerid) references customers (customerid))

create table salesperson 
( salespersonid VARCHAR(10) ,
salespersonname VARCHAR(60),
Salespersonphone varchar(20)
primary key (salespersonid))

create table stores
(storeid varchar(10) ,
storelocation varchar(50),
salespersonid varchar(10)
primary key (storeid )
foreign key (salespersonid) references salesperson(salespersonid))

create table orderdetails 
(invoiceid int , 
customerid int , 
productid varchar(10) ,
price decimal(10,2) ,
quantity int 
foreign key (customerid) references customers (customerid) ,
foreign key (productid) references products (productid) ,
foreign key (invoiceid) references orders (invoiceid))


---above is my version 


---below is chatgpt version 

CREATE TABLE Customers (
    customerid INT PRIMARY KEY,
    customername VARCHAR(50), 
    phonenumber VARCHAR(20),
    email VARCHAR(50)
);

CREATE TABLE Products (
    productid VARCHAR(10) PRIMARY KEY,
    productname VARCHAR(30),
    price DECIMAL(15,2)
);

CREATE TABLE Salesperson (
    salespersonid VARCHAR(10) PRIMARY KEY,
    salespersonname VARCHAR(60),
    salespersonphone VARCHAR(20)
);

CREATE TABLE Stores (
    storeid VARCHAR(10) PRIMARY KEY,
    storelocation VARCHAR(50),
    salespersonid VARCHAR(10),
    FOREIGN KEY (salespersonid) REFERENCES Salesperson(salespersonid)
);

CREATE TABLE Orders (
    invoiceid INT PRIMARY KEY,
    customerid INT,
    storeid VARCHAR(10),
    invoicedate DATE,
    FOREIGN KEY (customerid) REFERENCES Customers(customerid),
    FOREIGN KEY (storeid) REFERENCES Stores(storeid)
);

CREATE TABLE OrderDetails (
  
  invoiceid INT,
    productid VARCHAR(10),
    quantity INT,
    price DECIMAL(10,2),
    PRIMARY KEY (invoiceid, productid),
    FOREIGN KEY (invoiceid) REFERENCES Orders(invoiceid),
    FOREIGN KEY (productid) REFERENCES Products(productid)
);

select * from BankAccounts


BEGIN TRY
begin transaction
    UPDATE BankAccounts
    SET balance = balance+200
    where accountid = 1

    update  BankAccounts
   SET  balance = balance - 200
    where accountid = 2
    --as firsttransfer 
  UPDATE BankAccounts 
 SET  balance = balance+137
    where accountid = 4

    UPDATE BankAccounts
   SET balance = balance - 137
    where accountid = 3
  
  commit 
    END TRY
    BEGIN CATCH 
    ROLLback 
    print 'The error occured while tranfering money : ' + error_message ()

    END CATCH


    SELECT * FROM BankAccounts

    

BEGIN TRY 
BEGIN TRANSACTION 
-----UUPADTING BANK ACCOUNT NUMBER 2 with credit
            UPDATE BANKACCOUNTS 
            SET BALANCE = BALANCE + 200
            WHERE ACCOUNTID = 2 


    ----UPDATEING BANKACCOUNT NUMBER 1 with debit
        UPDATE BankAccounts
        SET BALANCE = BALANCE - 5000
        WHERE ACCOUNTID = 1

        ---rollback for first transaction 
        save transaction transfer1
  
  

    ----updating bankaccountid 3 with credit
           update BankAccounts
           set balance = balance + 300
           where accountid = 3

    ---updating bankaccountid 4 with debit 
        update BankAccounts
        set balance = balance - 300
        where accountid = 4
        --rollback for 2nd transfer
          SAVE TRANSACTION TRANSFER2

    COMMIT 
    PRINT 'TANSECTIONS HAS BEEN SUCCESSFULLY COMPLETED' 
    END TRY 
    BEGIN CATCH
    
            ROLLBACK;
            PRINT ' There is an error occured : ' + error_message ()
    END CATCH 



    select * from BankAccounts

create table customers 
(customerid int , 
fullname varchar(50) ,
emailid varchar(50) ,
dateofpurchase date )


drop table customers

select * from customers

create view customers_details as
select * from customers


drop view customers_details


   BEGIN TRY 
             



         