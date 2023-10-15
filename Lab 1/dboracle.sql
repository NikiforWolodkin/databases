ALTER SESSION SET CONTAINER=cdb$root;

CREATE PLUGGABLE DATABASE outsourcepdb 
    ADMIN USER pdb_admin IDENTIFIED BY pass
    FILE_NAME_CONVERT = ('/pdbseed/', '/outsourcepdb/');

ALTER PLUGGABLE DATABASE outsourcepdb OPEN;

ALTER SESSION SET CONTAINER=outsourcepdb;

GRANT CREATE TABLE TO pdb_admin;
GRANT CREATE SEQUENCE TO pdb_admin;
GRANT CREATE VIEW TO pdb_admin;
GRANT CREATE TYPE TO pdb_admin;
GRANT CREATE PROCEDURE TO pdb_admin;

ALTER USER pdb_admin QUOTA 100M ON SYSTEM;

ALTER PLUGGABLE DATABASE outsourcepdb CLOSE;
DROP PLUGGABLE DATABASE outsourcepdb INCLUDING DATAFILES;



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
    salary DECIMAL(10, 2) NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE staff_contacts (
    id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    contact VARCHAR(200) NOT NULL,
    contact_type NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES staff(id),
    FOREIGN KEY (contact_type) REFERENCES contact_types(id)
);

CREATE TABLE staff_roles (
    id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    role int NOT NULL,
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

CREATE TABLE project_stages (
    id INT PRIMARY KEY,
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

CREATE TABLE project_employees (
    id INT PRIMARY KEY,
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (employee_id) REFERENCES staff(id)
);

CREATE TABLE project_roles (
    id INT PRIMARY KEY,
    project_employee_id INT NOT NULL,
    staff_role_id INT NOT NULL,
    FOREIGN KEY (project_employee_id) REFERENCES project_employees(id),
    FOREIGN KEY (staff_role_id) REFERENCES staff_roles(id)
);

CREATE TABLE project_stage_employees (
    id INT PRIMARY KEY,
    project_role_id INT NOT NULL,
    stage_id INT NOT NULL,
    rate DECIMAL(3, 2) NOT NULL,
    FOREIGN KEY (project_role_id) REFERENCES project_roles(id),
    FOREIGN KEY (stage_id) REFERENCES project_stages(id)
);



CREATE TABLE project_payments (
    id INT PRIMARY KEY,
    project_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10, 2) NOT NULL,
    associated_stage INT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (associated_stage) REFERENCES project_stages(id)
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
    is_used NUMBER(1) NULL,
    CHECK (is_used IN (0, 1)), --denormalized from hardware usage
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



-- contact_types
INSERT INTO contact_types (id, contact_type) VALUES (contact_types_seq.nextval, 'Email');
INSERT INTO contact_types (id, contact_type) VALUES (contact_types_seq.nextval, 'Phone');

-- roles
INSERT INTO roles (id, role) VALUES (roles_seq.nextval, 'Software Engineer');
INSERT INTO roles (id, role) VALUES (roles_seq.nextval, 'Project Manager');

-- staff
INSERT INTO staff (id, salary, name) VALUES (staff_seq.nextval, 5000.00, 'John Doe');
INSERT INTO staff (id, salary, name) VALUES (staff_seq.nextval, 7000.00, 'Jane Smith');

-- staff_contacts
INSERT INTO staff_contacts (id, employee_id, contact, contact_type) VALUES 
(staff_contacts_seq.nextval, 1, 'john.doe@example.com', 1);
INSERT INTO staff_contacts (id, employee_id, contact, contact_type) VALUES 
(staff_contacts_seq.nextval, 2, 'jane.smith@example.com', 1);

-- staff_roles
INSERT INTO staff_roles (id, employee_id, role) VALUES 
(staff_roles_seq.nextval, 1, 1);
INSERT INTO staff_roles (id, employee_id, role) VALUES 
(staff_roles_seq.nextval, 2, 2);

-- project_event_types
INSERT INTO project_event_types (id, event_type) VALUES 
(project_event_types_seq.nextval,'Start');
INSERT INTO project_event_types (id, event_type) VALUES 
(project_event_types_seq.nextval,'End');

-- project_resource_types
INSERT INTO project_resource_types(id ,resource_type )VALUES 
(project_resource_types_seq.nextval ,'Database connection string');
INSERT INTO project_resource_types(id ,resource_type )VALUES 
(project_resource_types_seq.nextval ,'Cloud credentials');

-- projects
INSERT INTO projects(id ,name ,status )VALUES 
(projects_seq.nextval ,'Project Alpha' ,'In Progress');
INSERT INTO projects(id ,name ,status )VALUES 
(projects_seq.nextval ,'Project Beta' ,'Completed');

-- project_stages
INSERT INTO project_stages(id ,project_id ,event_type ,previous_stage ,description, start_date, end_date )VALUES 
(project_stages_seq.nextval ,1 ,1 ,NULL ,'Project Alpha started', TO_DATE('2023-09-15', 'YYYY-MM-DD'), NULL);
INSERT INTO project_stages(id ,project_id ,event_type ,previous_stage ,description, start_date, end_date )VALUES 
(project_stages_seq.nextval ,2 ,1 ,NULL ,'Project Beta started', TO_DATE('2023-09-15', 'YYYY-MM-DD'), TO_DATE('2023-11-15', 'YYYY-MM-DD'));

-- project_resources
INSERT INTO project_resources(id ,project_id ,resource_type ,description )VALUES 
(project_resources_seq.nextval ,1 ,1 ,'Resource 1');
INSERT INTO project_resources(id ,project_id ,resource_type ,description )VALUES 
(project_resources_seq.nextval ,2 ,1 ,'Resource 2');

-- clients
INSERT INTO clients(id,name )VALUES 
(clients_seq.nextval ,'Client X');
INSERT INTO clients(id,name )VALUES 
(clients_seq.nextval ,'Client Y');

-- client_contacts
INSERT INTO client_contacts(id ,client_id ,contact ,contact_type )VALUES 
(client_contacts_seq.nextval ,1 ,'client.x@example.com' ,1);
INSERT INTO client_contacts(id ,client_id ,contact ,contact_type )VALUES 
(client_contacts_seq.nextval ,2 ,'client.y@example.com' ,1);

-- project_clients
INSERT INTO project_clients(id ,project_id ,client_id )VALUES 
(project_clients_seq.nextval ,1 ,1);
INSERT INTO project_clients(id ,project_id ,client_id )VALUES 
(project_clients_seq.nextval ,2 ,2);

-- project_employees
INSERT INTO project_employees(id ,project_id ,employee_id )VALUES 
(project_employees_seq.nextval ,1 ,1);
INSERT INTO project_employees(id ,project_id ,employee_id )VALUES 
(project_employees_seq.nextval ,2 ,2);

-- project_roles
INSERT INTO project_roles(id ,project_employee_id ,staff_role_id )VALUES 
(project_roles_seq.nextval ,1 ,1);
INSERT INTO project_roles(id ,project_employee_id ,staff_role_id )VALUES 
(project_roles_seq.nextval ,2 ,2);

-- project_stage_employees
INSERT INTO project_stage_employees(id ,project_role_id ,stage_id, rate )VALUES 
(project_stage_employees_seq.nextval, 1, 1, 0.5);
INSERT INTO project_stage_employees(id ,project_role_id ,stage_id, rate )VALUES 
(project_stage_employees_seq.nextval, 2, 2, 0.7);

-- project_payments
INSERT INTO project_payments(id, project_id,payment_date,payment_amount )VALUES 
(project_payments_seq.nextval, 1, TO_DATE('2023-10-15', 'YYYY-MM-DD'), 10000.00);
INSERT INTO project_payments(id, project_id,payment_date,payment_amount )VALUES 
(project_payments_seq.nextval, 2, TO_DATE('2023-10-15', 'YYYY-MM-DD'), 20000.00);

-- staff_payments
INSERT INTO staff_payments(id, employee_id,payment_date,hours_tracked,payment_amount )VALUES 
(staff_payments_seq.nextval, 1, TO_DATE('2023-10-15', 'YYYY-MM-DD'), 8, 400.00);
INSERT INTO staff_payments(id, employee_id,payment_date,hours_tracked,payment_amount )VALUES 
(staff_payments_seq.nextval, 2, TO_DATE('2023-10-15', 'YYYY-MM-DD'), 8, 560.00);


-- hardware_types
INSERT INTO hardware_types (id, hardware_type) VALUES (hardware_types_seq.nextval, 'Laptop');
INSERT INTO hardware_types (id, hardware_type) VALUES (hardware_types_seq.nextval, 'Desktop');

-- hardware
INSERT INTO hardware (id, hardware_type, status, is_used) VALUES (hardware_seq.nextval, 1, 'In Use', 1);
INSERT INTO hardware (id, hardware_type, status, is_used) VALUES (hardware_seq.nextval, 2, 'Available', 0);

-- hardware_usage
INSERT INTO hardware_usage (id, employee_id, hardware_id, usage_start_date, usage_end_date, status_after_usage) VALUES 
(hardware_usage_seq.nextval, 1, 1, TO_DATE('2023-10-01', 'YYYY-MM-DD'), NULL, 'In Use');
INSERT INTO hardware_usage (id, employee_id, hardware_id, usage_start_date, usage_end_date, status_after_usage) VALUES 
(hardware_usage_seq.nextval, 2, 2, TO_DATE('2023-09-01', 'YYYY-MM-DD'), TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Returned');

-- developer_access_to_resources_and_credentials
INSERT INTO developer_access_to_resources_and_credentials (id, employee_id, resource_id, access_start_date) VALUES 
(developer_access_to_resources_and_credentials_seq.nextval, 1, 1, TO_DATE('2023-10-01', 'YYYY-MM-DD'));
INSERT INTO developer_access_to_resources_and_credentials (id, employee_id, resource_id, access_start_date) VALUES 
(developer_access_to_resources_and_credentials_seq.nextval, 2, 2, TO_DATE('2023-09-01', 'YYYY-MM-DD'));
