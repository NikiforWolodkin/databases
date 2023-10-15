CREATE DATABASE outsourcedb;

USE outsourcedb;

CREATE LOGIN outsource_login WITH PASSWORD = 'Password_01';

CREATE USER outsource_admin FOR LOGIN outsource_login;

EXEC sp_addrolemember 'db_owner', 'outsource_admin';



CREATE TABLE contact_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    contact_type VARCHAR(50) NOT NULL
);

CREATE TABLE roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    role VARCHAR(50) NOT NULL
);


CREATE TABLE staff (
    id INT IDENTITY(1,1) PRIMARY KEY,
    salary DECIMAL(10, 2) NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE staff_contacts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    contact VARCHAR(200) NOT NULL,
    contact_type INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (contact_type) REFERENCES contact_types(id)
);

CREATE TABLE staff_roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    role int NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (role) REFERENCES roles(id)
);



CREATE TABLE project_event_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL
);

CREATE TABLE project_resource_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    resource_type VARCHAR(50) NOT NULL
);


CREATE TABLE projects (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status VARCHAR(200) NOT NULL --denormalized from events
);

CREATE TABLE project_stages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    project_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    event_type INT NOT NULL,
    previous_stage INT NULL,
    description VARCHAR(200) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (event_type) REFERENCES project_event_types(id),
    FOREIGN KEY (previous_stage) REFERENCES project_stages(id)
);

CREATE TABLE project_resources (
    id INT IDENTITY(1,1) PRIMARY KEY,
    project_id INT NOT NULL,
    resource_type INT NOT NULL,
    description VARCHAR(200) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (resource_type) REFERENCES project_resource_types(id)
);



CREATE TABLE clients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE client_contacts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    contact VARCHAR(200) NOT NULL,
    contact_type INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (contact_type) REFERENCES contact_types(id)
);

CREATE TABLE project_clients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    project_id INT NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE project_employees (
    id INT IDENTITY(1,1) PRIMARY KEY,
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (employee_id) REFERENCES staff(id)
);

CREATE TABLE project_roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    project_employee_id INT NOT NULL,
    staff_role_id INT NOT NULL,
    FOREIGN KEY (project_employee_id) REFERENCES project_employees(id),
    FOREIGN KEY (staff_role_id) REFERENCES staff_roles(id)
);

CREATE TABLE project_stage_employees (
    id INT IDENTITY(1,1) PRIMARY KEY,
    project_role_id INT NOT NULL,
    stage_id INT NOT NULL,
    rate DECIMAL(3, 2) NOT NULL,
    FOREIGN KEY (project_role_id) REFERENCES project_roles(id),
    FOREIGN KEY (stage_id) REFERENCES project_stages(id)
);



CREATE TABLE project_payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    project_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10, 2) NOT NULL,
    associated_stage INT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (associated_stage) REFERENCES project_stages(id)
);

CREATE TABLE staff_payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    payment_date DATE NOT NULL,
    hours_tracked INT NOT NULL,
    payment_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id)
);



CREATE TABLE hardware_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    hardware_type VARCHAR(50) NOT NULL
);


CREATE TABLE hardware (
    id INT IDENTITY(1,1) PRIMARY KEY,
    hardware_type INT NOT NULL,
    status VARCHAR(200) NULL, --denormalized from hardware usage
    is_used BIT NULL, --denormalized from hardware usage
    FOREIGN KEY (hardware_type) REFERENCES hardware_types(id)
);



CREATE TABLE hardware_usage (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    hardware_id INT NOT NULL,
    usage_start_date DATE NOT NULL,
    usage_end_date DATE NULL,
    status_after_usage VARCHAR(200) NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (hardware_id) REFERENCES hardware(id)
);



CREATE TABLE developer_access_to_resources_and_credentials (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    resource_id INT NOT NULL,
    access_start_date DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (resource_id) REFERENCES project_resources(id)
);



-- contact_types
INSERT INTO contact_types (contact_type) VALUES ('Email');
INSERT INTO contact_types (contact_type) VALUES ('Phone');

-- roles
INSERT INTO roles (role) VALUES ('Software Engineer');
INSERT INTO roles (role) VALUES ('Project Manager');

-- staff
INSERT INTO staff (salary, name) VALUES (5000.00, 'John Doe');
INSERT INTO staff (salary, name) VALUES (7000.00, 'Jane Smith');

-- staff_contacts
INSERT INTO staff_contacts (employee_id, contact, contact_type) VALUES 
(1, 'john.doe@example.com', 1);
INSERT INTO staff_contacts (employee_id, contact, contact_type) VALUES 
(2, 'jane.smith@example.com', 1);

-- staff_roles
INSERT INTO staff_roles (employee_id, role) VALUES 
(1, 1);
INSERT INTO staff_roles (employee_id, role) VALUES 
(2, 2);

-- project_event_types
INSERT INTO project_event_types (event_type) VALUES 
('Start');
INSERT INTO project_event_types (event_type) VALUES 
('End');

-- project_resource_types
INSERT INTO project_resource_types(resource_type )VALUES 
('Database connection string');
INSERT INTO project_resource_types(resource_type )VALUES 
('Cloud credentials');

-- projects
INSERT INTO projects(name ,status )VALUES 
('Project Alpha' ,'In Progress');
INSERT INTO projects(name ,status )VALUES 
('Project Beta' ,'Completed');

-- project_stages
INSERT INTO project_stages(project_id ,event_type ,previous_stage ,description, start_date, end_date )VALUES 
(1 ,1 ,NULL ,'Project Alpha started', '2023-09-15', NULL);
INSERT INTO project_stages(project_id ,event_type ,previous_stage ,description, start_date, end_date )VALUES 
(2 ,1 ,NULL ,'Project Beta started', '2023-09-15', '2023-11-15');

-- project_resources
INSERT INTO project_resources(project_id ,resource_type ,description )VALUES 
(1 ,1 ,'Resource 1');
INSERT INTO project_resources(project_id ,resource_type ,description )VALUES 
(2 ,1 ,'Resource 2');

-- clients
INSERT INTO clients(name )VALUES 
('Client X');
INSERT INTO clients(name )VALUES 
('Client Y');

-- client_contacts
INSERT INTO client_contacts(client_id ,contact ,contact_type )VALUES 
(1 ,'client.x@example.com' ,1);
INSERT INTO client_contacts(client_id ,contact ,contact_type )VALUES 
(2 ,'client.y@example.com' ,1);

-- project_clients
INSERT INTO project_clients(project_id ,client_id )VALUES 
(1 ,1);
INSERT INTO project_clients(project_id ,client_id )VALUES 
(2 ,2);

-- project_employees
INSERT INTO project_employees(project_id ,employee_id )VALUES 
(1 ,1);
INSERT INTO project_employees(project_id ,employee_id )VALUES 
(2 ,2);

-- project_roles
INSERT INTO project_roles(project_employee_id ,staff_role_id )VALUES 
(1 ,1);
INSERT INTO project_roles(project_employee_id ,staff_role_id )VALUES 
(2 ,2);

-- project_stage_employees
INSERT INTO project_stage_employees(project_role_id ,stage_id, rate )VALUES 
(1, 1, 0.5);
INSERT INTO project_stage_employees(project_role_id ,stage_id, rate )VALUES 
(2, 2, 0.7);

-- project_payments
INSERT INTO project_payments(project_id,payment_date,payment_amount )VALUES 
(1, '2023-10-15', 10000.00);
INSERT INTO project_payments(project_id,payment_date,payment_amount )VALUES 
(2, '2023-10-15', 20000.00);

-- staff_payments
INSERT INTO staff_payments(employee_id,payment_date,hours_tracked,payment_amount )VALUES 
(1, '2023-10-15', 8, 400.00);
INSERT INTO staff_payments(employee_id,payment_date,hours_tracked,payment_amount )VALUES 
(2, '2023-10-15', 8, 560.00);

-- hardware_types
INSERT INTO hardware_types (hardware_type) VALUES ('Laptop');
INSERT INTO hardware_types (hardware_type) VALUES ('Desktop');

-- hardware
INSERT INTO hardware (hardware_type, status, is_used) VALUES (1, 'In Use', 1);
INSERT INTO hardware (hardware_type, status, is_used) VALUES (2, 'Available', 0);

-- hardware_usage
INSERT INTO hardware_usage (employee_id, hardware_id, usage_start_date, usage_end_date, status_after_usage) VALUES 
(1, 1, '2023-10-01', NULL, 'In Use');
INSERT INTO hardware_usage (employee_id, hardware_id, usage_start_date, usage_end_date, status_after_usage) VALUES 
(2, 2, '2023-09-01', '2023-10-01', 'Returned');

-- developer_access_to_resources_and_credentials
INSERT INTO developer_access_to_resources_and_credentials (employee_id, resource_id, access_start_date) VALUES 
(1, 1, '2023-10-01');
INSERT INTO developer_access_to_resources_and_credentials (employee_id, resource_id, access_start_date) VALUES 
(2, 2, '2023-09-01');
