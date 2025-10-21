
CREATE SCHEMA IF NOT EXISTS project_employee;
SET search_path TO project_employee;

-- Create table Address_Type
CREATE TABLE IF NOT EXISTS Address_Type (
    address_id SERIAL PRIMARY KEY,
    address_type VARCHAR(20) NOT NULL,
    c TEXT
);

-- create table Employee_Type
CREATE TABLE IF NOT EXISTS Employee_Type (
    employee_type_id SERIAL PRIMARY KEY,
    employee_type VARCHAR(50),
    employee_type_desc TEXT,
    pay_type VARCHAR(10),
    compensation_package NUMERIC(12,2)
);

-- create table Employee_Role
CREATE TABLE IF NOT EXISTS Employee_Role (
    employee_role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(30) NOT NULL,
    role_desc TEXT
);

-- Create table Organization
CREATE TABLE IF NOT EXISTS Organization (
    organization_id SERIAL PRIMARY KEY,
    client_org_name VARCHAR(20) NOT NULL,
    client_org_code INTEGER NOT NULL,
    superior_org_name VARCHAR(20),
    availability_date DATE,
    top_level_name VARCHAR(20),
    ISO_country_code VARCHAR(20)
);

-- create table Person
CREATE TABLE IF NOT EXISTS Person (
    person_id SERIAL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT NOT NULL,
    phone_number VARCHAR(15),
    email_id VARCHAR(100) NOT NULL,
    address_id INT REFERENCES Address_Type(address_id),
    insurance_id VARCHAR(20),
    device_type VARCHAR(20)
);

-- Create table Employee
CREATE TABLE IF NOT EXISTS Employee (
    employee_id SERIAL PRIMARY KEY,
    employee_role_id INT REFERENCES Employee_Role(employee_role_id),
    employee_type_id INT REFERENCES Employee_Type(employee_type_id),
    organization_id INT REFERENCES Organization(organization_id),
    person_id INT NOT NULL REFERENCES Person(person_id),
    home_country VARCHAR(50),
    work_country VARCHAR(50),
    gender CHAR(1),
    DOB DATE,
    martial_status VARCHAR(20),
    ethnicity VARCHAR(20)
);

-- Sample 
INSERT INTO Employee_Role (employee_role_id, role_name, role_desc)
VALUES (1, 'r1', 'rd1');

INSERT INTO Address_Type (address_id, address_type, c)
VALUES (1, 'a1', 'a1');

INSERT INTO Person (person_id, first_name, middle_name, last_name, age, phone_number, email_id, address_id, insurance_id, device_type)
VALUES (1, 'a', 'a', 'a', 10, '1234567891', 'e1', 1, '1', 'd1');

INSERT INTO Employee_Type (employee_type_id, employee_type, employee_type_desc, pay_type, compensation_package)
VALUES (1, 'e1', 'ed1', 'p1', 1.1);

INSERT INTO Organization (organization_id, client_org_name, client_org_code, superior_org_name, availability_date, top_level_name, ISO_country_code)
VALUES (1, 'r1', 1001, 's1', '2012-01-01', 't1', 'iso1');

INSERT INTO Employee (employee_role_id, employee_type_id, organization_id, person_id, home_country, work_country, gender, DOB, martial_status, ethnicity)
VALUES (1, 1, 1, 1, 'h1', 'w1', 'm', '1997-01-01', 's', 'I');

-- View employee  View
CREATE OR REPLACE VIEW employeeView AS
SELECT 
    a.c AS address_type_description,
    a.address_type,
    et.employee_type,
    et.compensation_package,
    er.role_name,
    er.role_desc,
    o.client_org_name,
    o.top_level_name,
    p.first_name,
    p.middle_name,
    p.age,
    e.home_country,
    e.DOB,
    e.employee_role_id
FROM Address_Type a
JOIN Person p ON a.address_id = p.address_id
JOIN Employee e ON p.person_id = e.person_id
JOIN Employee_Type et ON e.employee_type_id = et.employee_type_id
JOIN Employee_Role er ON e.employee_role_id = er.employee_role_id
JOIN Organization o ON e.organization_id = o.organization_id;

SELECT * FROM employeeView;

-- View employeeView_alternate
CREATE OR REPLACE VIEW employeeView_alternate AS
SELECT 
    et.employee_type,
    et.compensation_package,
    er.role_name,
    er.role_desc,
    o.client_org_name,
    o.top_level_name,
    p.first_name,
    p.middle_name,
    p.age,
    e.home_country,
    e.DOB,
    e.employee_role_id
FROM Employee e
JOIN Employee_Type et ON e.employee_type_id = et.employee_type_id
JOIN Employee_Role er ON e.employee_role_id = er.employee_role_id
JOIN Organization o ON e.organization_id = o.organization_id
JOIN Person p ON p.person_id = e.person_id
JOIN Address_Type a ON a.address_id = p.address_id;

SELECT * FROM employeeView_alternate;

-- Stored Procedures 
CREATE OR REPLACE PROCEDURE insert_address_type(
    address_type_val VARCHAR(20),
    address_type_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Address_Type(address_type, c)
    VALUES (address_type_val, address_type_description);
END;
$$;

-- Procedure: insert_employee
CREATE OR REPLACE PROCEDURE insert_employee(
    employee_role_id INT,
    employee_type_id INT,
    organization_id INT,
    person_id INT,
    home_country VARCHAR(50),
    work_country VARCHAR(50),
    gender CHAR(1),
    DOB DATE,
    martial_status VARCHAR(20),
    ethnicity VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Employee(employee_role_id, employee_type_id, organization_id, person_id,
                         home_country, work_country, gender, DOB, martial_status, ethnicity)
    VALUES (employee_role_id, employee_type_id, organization_id, person_id,
            home_country, work_country, gender, DOB, martial_status, ethnicity);
END;
$$;

-- Procedure- insert_employee_role
CREATE OR REPLACE PROCEDURE insert_employee_role(
    role_name VARCHAR(30),
    role_desc TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Employee_Role(role_name, role_desc)
    VALUES (role_name, role_desc);
END;
$$;

-- Procedure- insert_employee_type
CREATE OR REPLACE PROCEDURE insert_employee_type(
    employee_type VARCHAR(50),
    employee_type_desc TEXT,
    pay_type VARCHAR(10),
    compensation_package NUMERIC(12,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Employee_Type(employee_type, employee_type_desc, pay_type, compensation_package)
    VALUES (employee_type, employee_type_desc, pay_type, compensation_package);
END;
$$;

-- Procedure - insert_organization
CREATE OR REPLACE PROCEDURE insert_organization(
    client_org_name VARCHAR(20),
    client_org_code INT,
    superior_org_name VARCHAR(20),
    availability_date DATE,
    top_level_name VARCHAR(20),
    ISO_country_code VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Organization(client_org_name, client_org_code, superior_org_name, availability_date, top_level_name, ISO_country_code)
    VALUES (client_org_name, client_org_code, superior_org_name, availability_date, top_level_name, ISO_country_code);
END;
$$;

-- Procedure - insert_person
CREATE OR REPLACE PROCEDURE insert_person(
    first_name VARCHAR(20),
    middle_name VARCHAR(20),
    last_name VARCHAR(20),
    age INT,
    phone_number VARCHAR(15),
    email_id VARCHAR(100),
    address_id INT,
    insurance_id VARCHAR(20),
    device_type VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Person(first_name, middle_name, last_name, age, phone_number, email_id, address_id, insurance_id, device_type)
    VALUES (first_name, middle_name, last_name, age, phone_number, email_id, address_id, insurance_id, device_type);
END;
$$;

-- Example Calls
CALL insert_employee_role('r2', 'rd2');
CALL insert_address_type('a2', 'a2');
CALL insert_person('b', 'b', 'b', 20, '9876543210', 'e2', 2, '2', 'd2');
CALL insert_employee_type('e2', 'ed2', 'p2', 2.2);
CALL insert_organization('r2', 2002, 's2', '2013-01-01', 't2', 'iso2');
CALL insert_employee(2, 2, 2, 2, 'h2', 'w2', 'm', '1998-01-01', 's', 'I');


SELECT * FROM Address_Type;
SELECT * FROM Employee;
SELECT * FROM Employee_Role;
SELECT * FROM Employee_Type;
SELECT * FROM Organization;
SELECT * FROM Person;


SELECT organization_id FROM Organization WHERE organization_id IS NULL;

DELETE FROM Organization WHERE organization_id IS NULL;
