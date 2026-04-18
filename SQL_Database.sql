--  Database tables creation
CREATE DATABASE airport_management_database_system;
USE airport_management_database_system;

CREATE TABLE airlines (
    Airline_ID INT PRIMARY KEY,
    Airline_Name VARCHAR(100) NOT NULL,
    IATA_Code CHAR(2) NOT NULL,
    ICAO_Code CHAR(3) NOT NULL,
    Country_Code CHAR(2) NOT NULL,
    Callsign VARCHAR(20),
    Active BOOLEAN NOT NULL
);

CREATE TABLE airports (
    Airport_ID INT PRIMARY KEY,
    Airport_Name VARCHAR(100) NOT NULL,
    IATA_Code CHAR(3) NOT NULL,
    ICAO_Code CHAR(4) NOT NULL,
    City VARCHAR(80) NOT NULL,
    Country_Code CHAR(2) NOT NULL
);

CREATE TABLE airport_gates (
    Gate_ID INT PRIMARY KEY,
    Airport_ID INT NOT NULL,
    Gate_Number VARCHAR(10) NOT NULL,
    Terminal VARCHAR(20),
    Concourse CHAR(2),
    Gate_Type VARCHAR(30),
    Active BOOLEAN NOT NULL,
    CONSTRAINT fk_airport_gates_airport
        FOREIGN KEY (Airport_ID) REFERENCES airports(Airport_ID)
);

CREATE TABLE aircraft (
    Aircraft_ID VARCHAR(20) PRIMARY KEY,
    Airline_ID INT NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    Build_Year INT,
    Status VARCHAR(30),
    CONSTRAINT fk_aircraft_airline
        FOREIGN KEY (Airline_ID) REFERENCES airlines(Airline_ID)
);

CREATE TABLE flights (
    Flight_ID VARCHAR(20) PRIMARY KEY,
    Airline_ID INT NOT NULL,
    Aircraft_ID VARCHAR(20) NOT NULL,
    DepartureAirport_ID INT NOT NULL,
    ArrivalAirport_ID INT NOT NULL,
    Gate_ID INT,
    Departure_Time DATETIME NOT NULL,
    Arrival_Time DATETIME NOT NULL,
    Status VARCHAR(30),
    CONSTRAINT fk_flights_airline
        FOREIGN KEY (Airline_ID) REFERENCES airlines(Airline_ID),
    CONSTRAINT fk_flights_aircraft
        FOREIGN KEY (Aircraft_ID) REFERENCES aircraft(Aircraft_ID),
    CONSTRAINT fk_flights_departure_airport
        FOREIGN KEY (DepartureAirport_ID) REFERENCES airports(Airport_ID),
    CONSTRAINT fk_flights_arrival_airport
        FOREIGN KEY (ArrivalAirport_ID) REFERENCES airports(Airport_ID),
    CONSTRAINT fk_flights_gate
        FOREIGN KEY (Gate_ID) REFERENCES airport_gates(Gate_ID)
);

CREATE TABLE passengers (
    Passenger_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(60) NOT NULL,
    Passport_Number VARCHAR(20) NOT NULL,
    Nationality CHAR(2),
    DOB DATE,
    Gender VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE bookings (
    Booking_ID VARCHAR(10) PRIMARY KEY,
    Booking_Date DATETIME NOT NULL,
    Booking_Status VARCHAR(30) NOT NULL
);

CREATE TABLE tickets (
    Ticket_ID VARCHAR(14) PRIMARY KEY,
    Booking_ID VARCHAR(10) NOT NULL,
    Passenger_ID INT NOT NULL,
    Flight_ID VARCHAR(20) NOT NULL,
    Seat_Number VARCHAR(8),
    Class VARCHAR(20),
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_tickets_booking
        FOREIGN KEY (Booking_ID) REFERENCES bookings(Booking_ID),
    CONSTRAINT fk_tickets_passenger
        FOREIGN KEY (Passenger_ID) REFERENCES passengers(Passenger_ID),
    CONSTRAINT fk_tickets_flight
        FOREIGN KEY (Flight_ID) REFERENCES flights(Flight_ID)
);

CREATE TABLE payments (
    Payment_ID BIGINT PRIMARY KEY,
    Booking_ID VARCHAR(10) NOT NULL,
    Payment_Date DATETIME NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Method VARCHAR(30),
    Payment_Status VARCHAR(30),
    CONSTRAINT fk_payments_booking
        FOREIGN KEY (Booking_ID) REFERENCES bookings(Booking_ID)
);

CREATE TABLE baggage (
    Baggage_ID BIGINT PRIMARY KEY,
    Ticket_ID VARCHAR(14) NOT NULL,
    Weight DECIMAL(6,2),
    TagNumber VARCHAR(12) NOT NULL,
    Status VARCHAR(30),
    CONSTRAINT fk_baggage_ticket
        FOREIGN KEY (Ticket_ID) REFERENCES tickets(Ticket_ID)
);

CREATE TABLE boardingpasses (
    BoardingPass_ID BIGINT PRIMARY KEY,
    Ticket_ID VARCHAR(14) NOT NULL UNIQUE,
    Boarding_Time DATETIME NOT NULL,
    Boarding_Group INT,
    Zone INT,
    Sequence_Number INT,
    Status VARCHAR(30),
    CONSTRAINT fk_boardingpasses_ticket
        FOREIGN KEY (Ticket_ID) REFERENCES tickets(Ticket_ID)
);
 
CREATE TABLE employees (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(60) NOT NULL,
    HireDate DATE,
    Employee_Code VARCHAR(20) NOT NULL,
    Status VARCHAR(30),
    Email VARCHAR(100)
);

CREATE TABLE flight_staff_assignment (
    Flight_ID VARCHAR(20) NOT NULL,
    Employee_ID INT NOT NULL,
    Role_ID INT NOT NULL,
    PRIMARY KEY (Flight_ID, Employee_ID, Role_ID),
    CONSTRAINT fk_fsa_flight
        FOREIGN KEY (Flight_ID) REFERENCES flights(Flight_ID),
    CONSTRAINT fk_fsa_employee
        FOREIGN KEY (Employee_ID) REFERENCES employees(Employee_ID)
);

CREATE TABLE booking_passengers (
    Booking_ID VARCHAR(10) NOT NULL,
    Passenger_ID INT NOT NULL,
    PRIMARY KEY (Booking_ID, Passenger_ID),
    CONSTRAINT fk_booking_passengers_booking
        FOREIGN KEY (Booking_ID) REFERENCES bookings(Booking_ID),
    CONSTRAINT fk_booking_passengers_passenger
        FOREIGN KEY (Passenger_ID) REFERENCES passengers(Passenger_ID)
);
 


--  Views

CREATE VIEW vw_passenger_basic AS
SELECT 
    Passenger_ID,
    First_Name,
    Last_Name,
    Nationality,
    DOB,
    Gender
FROM passengers;

CREATE VIEW vw_flight_ticket_summary AS
SELECT
    t.Ticket_ID,
    t.Flight_ID,
    p.First_Name,
    p.Last_Name,
    t.Seat_Number,
    t.Class,
    t.Price
FROM tickets t
JOIN passengers p ON t.Passenger_ID = p.Passenger_ID;

CREATE VIEW vw_booking_payment_summary AS
SELECT
    b.Booking_ID,
    b.Booking_Date,
    b.Booking_Status,
    p.Payment_ID,
    p.Amount,
    p.Payment_Method,
    p.Payment_Status
FROM bookings b
JOIN payments p ON b.Booking_ID = p.Booking_ID;
 
--  Data implementation

INSERT INTO airlines (Airline_ID, Airline_Name, IATA_Code, ICAO_Code, Country_Code, Callsign, Active)
VALUES
(1, 'British Airways', 'BA', 'BAW', 'GB', 'SPEEDBIRD', 1),
(2, 'Lufthansa', 'LH', 'DLH', 'DE', 'LUFTHANSA', 1),
(3, 'Emirates', 'EK', 'UAE', 'AE', 'EMIRATES', 1);

INSERT INTO airports (Airport_ID, Airport_Name, IATA_Code, ICAO_Code, City, Country_Code)
VALUES
(1, 'Heathrow Airport', 'LHR', 'EGLL', 'London', 'GB'),
(2, 'Manchester Airport', 'MAN', 'EGCC', 'Manchester', 'GB'),
(3, 'Dubai International Airport', 'DXB', 'OMDB', 'Dubai', 'AE'),
(4, 'Frankfurt Airport', 'FRA', 'EDDF', 'Frankfurt', 'DE');

INSERT INTO airport_gates (Gate_ID, Airport_ID, Gate_Number, Terminal, Concourse, Gate_Type, Active)
VALUES
(1, 1, 'A12', 'T5', 'A', 'International', 1),
(2, 1, 'B07', 'T5', 'B', 'International', 1),
(3, 2, 'C03', 'T1', 'C', 'Domestic', 1),
(4, 3, 'D21', 'T3', 'D', 'International', 1),
(5, 4, 'E10', 'T2', 'E', 'International', 1);

INSERT INTO aircraft (Aircraft_ID, Airline_ID, Model, Capacity, Build_Year, Status)
VALUES
('A320-BA-001', 1, 'Airbus A320', 180, 2018, 'Active'),
('B789-BA-002', 1, 'Boeing 787-9', 296, 2020, 'Active'),
('A359-LH-001', 2, 'Airbus A350-900', 315, 2021, 'Active'),
('B777-EK-001', 3, 'Boeing 777-300ER', 354, 2019, 'Active');

INSERT INTO flights (Flight_ID, Airline_ID, Aircraft_ID, DepartureAirport_ID, ArrivalAirport_ID, Gate_ID, Departure_Time, Arrival_Time, Status)
VALUES
('BA117', 1, 'B789-BA-002', 1, 3, 1, '2026-04-20 09:30:00', '2026-04-20 19:45:00', 'Scheduled'),
('BA220', 1, 'A320-BA-001', 2, 1, 3, '2026-04-20 14:00:00', '2026-04-20 15:05:00', 'Scheduled'),
('LH901', 2, 'A359-LH-001', 4, 1, 5, '2026-04-21 08:15:00', '2026-04-21 09:30:00', 'Scheduled'),
('EK029', 3, 'B777-EK-001', 3, 1, 4, '2026-04-21 13:20:00', '2026-04-21 18:10:00', 'Scheduled');

INSERT INTO passengers (Passenger_ID, First_Name, Last_Name, Passport_Number, Nationality, DOB, Gender, Email)
VALUES
(1, 'Tadeusz', 'Gadkowski', 'P1234567', 'PL', '2000-06-15', 'Male', 'tadeusz@example.com'),
(2, 'Mykyta', 'Chulaiev', 'P7654321', 'UA', '2001-03-22', 'Male', 'mykyta@example.com'),
(3, 'Sarah', 'Ahmed', 'A4567890', 'GB', '1998-11-02', 'Female', 'sarah.ahmed@example.com'),
(4, 'Daniel', 'Smith', 'B9988776', 'GB', '1995-01-30', 'Male', 'daniel.smith@example.com'),
(5, 'Fatima', 'Khan', 'C1122334', 'AE', '1999-08-10', 'Female', 'fatima.khan@example.com');

INSERT INTO bookings (Booking_ID, Booking_Date, Booking_Status)
VALUES
('B001', '2026-04-10 10:20:00', 'Confirmed'),
('B002', '2026-04-11 16:00:00', 'Confirmed'),
('B003', '2026-04-12 12:40:00', 'Pending');

INSERT INTO booking_passengers (Booking_ID, Passenger_ID)
VALUES
('B001', 1),
('B001', 2),
('B002', 3),
('B003', 4),
('B003', 5);

INSERT INTO tickets (Ticket_ID, Booking_ID, Passenger_ID, Flight_ID, Seat_Number, Class, Price)
VALUES
('T000000000001', 'B001', 1, 'BA117', '14A', 'Economy', 420.00),
('T000000000002', 'B001', 2, 'BA117', '14B', 'Economy', 420.00),
('T000000000003', 'B002', 3, 'LH901', '03C', 'Business', 780.00),
('T000000000004', 'B003', 4, 'EK029', '22D', 'Economy', 510.00),
('T000000000005', 'B003', 5, 'EK029', '22E', 'Economy', 510.00);

INSERT INTO payments (Payment_ID, Booking_ID, Payment_Date, Amount, Payment_Method, Payment_Status)
VALUES
(1001, 'B001', '2026-04-10 10:30:00', 840.00, 'Card', 'Paid'),
(1002, 'B002', '2026-04-11 16:10:00', 780.00, 'PayPal', 'Paid'),
(1003, 'B003', '2026-04-12 12:50:00', 1020.00, 'Card', 'Pending');

INSERT INTO baggage (Baggage_ID, Ticket_ID, Weight, TagNumber, Status)
VALUES
(2001, 'T000000000001', 18.50, 'BG100001', 'Checked-In'),
(2002, 'T000000000002', 20.00, 'BG100002', 'Checked-In'),
(2003, 'T000000000003', 15.00, 'BG100003', 'Loaded'),
(2004, 'T000000000004', 23.40, 'BG100004', 'Checked-In');

INSERT INTO boardingpasses (BoardingPass_ID, Ticket_ID, Boarding_Time, Boarding_Group, Zone, Sequence_Number, Status)
VALUES
(3001, 'T000000000001', '2026-04-20 08:50:00', 2, 1, 45, 'Issued'),
(3002, 'T000000000002', '2026-04-20 08:50:00', 2, 1, 46, 'Issued'),
(3003, 'T000000000003', '2026-04-21 07:35:00', 1, 1, 10, 'Issued');

INSERT INTO employees (Employee_ID, First_Name, Last_Name, HireDate, Employee_Code, Status, Email)
VALUES
(1, 'James', 'Walker', '2022-05-10', 'EMP001', 'Active', 'j.walker@airport.com'),
(2, 'Emily', 'Brown', '2021-09-17', 'EMP002', 'Active', 'e.brown@airport.com'),
(3, 'Noah', 'Taylor', '2020-01-25', 'EMP003', 'Active', 'n.taylor@airport.com');

INSERT INTO flight_staff_assignment (Flight_ID, Employee_ID, Role_ID)
VALUES
('BA117', 1, 1),
('BA117', 2, 2),
('LH901', 3, 1),
('EK029', 1, 3);
 


--  Test queries

SELECT Flight_ID, Departure_Time, Arrival_Time
FROM flights
WHERE Airline_ID = 1;


SELECT Passengers.First_Name, Passengers.Last_Name
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger_ID
WHERE Tickets.Flight_ID = 'BA117';



SELECT Ticket_ID, Seat_Number, Class
FROM Tickets
WHERE Booking_ID = 'B001';


SELECT TagNumber, Weight
FROM Baggage
WHERE Ticket_ID = 'T000000000001';


SELECT Payment_Date, Amount, Payment_Method
FROM Payments
WHERE Booking_ID = 'B001';


SELECT Employees.First_Name, Employees.Last_Name
FROM Employees
JOIN flight_staff_assignment
ON Employees.Employee_ID = flight_staff_assignment.Employee_ID
WHERE flight_staff_assignment.Flight_ID = 'BA117';

--  Testing

DROP TABLE IF EXISTS boardingpasses;

CREATE TABLE boardingpasses (
    BoardingPass_ID BIGINT PRIMARY KEY,
    Ticket_ID VARCHAR(14) NOT NULL UNIQUE,
    Boarding_Time DATETIME NOT NULL,
    Boarding_Group INT,
    Zone INT,
    Sequence_Number INT,
    Status VARCHAR(30),
    CONSTRAINT fk_boardingpasses_ticket
        FOREIGN KEY (Ticket_ID) REFERENCES tickets(Ticket_ID)
);

