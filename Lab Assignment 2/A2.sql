-- Below is the table creation part for the given schema
------------------------  TABLE CREATION PART --------------------------
CREATE TABLE households(
    household_id INTEGER PRIMARY KEY,
    addres TEXT,
    income DECIMAL(10,2)
);

CREATE TABLE   citizens (
    citizen_id INTEGER PRIMARY KEY,
    name TEXT,
    gender TEXT,
    dob DATE,
    household_id INTEGER REFERENCES households(household_id),
    educational_qualification TEXT 
);

CREATE TABLE land_records (
    land_id INTEGER PRIMARY KEY,
    citizen_id INTEGER REFERENCES citizens(citizen_id),
    area_acres  DECIMAL(10,2),
    crop_type TEXT
);

CREATE TABLE  panchayat_employees(
    employee_id INTEGER PRIMARY KEY,
    citizen_id  INTEGER REFERENCES citizens(citizen_id),
    role TEXT
);

CREATE TABLE  assets(
    asset_id    INTEGER PRIMARY KEY,
    type TEXT,
    location TEXT,
    installation_Date   DATE
);

CREATE TABLE welfare_schemes(
    scheme_id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT
);

CREATE TABLE scheme_enrollments(
    enrollment_id   INTEGER PRIMARY KEY,
    citizen_id      INTEGER REFERENCES citizens(citizen_id),
    scheme_id       INTEGER REFERENCES welfare_schemes(scheme_id),
    enrollment_Date DATE
);

CREATE TABLE vaccinations(
    vccination_id   INTEGER PRIMARY KEY,
    citizen_id      INTEGER REFERENCES citizens(citizen_id),
    vaccine_type    TEXT,
    date_administered   DATE
);

CREATE TABLE census_data(
    household_id INTEGER,
    citizen_id   INTEGER,
    event_type  TEXT,
    event_date  DATE,
    FOREIGN KEY (household_id) REFERENCES households(household_id),
    FOREIGN KEY (citizen_id) REFERENCES citizens(citizen_id)
);

----------------------  DATA INSERT PART -----------------------------
-- the below code for inserting part in the tables

-- Households
INSERT INTO households (household_id, addres, income) VALUES
(1, '123 Main Street, Phulera', 75000.00),
(2, '456 Rural Road, Phulera', 50000.00),
(3, '789 Village Lane, Phulera', 90000.00),
(4, '101 Green Fields, Phulera', 60000.00),
(5, '202 Farm House, Phulera', 45000.00);

-- Citizens
INSERT INTO citizens (citizen_id, name, gender, dob, household_id, educational_qualification) VALUES
(1, 'Ramesh Kumar', 'Male', '1990-05-15', 1, 'Graduate'),
(2, 'Priya Singh', 'Female', '2005-03-20', 2, '10th'),
(3, 'Amit Sharma', 'Male', '2002-11-10', 3, 'Secondary'),
(4, 'Sunita Devi', 'Female', '1985-07-25', 4, 'Illiterate'),
(5, 'Rahul Verma', 'Male', '2001-09-05', 5, '12th');

-- Land Records
INSERT INTO land_records (land_id, citizen_id, area_acres, crop_type) VALUES
(1, 1, 2.5, 'Rice'),
(2, 2, 0.5, 'Wheat'),
(3, 3, 1.2, 'Cotton'),
(4, 4, 3.0, 'Rice'),
(5, 5, 0.8, 'Wheat');

-- Panchayat Employees
INSERT INTO panchayat_employees (employee_id, citizen_id, role) VALUES
(1, 1, 'Pradhan'),
(2, 3, 'Secretary'),
(3, 5, 'Member');

-- Assets
INSERT INTO assets (asset_id, type, location, installation_date) VALUES
(1, 'Street Light', 'Phulera Main Road', '2024-01-15'),
(2, 'Water Pump', 'Village Center', '2023-11-20'),
(3, 'Street Light', 'Phulera Market', '2024-02-10'),
(4, 'Road', 'Village Entrance', '2023-12-05');

-- Welfare Schemes
INSERT INTO welfare_schemes (scheme_id, name, description) VALUES
(1, 'Rural Education Support', 'Scholarship for rural students'),
(2, 'Health Awareness', 'Free health check-ups and vaccines'),
(3, 'Agricultural Assistance', 'Support for small farmers');

-- Scheme Enrollments
INSERT INTO scheme_enrollments (enrollment_id, citizen_id, scheme_id, enrollment_date) VALUES
(1, 2, 1, '2024-01-10'),
(2, 3, 2, '2024-02-05'),
(3, 5, 3, '2024-03-15');

-- Vaccinations
INSERT INTO vaccinations (vccination_id, citizen_id, vaccine_type, date_administered) VALUES
(1, 2, 'Covid-19', '2024-01-20'),
(2, 5, 'Polio', '2024-02-15'),
(3, 1, 'Hepatitis', '2023-12-10');

-- Census Data
INSERT INTO census_data (household_id, citizen_id, event_type, event_date) VALUES
(1, 1, 'Birth', '2000-05-15'),
(2, 2, 'Birth', '2005-03-20'),
(3, 3, 'Birth', '2002-11-10'),
(4, 4, 'Death', '2020-07-25'),
(5, 5, 'Marriage', '2022-09-05');




-------------------- QUREIS FOR DATA RETRIVE -----------------------------
-- A. Show names of all citizens who hold more than 1 acre of land
SELECT c.name 
FROM citizens c
JOIN land_records lr ON c.citizen_id = lr.citizen_id
WHERE lr.area_acres > 1;

-- B. Show name of all girls who study in school with household income less than 1 Lakh per year
SELECT c.name 
FROM citizens c
JOIN households h ON c.household_id = h.household_id
WHERE c.gender = 'Female' AND c.educational_qualification = '10th' AND h.income < 100000;

-- C. How many acres of land cultivate rice
SELECT SUM(area_acres) AS total_rice_acres
FROM land_records
WHERE crop_type = 'Rice';

-- D. Number of citizens who are born after 1.1.2000 and have educational qualification of 10th class
SELECT COUNT(*) AS citizen_count
FROM citizens
WHERE dob > '2000-01-01' AND educational_qualification = '10th';

-- E. Name of all employees of panchayat who also hold more than 1 acre land
SELECT DISTINCT c.name 
FROM citizens c
JOIN panchayat_employees pe ON c.citizen_id = pe.citizen_id
JOIN land_records lr ON c.citizen_id = lr.citizen_id
WHERE lr.area_acres > 1;

-- F. Name of the household members of Panchayat Pradhan
SELECT c.name 
FROM citizens c
JOIN households h ON c.household_id = h.household_id
WHERE h.household_id = (
    SELECT household_id 
    FROM citizens 
    WHERE citizen_id = (
        SELECT citizen_id 
        FROM panchayat_employees 
        WHERE role = 'Pradhan'
    )
);

-- G. Total number of street light assets installed in Phulera in 2024
SELECT COUNT(*) AS street_light_count
FROM assets
WHERE type = 'Street Light' 
  AND location LIKE '%Phulera%' 
  AND installation_date BETWEEN '2024-01-01' AND '2024-12-31';

-- H. Number of vaccinations done in 2024 for children of citizens with 10th class education
SELECT COUNT(*) AS vaccination_count
FROM vaccinations v
JOIN citizens c ON v.citizen_id = c.citizen_id
WHERE v.date_administered BETWEEN '2024-01-01' AND '2024-12-31'
  AND c.educational_qualification = '10th';

-- I. Total number of births of boy child in the year 2024
SELECT COUNT(*) AS boy_births
FROM census_data cd
JOIN citizens c ON cd.citizen_id = c.citizen_id
WHERE cd.event_type = 'Birth' 
  AND c.gender = 'Male'
  AND cd.event_date BETWEEN '2024-01-01' AND '2024-12-31';

-- J. Number of citizens who belong to the household of at least one panchayat employee
SELECT COUNT(DISTINCT c.citizen_id) AS citizen_count
FROM citizens c
JOIN households h ON c.household_id = h.household_id
WHERE h.household_id IN (
    SELECT household_id 
    FROM citizens 
    WHERE citizen_id IN (
        SELECT citizen_id 
        FROM panchayat_employees
    )
);