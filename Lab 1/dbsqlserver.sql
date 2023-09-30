CREATE DATABASE outsourcedb;

USE outsourcedb;

CREATE LOGIN outsource_login WITH PASSWORD = 'Password_01';

CREATE USER outsource_admin FOR LOGIN outsource_login;

EXEC sp_addrolemember 'db_owner', 'outsource_admin';



CREATE TABLE contact_types (
    id INT PRIMARY KEY,
    contact_type VARCHAR(50) NOT NULL
);

CREATE TABLE roles (
    id INT PRIMARY KEY,
    role VARCHAR(50) NOT NULL
);


CREATE TABLE staff (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE staff_contacts (
    id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    contact VARCHAR(200) NOT NULL,
    contact_type INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (contact_type) REFERENCES contact_types(id)
);

CREATE TABLE staff_roles (
    id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    role INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (role) REFERENCES roles(id)
);



CREATE TABLE project_event_types (
    id INT PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL
);

CREATE TABLE project_resource_types (
    id INT PRIMARY KEY,
    resource_type VARCHAR(50) NOT NULL
);


CREATE TABLE projects (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status VARCHAR(200) NOT NULL --denormalized from events
);

CREATE TABLE project_events (
    id INT PRIMARY KEY,
    project_id INT NOT NULL,
    event_type INT NOT NULL,
    description VARCHAR(200) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (event_type) REFERENCES project_event_types(id)
);

CREATE TABLE project_resources (
    id INT PRIMARY KEY,
    project_id INT NOT NULL,
    resource_type INT NOT NULL,
    description VARCHAR(200) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (resource_type) REFERENCES project_resource_types(id)
);



CREATE TABLE clients (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE client_contacts (
    id INT PRIMARY KEY,
    client_id INT NOT NULL,
    contact VARCHAR(200) NOT NULL,
    contact_type INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (contact_type) REFERENCES contact_types(id)
);

CREATE TABLE project_clients (
    id INT PRIMARY KEY,
    project_id INT NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE project_developers (
    id INT PRIMARY KEY,
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (employee_id) REFERENCES staff(id)
);



CREATE TABLE project_payments (
    id INT PRIMARY KEY,
    project_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10, 2) NOT NULL,
    associated_event INT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (associated_event) REFERENCES project_events(id)
);

CREATE TABLE staff_payments (
    id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    payment_date DATE NOT NULL,
    hours_tracked INT NOT NULL,
    payment_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id)
);



CREATE TABLE hardware_types (
    id INT PRIMARY KEY,
    hardware_type VARCHAR(50) NOT NULL
);


CREATE TABLE hardware (
    id INT PRIMARY KEY,
    hardware_type INT NOT NULL,
    status VARCHAR(200) NULL, --denormalized from hardware usage
    is_used BIT NULL, --denormalized from hardware usage
    FOREIGN KEY (hardware_type) REFERENCES hardware_types(id)
);



CREATE TABLE hardware_usage (
    id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    hardware_id INT NOT NULL,
    usage_start_date DATE NOT NULL,
    usage_end_date DATE NULL,
    status_after_usage VARCHAR(200) NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (hardware_id) REFERENCES hardware(id)
);



CREATE TABLE developer_access_to_resources_and_credentials (
    id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    resource_id INT NOT NULL,
    access_start_date DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (resource_id) REFERENCES project_resources(id)
);