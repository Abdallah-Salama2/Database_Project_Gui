Use TEST
Go

--Alter database Airlines modify name = Nesma_Airlines;

--Run all modification after Creating Tables 


-- الطائره
Create Table AirCraft(
AircraftId Int Primary Key,
Aircraft_Number VarChar(32) Not null,
Capacity Int Not null, --no.of seats available
Mf_Comp Varchar(128) Not null,
Mf_Date DATETIME NOT NULL );

Alter Table AirCraft
Alter Column Mf_Date Date;



--Route route of the flight id , for every route , airport src where flight start , dest ,routcode genered by src,dest
Create Table Route(
RouteId int Primary key,
Airport_Src VarChar(128) not null,
Destination VarChar(128) not null,
Route_Code VarChar(16) not null Unique);

--AirFare اجرة الرحله بالنسبه الطياره 
--Af_Id , Fare بيخزن الاجره بتاعت الرحله , FsC بيخزن اجره البنزين بتاعت الرحله
--Route_id forign key taken from Route table to calc fare 
Create Table AirFare(
AirfareId Int Primary key,
Route_id Int  Foreign key References Route(RouteId),
Fare Money not null,
FSC Money not null,); 



-- Flight Schedule معاد الرحله, Flight_Id for every trip
-- Flight_date ,Deprature وقت اقلاع الطائره ,Arrival وقت هبوط الطائره
-- AirCraft_Id Foregin key Refers to the plane of the flight Scehduled
Create Table Flight_Schedule(
FlightId Int Primary Key ,
Flight_Date Date Not null,
Departure Time not null,
Arrival Time not null,
AirCraft_id INT Foreign Key References AirCraft(AircraftId),
NetFare INT  Foreign Key References AirFare(AirfareId));

--Some Modifications
Alter Table dbo.Flight_Schedule
DROP CONSTRAINT [FK__Flight_Sc__NetFa__3F466844];
Alter Table Flight_Schedule
Drop Column  NetFare;

Drop Table AirFare;


Alter Table Flight_Schedule
Add Route_id INT Foreign Key References Route(RouteID);


-- Discounts الخصومات والعروص
-- لو اطفال فخصومه 10% مثلا 
Create Table Discounts(
DiscId int Primary Key,
Title VarChar(32), -- سبب الخصومه
Amount Int 
);
--Some Modifications
EXEC SP_RENAME 'Discounts.Amount' , 'Amount% ', 'COLUMN'; -- change column name


--Charges غرامات
--سبب الغرامه,كميه الغرامه,سبب هذه الكميه
Create Table Charges(
ChargeId INT Primary Key,
Title VarChar(32),
Amount INT,
Descr VarChar(255) );


-- Country 
Create Table Country(
CountryId Int Primary key,
CountryName VarChar(32) Not null);


--State
Create Table State(
StateId Int Primary Key,
StateName Varchar(32),
Country_id INT Foreign Key References Country(CountryId));


--Contact 
-- Passenger cell , email needed for info about Transaction flights 
Create Table Contact(
ContactId Int Primary key,
Email VarChar(16) not null,
CellPhone Varchar(16) not null,
Addr Varchar(64) ,
State_id INT Foreign Key References State(StateId));

-- Some Modifications
Alter Table Contact
Drop Column Addr ;

Alter Table Contact
Alter Column Email Varchar(64);

Alter Table Contact
Alter Column CellPhone Varchar(64);



--Passengers Info
Create Table Passengers_info(
PassengerId int Primary key,
Name varchar(64) not null,
Age Int not null,
Street VarChar(64) NOt null,
Nationality Varchar(16) Not null);

-- Some Modifications
EXEC SP_RENAME 'Passengers_info.Street' , 'Address', 'COLUMN'; -- change column name
EXEC sp_rename 'Passengers_info', 'Passengers';  -- to change table name

Alter Table Passengers
Add Contact_id INT Foreign Key References Contact(ContactId); -- Add foreign key



--Drop Table Passengers;



-- فروح نسمه للطيران زي الي في وسط البلد الي الموظفين بيشتغلوا فيها
Create Table Branch(
BranchId Int Primary Key,
Center VarChar(32) not null, -- branch title
Addr VarChar(32) not null,--Addr of branch
State_id INT Foreign Key References State(StateId) --State of the branch
);

Alter Table Branch
Drop Column Addr;




--Employees
Create Table Employee(
EmpId Int Primary Key,
Name Varchar(32) not null,
Addr Varchar(32) not null,
Branch_id INT Foreign Key References Branch(BranchId),-- branch where emp work at
Email Varchar(32) not null,
Desgination Varchar(32) not null,
Tel Varchar(16) not null);

-- Some Modifications
EXEC SP_RENAME 'Employee.Desgination' , 'JobId', 'COLUMN'; -- change column name

Alter table Employee
Drop Column Addr;

Alter table Employee
ADD  Hire_date date;


-- Transactions table
--  المعاملات كلها ,المسافر و الرحله الي هياخدها ,هيلغيها ولا لا , لو لغاها فيه غرامات لو ملغاش يبقا (نال
-- discounts based on discounts table 

Create Table Transactions(
TransId Int Primary Key,
BookingDate DateTime not null,
DepartureDate Datetime not null,
Passenger_id INT Foreign Key References Passengers(PassengerId),
Flight_id INT Foreign Key References Flight_Schedule(FlightId),
cancellation bit,--0 for Reservation, 1 for Cancellation
Employee_id INT Foreign Key References Employee(EmpId),
Charges_id INT Foreign Key References Charges(ChargeId),
Discount_id INT Foreign Key References Discounts(DiscId),
);

-- Some Modifications
Alter Table  Transactions
Add FlightPrice Money;

Alter Table  Transactions
Add cancellation Money;

Alter Table  Transactions
Alter Column BookingDate nvarchar(50);

Alter Table  Transactions
Alter Column DepartureDate nvarchar(50);

--Select * From AirFare;

Select * From AirCraft;
Select * From Branch;
Select * From Charges;
Select * From Country;
Select * From Discounts;
Select * From Employee;
Select * From Flight_schedule;
Select * From Route;
Select * From State;
Select * From Transactions