-- ============================================================
--  RAILWAY MANAGEMENT SYSTEM - SEED DATA
--  Run this in MySQL after: USE Railway;
-- ============================================================

-- STATIONS
INSERT IGNORE INTO station VALUES
('CBE',  'Coimbatore Junction'),
('CBI',  'Coimbatore North'),
('PTJ',  'Podanur Junction'),
('TUP',  'Tiruppur'),
('ED',   'Erode Junction'),
('SA',   'Salem Junction'),
('PGT',  'Palakkad Junction'),
('PCH',  'Pollachi Junction'),
('DG',   'Dindigul Junction'),
('MDU',  'Madurai Junction'),
('MAS',  'Chennai Central'),
('SBC',  'Bangalore City'),
('MYS',  'Mysuru Junction'),
('UAM',  'Ooty'),
('MTP',  'Mettupalayam');

-- TRAIN DETAILS
INSERT IGNORE INTO Traindetails (Trainno, Trainname, Startstation, Endstation, Starttime, Endtime, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday) VALUES
('12671', 'Nilgiris Express',   'MAS', 'MTP', '21:15:00', '07:10:00', 1,1,1,1,1,1,1),
('11013', 'Coimbatore Express', 'CBE', 'MAS', '22:00:00', '08:00:00', 1,0,1,0,1,0,1),
('16526', 'Island Express',     'SBC', 'CBE', '08:45:00', '16:30:00', 1,1,1,1,1,1,1),
('12673', 'Cheran Express',     'CBE', 'MAS', '06:05:00', '12:55:00', 1,1,1,1,1,1,1),
('12661', 'Pothigai Express',   'MAS', 'MDU', '19:20:00', '05:15:00', 1,0,1,0,1,0,0);

-- ROUTES
-- Train 12671: Nilgiris Express (MAS → SA → ED → CBE → MTP)
INSERT IGNORE INTO route (Trainno, Stopnumber, Deptstation, Depttime, Deptday, Arrivalstation, Arrivaltime, Arrivalday) VALUES
('12671', 1, 'MAS', '21:15:00', 1, 'SA',  '02:30:00', 2),
('12671', 2, 'SA',  '02:35:00', 2, 'ED',  '04:00:00', 2),
('12671', 3, 'ED',  '04:05:00', 2, 'CBE', '05:30:00', 2),
('12671', 4, 'CBE', '05:35:00', 2, 'MTP', '07:10:00', 2);

-- Train 11013: Coimbatore Express (CBE → TUP → ED → SA → MAS)
INSERT IGNORE INTO route (Trainno, Stopnumber, Deptstation, Depttime, Deptday, Arrivalstation, Arrivaltime, Arrivalday) VALUES
('11013', 1, 'CBE', '22:00:00', 1, 'TUP', '22:45:00', 1),
('11013', 2, 'TUP', '22:50:00', 1, 'ED',  '00:10:00', 2),
('11013', 3, 'ED',  '00:15:00', 2, 'SA',  '01:45:00', 2),
('11013', 4, 'SA',  '01:50:00', 2, 'MAS', '08:00:00', 2);

-- Train 16526: Island Express (SBC → MYS → PGT → CBE)
INSERT IGNORE INTO route (Trainno, Stopnumber, Deptstation, Depttime, Deptday, Arrivalstation, Arrivaltime, Arrivalday) VALUES
('16526', 1, 'SBC', '08:45:00', 1, 'MYS', '10:30:00', 1),
('16526', 2, 'MYS', '10:35:00', 1, 'PGT', '13:00:00', 1),
('16526', 3, 'PGT', '13:05:00', 1, 'CBE', '16:30:00', 1);

-- Train 12673: Cheran Express (CBE → ED → SA → MAS)
INSERT IGNORE INTO route (Trainno, Stopnumber, Deptstation, Depttime, Deptday, Arrivalstation, Arrivaltime, Arrivalday) VALUES
('12673', 1, 'CBE', '06:05:00', 1, 'ED',  '07:30:00', 1),
('12673', 2, 'ED',  '07:35:00', 1, 'SA',  '09:00:00', 1),
('12673', 3, 'SA',  '09:05:00', 1, 'MAS', '12:55:00', 1);

-- Train 12661: Pothigai Express (MAS → DG → MDU)
INSERT IGNORE INTO route (Trainno, Stopnumber, Deptstation, Depttime, Deptday, Arrivalstation, Arrivaltime, Arrivalday) VALUES
('12661', 1, 'MAS', '19:20:00', 1, 'DG',  '02:00:00', 2),
('12661', 2, 'DG',  '02:05:00', 2, 'MDU', '05:15:00', 2);

-- ADMIN USER (username: admin, password: admin123)
INSERT IGNORE INTO Admin (UserID, Password) VALUES ('admin', 'admin123');

