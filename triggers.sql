


 create  table employeelogs 
 (id  int identity(1,1) , emplogdetails varchar (250) , dateandtime datetime )

alter trigger trg_employeelog_after_insert 
 on dbo.employees 
 after insert 
 as 
 begin 
		insert into employeelogs (emplogdetails  , dateandtime )
		select 
		'A new employee has been added with the employeeid : '+ cast(employeeid as varchar (20)),
	     getdate() as currentdatetime
	     from inserted
 end 


 select * from dbo.employees
 select * from employeelogs

 insert into dbo.employees
 (employeeid , name , managerid )
 values (11 , 'National HR' , 10)

 create  TRIGGER trg_dboemployes_after_delete 
 on dbo.employees
 after delete 
 as 
 begin 
			insert into employeesdeletelogs
			select employeeid , 
			'A employee has been deleted the employeeid is : '+cast(employeeid as varchar (20)),
			getdate()
			from deleted 
 end

 create table employeesdeletelogs 
 (employeeid int , deletelog varchar (250) , dateandtime datetime )
 
 select * from dbo.employees
 select * from employeesdeletelogs


 delete from dbo.employees
 where employeeid = 10


alter trigger trg_dboemployee_after_update 
 on dbo.employees
 after update 
 as 
 begin
        insert into dbo.employeelogs (emplogdetails  , dateandtime )
		select
		'the date of the employee has been update with employeeid '+cast(i.employeeid as varchar (20) ) +
		case 
			when i.name <> d.name then ' employee name has change from : '+d.name +'to '+i.name else '' end  +
			case when i.managerid <> d.managerid then ' Managerid  has change from : '+ cast(d.managerid as varchar(20))
			+'to '+cast(i.managerid as varchar(20)) else '' 
		end ,
		getdate() 
		from inserted as i
		inner join deleted as d 
		on i.EmployeeID = d.EmployeeID
end


 select * from dbo.employees
 select * from employeelogs

 delete from employeelogs 
 where id = 3

 update dbo.employees
 set name = 'tax officer'
 where employeeid = 9

