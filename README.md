# Airport Management Database System

## Overview
This project is a relational database for an Airport Management System. It was designed and implemented to manage important airport operations such as airlines, airports, gates, aircraft, flights, passengers, bookings, tickets, payments, baggage, boarding passes, and employee flight assignments.

The database was implemented in **MySQL** using **phpMyAdmin** and built from an ERD and physical data model prepared for coursework.

## Features
- Management of airline and aircraft records
- Management of airports and airport gates
- Storage of scheduled flight information
- Passenger booking and ticket management
- Payment tracking
- Baggage tracking
- Boarding pass generation
- Employee assignment to flights
- Supporting SQL views for simplified data access

## Database Name
`airport_management_database_system`

## Core Tables
The system contains 14 core tables:

1. `airlines`
2. `airports`
3. `airport_gates`
4. `aircraft`
5. `flights`
6. `passengers`
7. `bookings`
8. `tickets`
9. `payments`
10. `baggage`
11. `boardingpasses`
12. `employees`
13. `flight_staff_assignment`
14. `booking_passengers`

## Supporting Views
The system also includes 3 supporting views:

- `vw_passenger_basic`
- `vw_flight_ticket_summary`
- `vw_booking_payment_summary`

## Technologies Used
- MySQL
- phpMyAdmin
- SQL

## Main Relationships
- One airline can operate many aircraft
- One airline can operate many flights
- One airport can contain many gates
- One flight can have many tickets
- One booking can have many tickets
- One booking can involve many passengers through `booking_passengers`
- One ticket can have one boarding pass
- One ticket can have many baggage records
- One flight can have many employee assignments through `flight_staff_assignment`

## Example Business Queries
The database was tested using queries such as:

- Show flights operated by a specific airline
- Show passengers booked on a specific flight
- List tickets associated with a booking
- Show baggage linked to a ticket
- Show payment information for a booking
- Show employees assigned to a flight

## Sample Query
```sql
SELECT Passengers.First_Name, Passengers.Last_Name
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger_ID
WHERE Tickets.Flight_ID = 'BA117';
