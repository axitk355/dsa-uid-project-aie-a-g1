Create database Railway;

Use Railway;

Create Table Admin(
	UserID varchar(100) primary key,
    Password varchar(100)
);

Create Table Userdetails(
	ID varchar(100) primary key,
    Firstname varchar(100),
    Middlename varchar(100),
    Lastname varchar(100),
    Password varchar(200),
    Securityquestion varchar(200),
    Securityanswer varchar(300),
	DOB date,
    Occupation varchar(100),
    Martialstatus varchar(20),
    Nationality varchar(100),
    Gender varchar(20),
    Email varchar(200),
    Mobile bigint,
    Flatno varchar(50),
    Street varchar(100),
    Locality varchar(100),
    State varchar(100),
    Pincode bigint,
    City varchar(100)
);

Create Table Passengerdetails(
	PassengerID int not null unique auto_increment,
	ID varchar(100),
    Name varchar(200),
    Gender varchar(20),
    Foodtype varchar(20),
    Age int,
    primary key(PassengerID),
    foreign key(ID) references Userdetails(ID)
);

Create Table Station(
	Stationcode varchar(10) primary key,
    Stationname varchar(200)
);

Create Table Foodservice(
	Foodservicetype varchar(100) primary key,
    Included boolean,
    BVegprice int,
    BNVegprice int,
    LVegprice int,
    LNVegprice int,
    Snacks int,
    DVegprice int,
    DNVegprice int
);

Create Table Traincategory(
	Category varchar(100) primary key,
    SLcompartments int,
    SLseats int,
    3Acompartments int,
    3Aseats int,
    2Acompartments int,
    2Aseats int,
    1Acompartments int,
    1Aseats int,
    CCcompartments int,
    CCseats int,
    Totalseats int,
    Foodservicetype varchar(100),
    foreign key(Foodservicetype) references Foodservice(Foodservicetype)
);

Create Table Traindetails(
	Trainno int primary key,
    Trainname varchar(100),
    Traincategory varchar(50),
    Startstation varchar(10),
    Starttime time,
    Endstation varchar(10),
    Endtime time,
    Totalhalts int,
    Monday boolean,
    Tuesday boolean,
    Wednesday boolean,
    Thursday boolean,
    Friday boolean,
    Saturday boolean,
    Sunday boolean,
    foreign key(Traincategory) references Traincategory(Category),
    foreign key(Startstation) references Station(Stationcode),
    foreign key(Endstation) references Station(Stationcode)
);

Create Table Ticket(
	PNR bigint not null,
    PassengerID int,
    ID varchar(100),
    Category varchar(100),
    Bookingtype varchar(100),
    Trainno int,
    Status varchar(25),
    Seat int,
    Boarding varchar(10),
    Boardingtime time,
    Destination varchar(10),
    Arrivaltime time,
    Date date,
    Price int,
    primary key(PNR,PassengerID),
    foreign key(PassengerID) references Passengerdetails(PassengerID),
    foreign key(Trainno) references Traindetails(Trainno),
    foreign key(ID) references Userdetails(ID),
    foreign key(Boarding) references Station(Stationcode),
    foreign key(Destination) references Station(Stationcode)
);

Create Table Route(
	RouteID bigint,
    Trainno int,
    Deptstation varchar(10),
    Depttime time,
    Deptday int,
    Arrivalstation varchar(10),
    Arrivaltime time,
    Arrivalday int,  
    Stopnumber int,
    primary key (RouteID,Trainno),
    foreign key (Trainno) references Traindetails(Trainno) on delete cascade,
    foreign key (Deptstation) references Station(Stationcode) on delete cascade,
    foreign key (Arrivalstation) references Station(Stationcode) on delete cascade    
);

Create Table Generalrouteprices(
	RouteID bigint primary key,
    SLprice int,
    3Aprice int,
    2Aprice int,
    1Aprice int,
    CCprice int,
    foreign key(RouteID) references Route(RouteID) on delete cascade
);

Create Table Tatkalrouteprices(
	RouteID bigint primary key,
    SLprice int,
    3Aprice int,
    2Aprice int,
    1Aprice int,
    CCprice int,
    foreign key(RouteID) references Route(RouteID) on delete cascade
);

Create Table Generalseatavailability(
	RouteID bigint,
    Trainno int,
    Date date,
    SLseats int,
    SLCF int,
    SLWL int,
    SLRAC int,
    3Aseats int,
    3ACF int,
    3AWL int,
    3ARAC int,
    2Aseats int,
    2ACF int,
    2AWL int,
    2ARAC int,
    1Aseats int,
    1ACF int,
    1AWL int,
    1ARAC int,
    CCseats int,
    CCCF int,
    CCWL int,
    CCRAC int,
    primary key (RouteID,Trainno,Date),
    foreign key (Trainno) references Route(Trainno) on delete cascade,
    foreign key (RouteID) references Route(RouteID) on delete cascade
);

Create Table Tatkalseatavailability(
	RouteID bigint,
    Trainno int,
    Date date,
    SLseats int,
    SLCF int,
    SLWL int,
    SLRAC int,
    3Aseats int,
    3ACF int,
    3AWL int,
    3ARAC int,
    2Aseats int,
    2ACF int,
    2AWL int,
    2ARAC int,
    1Aseats int,
    1ACF int,
    1AWL int,
    1ARAC int,
    CCseats int,
    CCCF int,
    CCWL int,
    CCRAC int,
    primary key (RouteID,Trainno,Date),
    foreign key (Trainno) references Route(Trainno) on delete cascade,
    foreign key (RouteID) references Route(RouteID) on delete cascade
);

Insert into Foodservice values ("Special",1,60,80,180,200,50,230,250);
Insert into Foodservice values ("Normal",0,40,50,80,100,30,100,120);

Insert into admin values ("Team1",1234);

Insert into Station values ("BCT","Mumbai Central");
Insert into Station values ("BVI","Borivali");
Insert into Station values ("VAPI","Vapi");
Insert into Station values ("ST","Surat");
Insert into Station values ("BH","Bharuch Junction");
Insert into Station values ("BRC","Vadodara Junction");
Insert into Station values ("ANND","Anand Junction");
Insert into Station values ("ND","Nadiad Junction");
Insert into Station values ("ADI","Ahmedabad Junction");

Insert into Traincategory values ("Special",0,0,0,0,0,0,0,0,5,50,50,"Special");

Insert into Traindetails values (12009,"Shatabdi express","Special","BCT","06:25:00","ADI","13:10:00",8,1,1,1,1,1,1,0);

Insert into Route values (1,12009,"BCT","06:25:00",1,"BVI","06:57:00",1,1);
Insert into Route values (2,12009,"BVI","06:59:00",1,"VAPI","08:28:00",1,2);
Insert into Route values (3,12009,"VAPI","08:30:00",1,"ST","09:40:00",1,3);
Insert into Route values (4,12009,"ST","09:42:00",1,"BH","10:24:00",1,4);
Insert into Route values (5,12009,"BH","10:26:00",1,"BRC","11:15:00",1,5);
Insert into Route values (6,12009,"BRC","11:17:00",1,"ANND","11:50:00",1,6);
Insert into Route values (7,12009,"ANND","11:52:00",1,"ND","12:07:00",1,7);
Insert into Route values (8,12009,"ND","12:09:00",1,"ADI","13:10:00",1,8);

Insert into Generalrouteprices values (1,0,0,0,0,100);
Insert into Generalrouteprices values (2,0,0,0,0,250);
Insert into Generalrouteprices values (3,0,0,0,0,100);
Insert into Generalrouteprices values (4,0,0,0,0,100);
Insert into Generalrouteprices values (5,0,0,0,0,100);
Insert into Generalrouteprices values (6,0,0,0,0,70);
Insert into Generalrouteprices values (7,0,0,0,0,40);
Insert into Generalrouteprices values (8,0,0,0,0,100);

Insert into Tatkalrouteprices values (1,0,0,0,0,120);
Insert into Tatkalrouteprices values (2,0,0,0,0,270);
Insert into Tatkalrouteprices values (3,0,0,0,0,120);
Insert into Tatkalrouteprices values (4,0,0,0,0,120);
Insert into Tatkalrouteprices values (5,0,0,0,0,120);
Insert into Tatkalrouteprices values (6,0,0,0,0,80);
Insert into Tatkalrouteprices values (7,0,0,0,0,50);
Insert into Tatkalrouteprices values (8,0,0,0,0,120);

Insert into Generalseatavailability values (1,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (2,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (3,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (4,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (5,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (6,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (7,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (8,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);

Insert into Tatkalseatavailability values (1,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (2,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (3,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (4,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (5,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (6,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (7,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (8,12009,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);

Insert into Traindetails values (12010,"Shatabdi express","Special","ADI","14:30:00","BCT","21:35:00",8,1,1,1,1,1,1,0);

Insert into Route values (9,12010,"ADI","14:30:00",1,"ND","15:08:00",1,1);
Insert into Route values (10,12010,"ND","15:10:00",1,"ANND","15:28:00",1,2);
Insert into Route values (11,12010,"ANND","15:30:00",1,"BRC","16:12:00",1,3);
Insert into Route values (12,12010,"BRC","16:14:00",1,"BH","17:01:00",1,4);
Insert into Route values (13,12010,"BH","17:03:00",1,"ST","17:55:00",1,5);
Insert into Route values (14,12010,"ST","17:57:00",1,"VAPI","19:00:00",1,6);
Insert into Route values (15,12010,"VAPI","19:02:00",1,"BVI","20:43:00",1,7);
Insert into Route values (16,12010,"BVI","20:45:00",1,"BCT","21:35:00",1,8);

Insert into Generalrouteprices values (9,0,0,0,0,100);
Insert into Generalrouteprices values (10,0,0,0,0,40);
Insert into Generalrouteprices values (11,0,0,0,0,70);
Insert into Generalrouteprices values (12,0,0,0,0,100);
Insert into Generalrouteprices values (13,0,0,0,0,100);
Insert into Generalrouteprices values (14,0,0,0,0,100);
Insert into Generalrouteprices values (15,0,0,0,0,250);
Insert into Generalrouteprices values (16,0,0,0,0,100);

Insert into Tatkalrouteprices values (9,0,0,0,0,120);
Insert into Tatkalrouteprices values (10,0,0,0,0,50);
Insert into Tatkalrouteprices values (11,0,0,0,0,80);
Insert into Tatkalrouteprices values (12,0,0,0,0,120);
Insert into Tatkalrouteprices values (13,0,0,0,0,120);
Insert into Tatkalrouteprices values (14,0,0,0,0,120);
Insert into Tatkalrouteprices values (15,0,0,0,0,270);
Insert into Tatkalrouteprices values (16,0,0,0,0,120);

Insert into Generalseatavailability values (9,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (10,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (11,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (12,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (13,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (14,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (15,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (16,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);

Insert into Tatkalseatavailability values (9,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (10,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (11,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (12,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (13,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (14,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (15,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (16,12010,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);

Insert into Station values ("JHS","Jhansi Junction");
Insert into Station values ("GWL","Gwalior Junction");
Insert into Station values ("AGC","Agra Cantt");
Insert into Station values ("NZM","Hazrat Nizamuddin");

Insert into Traindetails values (12049,"Gatimaan express","Special","JHS","15:05:00","NZM","19:30:00",3,1,1,1,1,0,1,1);

Insert into Route values (17,12049,"JHS","15:05:00",1,"GWL","16:03:00",1,1);
Insert into Route values (18,12049,"GWL","16:05:00",1,"AGC","17:40:00",1,2);
Insert into Route values (19,12049,"AGC","17:45:00",1,"NZM","19:30:00",1,3);

Insert into Generalrouteprices values (17,0,0,0,0,100);
Insert into Generalrouteprices values (18,0,0,0,0,150);
Insert into Generalrouteprices values (19,0,0,0,0,175);

Insert into Tatkalrouteprices values (17,0,0,0,0,120);
Insert into Tatkalrouteprices values (18,0,0,0,0,175);
Insert into Tatkalrouteprices values (19,0,0,0,0,200);

Insert into Generalseatavailability values (17,12049,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (18,12049,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);
Insert into Generalseatavailability values (19,12049,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,0,0,0);

Insert into Tatkalseatavailability values (17,12049,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (18,12049,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);
Insert into Tatkalseatavailability values (19,12049,"2026:10:24",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0);

Insert into Station values ("HWH","Howrah Junction");
Insert into Station values ("BWN","Barddhaman Junction");
Insert into Station values ("MDP","Madhupur Junction");
Insert into Station values ("JSME","Jasidih Junction");
Insert into Station values ("PNBE","Patna Junction");
Insert into Station values ("DDU","Pt DD Upadhyaya Junction");
Insert into Station values ("PRYJ","Prayagraj Junction");
Insert into Station values ("CNB","Kanpur Ctrl");
Insert into Station values ("NDLS","New Delhi");

Insert into Traincategory values ("Specialsleeper",0,0,3,30,2,20,1,10,0,0,60,"Special");

Insert into Traindetails values (12305,"Rajdhani express","Specialsleeper","HWH","14:05:00","NDLS","10:00:00",8,0,0,0,0,0,0,1);

Insert into Route values (20,12305,"HWH","14:05:00",1,"BWN","15:08:00",1,1);
Insert into Route values (21,12305,"BWN","15:10:00",1,"MDP","17:12:00",1,2);
Insert into Route values (22,12305,"MDP","17:15:00",1,"JSME","17:40:00",1,3);
Insert into Route values (23,12305,"JSME","17:44:00",1,"PNBE","20:55:00",1,4);
Insert into Route values (24,12305,"PNBE","21:05:00",1,"DDU","00:42:00",2,5);
Insert into Route values (25,12305,"DDU","00:52:00",2,"PRYJ","02:40:00",2,6);
Insert into Route values (26,12305,"PRYJ","02:42:00",2,"CNB","04:47:00",2,7);
Insert into Route values (27,12305,"CNB","04:52:00",2,"NDLS","10:00:00",2,8);

Insert into Generalrouteprices values (20,0,100,130,160,0);
Insert into Generalrouteprices values (21,0,200,260,320,0);
Insert into Generalrouteprices values (22,0,50,70,90,0);
Insert into Generalrouteprices values (23,0,300,390,480,0);
Insert into Generalrouteprices values (24,0,100,130,160,0);
Insert into Generalrouteprices values (25,0,70,90,110,0);
Insert into Generalrouteprices values (26,0,40,60,80,0);
Insert into Generalrouteprices values (27,0,100,130,160,0);

Insert into Tatkalrouteprices values (20,0,120,160,210,0);
Insert into Tatkalrouteprices values (21,0,240,290,360,0);
Insert into Tatkalrouteprices values (22,0,70,90,110,0);
Insert into Tatkalrouteprices values (23,0,340,420,520,0);
Insert into Tatkalrouteprices values (24,0,120,160,210,0);
Insert into Tatkalrouteprices values (25,0,90,120,160,0);
Insert into Tatkalrouteprices values (26,0,50,80,120,0);
Insert into Tatkalrouteprices values (27,0,120,160,210,0);

Insert into Generalseatavailability values (20,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (21,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (22,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (23,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (24,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (25,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (26,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (27,12305,"2026:10:24",0,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);

Insert into Tatkalseatavailability values (20,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (21,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (22,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (23,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (24,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (25,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (26,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (27,12305,"2026:10:24",0,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);

Insert into Station values ("MAS","Chennai Central");
Insert into Station values ("SPE","Sullurupeta");
Insert into Station values ("NYP","Nayudupeta");
Insert into Station values ("GDR","Gudur Junction");
Insert into Station values ("BTTR","Bitragunta");
Insert into Station values ("KVZ","Kavali");
Insert into Station values ("SKM","Singarayakonda");
Insert into Station values ("OGL","Ongole");
Insert into Station values ("CLX","Chirala");
Insert into Station values ("BPP","Bapatla");
Insert into Station values ("NDO","Nidubrolu");
Insert into Station values ("TEL","Tenali Junction");
Insert into Station values ("SAP","Sattenapalle");
Insert into Station values ("PGRL","Piduguralla");
Insert into Station values ("NDKD","Nadikode");
Insert into Station values ("VNUP","Vishnupuram");
Insert into Station values ("MRGA","Miryalaguda");
Insert into Station values ("NLDA","Nalgonda");
Insert into Station values ("SC","Secunderabad Junction");
Insert into Station values ("HYB","Hyderabad Decan");
Insert into Station values ("NLR","Nellore");
Insert into Station values ("GNT","Guntur Junction");

Insert into Traincategory values ("Express",4,40,3,30,2,20,1,10,0,0,100,"Normal");

Insert into Traindetails values (12603,"Hyderabad express","Express","MAS","16:45:00","HYB","05:45:00",21,1,1,1,1,1,1,1);

Insert into Route values (28,12603,"MAS","16:45:00",1,"SPE","17:59:00",1,1);
Insert into Route values (29,12603,"SPE","18:00:00",1,"NYP","18:24:00",1,2);
Insert into Route values (30,12603,"NYP","18:25:00",1,"GDR","19:15:00",1,3);
Insert into Route values (31,12603,"GDR","19:18:00",1,"NLR","19:44:00",1,4);
Insert into Route values (32,12603,"NLR","19:45:00",1,"BTTR","20:14:00",1,5);
Insert into Route values (33,12603,"BTTR","20:15:00",1,"KVZ","20:29:00",1,6);
Insert into Route values (34,12603,"KVZ","20:30:00",1,"SKM","20:54:00",1,7);
Insert into Route values (35,12603,"SKM","20:55:00",1,"OGL","21:26:00",1,8);
Insert into Route values (36,12603,"OGL","21:27:00",1,"CLX","22:02:00",1,9);
Insert into Route values (37,12603,"CLX","22:03:00",1,"BPP","22:14:00",1,10);
Insert into Route values (38,12603,"BPP","22:15:00",1,"NDO","22:32:00",1,11);
Insert into Route values (39,12603,"NDO","22:33:00",1,"TEL","23:19:00",1,12);
Insert into Route values (40,12603,"TEL","23:20:00",1,"GNT","00:01:00",2,13);
Insert into Route values (41,12603,"GNT","00:10:00",2,"SAP","00:50:00",2,14);
Insert into Route values (42,12603,"SAP","00:51:00",2,"PGRL","01:16:00",2,15);
Insert into Route values (43,12603,"PGRL","01:17:00",2,"NDKD","01:40:00",2,16);
Insert into Route values (44,12603,"NDKD","01:41:00",2,"VNUP","01:57:00",2,17);
Insert into Route values (45,12603,"VNUP","01:58:00",2,"MRGA","02:20:00",2,18);
Insert into Route values (46,12603,"MRGA","02:21:00",2,"NLDA","02:50:00",2,19);
Insert into Route values (47,12603,"NLDA","02:51:00",2,"SC","05:15:00",2,20);
Insert into Route values (48,12603,"SC","05:20:00",2,"HYB","05:45:00",2,21);

Insert into Generalrouteprices values (28,60,100,130,160,0);
Insert into Generalrouteprices values (29,30,50,60,80,0);
Insert into Generalrouteprices values (30,60,100,130,160,0);
Insert into Generalrouteprices values (31,30,50,60,80,0);
Insert into Generalrouteprices values (32,30,50,60,80,0);
Insert into Generalrouteprices values (33,15,25,30,40,0);
Insert into Generalrouteprices values (34,30,50,60,80,0);
Insert into Generalrouteprices values (35,30,50,60,80,0);
Insert into Generalrouteprices values (36,30,50,60,80,0);
Insert into Generalrouteprices values (37,15,25,30,40,0);
Insert into Generalrouteprices values (38,15,25,30,40,0);
Insert into Generalrouteprices values (39,45,80,100,120,0);
Insert into Generalrouteprices values (40,45,80,100,120,0);
Insert into Generalrouteprices values (41,45,80,100,120,0);
Insert into Generalrouteprices values (42,30,50,60,80,0);
Insert into Generalrouteprices values (43,30,50,60,80,0);
Insert into Generalrouteprices values (44,15,25,30,40,0);
Insert into Generalrouteprices values (45,15,25,30,40,0);
Insert into Generalrouteprices values (46,30,50,60,80,0);
Insert into Generalrouteprices values (47,150,250,320,400,0);
Insert into Generalrouteprices values (48,30,50,60,80,0);

Insert into Generalseatavailability values (28,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (29,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (30,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (31,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (32,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (33,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (34,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (35,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (36,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (37,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (38,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (39,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (40,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (41,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (42,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (43,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (44,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (45,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (46,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (47,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (48,12603,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);

Insert into Tatkalrouteprices values (28,75,120,150,180,0);
Insert into Tatkalrouteprices values (29,45,75,90,110,0);
Insert into Tatkalrouteprices values (30,75,120,150,180,0);
Insert into Tatkalrouteprices values (31,45,75,90,110,0);
Insert into Tatkalrouteprices values (32,45,75,90,110,0);
Insert into Tatkalrouteprices values (33,25,55,60,80,0);
Insert into Tatkalrouteprices values (34,45,75,90,110,0);
Insert into Tatkalrouteprices values (35,45,75,90,110,0);
Insert into Tatkalrouteprices values (36,45,75,90,110,0);
Insert into Tatkalrouteprices values (37,25,55,60,80,0);
Insert into Tatkalrouteprices values (38,25,55,60,80,0);
Insert into Tatkalrouteprices values (39,75,100,130,160,0);
Insert into Tatkalrouteprices values (40,75,100,130,160,0);
Insert into Tatkalrouteprices values (41,75,100,130,160,0);
Insert into Tatkalrouteprices values (42,45,75,90,110,0);
Insert into Tatkalrouteprices values (43,45,75,90,110,0);
Insert into Tatkalrouteprices values (44,25,55,60,80,0);
Insert into Tatkalrouteprices values (45,25,55,60,80,0);
Insert into Tatkalrouteprices values (46,45,75,90,110,0);
Insert into Tatkalrouteprices values (47,200,300,350,450,0);
Insert into Tatkalrouteprices values (48,45,75,90,110,0);

Insert into Tatkalseatavailability values (28,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (29,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (30,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (31,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (32,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (33,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (34,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (35,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (36,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (37,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (38,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (39,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (40,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (41,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (42,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (43,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (44,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (45,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (46,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (47,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (48,12603,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);

Insert into Station values ("BZA","Vijayawada Junction"); 
Insert into Station values ("KMT","Khammam"); 
Insert into Station values ("DKJ","Dornakal Junction"); 
Insert into Station values ("MABD","Mahbubabad");
Insert into Station values ("WL","Warangal");
Insert into Station values ("KZJ","Kazipet Junction");   

Insert into Traindetails values (12759,"Charminar express","Express","MAS","18:10:00","HYB","08:00:00",16,1,1,1,1,1,1,1);

Insert into Route values (28,12759,"MAS","18:10:00",1,"SPE","19:19:00",1,1);
Insert into Route values (29,12759,"SPE","19:20:00",1,"NYP","19:44:00",1,2);
Insert into Route values (30,12759,"NYP","19:45:00",1,"GDR","20:40:00",1,3);
Insert into Route values (31,12759,"GDR","20:41:00",1,"NLR","21:10:00",1,4);
Insert into Route values (49,12759,"NLR","21:11:00",1,"KVZ","21:48:00",1,5);
Insert into Route values (50,12759,"KVZ","21:49:00",1,"OGL","22:42:00",1,6);
Insert into Route values (36,12759,"OGL","22:43:00",1,"CLX","23:18:00",1,7);
Insert into Route values (51,12759,"CLX","23:19:00",1,"TEL","00:14:00",2,8);
Insert into Route values (52,12759,"TEL","00:15:00",2,"BZA","01:10:00",2,9);
Insert into Route values (53,12759,"BZA","01:20:00",2,"KMT","02:28:00",2,10);
Insert into Route values (54,12759,"KMT","02:30:00",2,"DKJ","02:59:00",2,11);
Insert into Route values (55,12759,"DKJ","03:00:00",2,"MABD","03:19:00",2,12);
Insert into Route values (56,12759,"MABD","03:21:00",2,"WL","04:13:00",2,13);
Insert into Route values (57,12759,"WL","00:10:00",2,"KZJ","04:40:00",2,14);
Insert into Route values (58,12759,"KZJ","04:42:00",2,"SC","07:15:00",2,15);
Insert into Route values (48,12759,"SC","07:20:00",2,"HYB","08:00:00",2,16);

Insert into Generalrouteprices values (49,30,50,60,80,0);
Insert into Generalrouteprices values (50,60,100,120,160,0);
Insert into Generalrouteprices values (51,60,100,120,160,0);
Insert into Generalrouteprices values (52,60,100,120,160,0);
Insert into Generalrouteprices values (53,60,100,120,160,0);
Insert into Generalrouteprices values (54,30,50,60,80,0);
Insert into Generalrouteprices values (55,20,40,50,70,0);
Insert into Generalrouteprices values (56,60,100,120,160,0);
Insert into Generalrouteprices values (57,270,450,540,720,0);
Insert into Generalrouteprices values (58,150,250,300,400,0);

Insert into Generalseatavailability values (28,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (29,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (30,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (31,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (49,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (50,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (36,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (51,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (52,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (53,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (54,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (55,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (56,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (57,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (58,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (48,12759,"2026:10:24",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);

Insert into Tatkalrouteprices values (49,45,75,90,110,0);
Insert into Tatkalrouteprices values (50,80,120,160,200,0);
Insert into Tatkalrouteprices values (51,80,120,160,200,0);
Insert into Tatkalrouteprices values (52,80,120,160,200,0);
Insert into Tatkalrouteprices values (53,80,120,160,200,0);
Insert into Tatkalrouteprices values (54,45,75,90,110,0);
Insert into Tatkalrouteprices values (55,30,50,70,90,0);
Insert into Tatkalrouteprices values (56,80,120,160,200,0);
Insert into Tatkalrouteprices values (57,330,540,610,800,0);
Insert into Tatkalrouteprices values (58,200,300,350,450,0);

Insert into Tatkalseatavailability values (28,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (29,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (30,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (31,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (49,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (50,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (36,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (51,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (52,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (53,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (54,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (55,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (56,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (57,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (58,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);
Insert into Tatkalseatavailability values (48,12759,"2026:10:24",10,0,0,0,5,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0);

Insert into Generalseatavailability values (28,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (29,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (30,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (31,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (32,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (33,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (34,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (35,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (36,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (37,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (38,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (39,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (40,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (41,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (42,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (43,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (44,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (45,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (46,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (47,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);
Insert into Generalseatavailability values (48,12603,"2026:10:25",30,0,0,0,25,0,0,0,15,0,0,0,5,0,0,0,0,0,0,0);