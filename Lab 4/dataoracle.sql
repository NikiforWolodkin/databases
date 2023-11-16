INSERT INTO project_event_types (id, event_type) VALUES (10, 'Development');
INSERT INTO project_event_types (id, event_type) VALUES (11, 'Consulting');
INSERT INTO project_event_types (id, event_type) VALUES (12, 'Testing');
INSERT INTO project_event_types (id, event_type) VALUES (13, 'Management');

INSERT INTO projects (id, name, status) VALUES (10, 'Inventory Management System', 'In Progress');
INSERT INTO projects (id, name, status) VALUES (11, 'Online Booking Platform', 'Completed');
INSERT INTO projects (id, name, status) VALUES (12, 'E-commerce Website', 'In Progress');
INSERT INTO projects (id, name, status) VALUES (13, 'Customer Relationship Management', 'Completed');
INSERT INTO projects (id, name, status) VALUES (14, 'Content Management System', 'In Progress');
INSERT INTO projects (id, name, status) VALUES (15, 'Human Resources Management', 'Completed');
INSERT INTO projects (id, name, status) VALUES (16, 'Financial Management System', 'In Progress');
INSERT INTO projects (id, name, status) VALUES (17, 'Supply Chain Management System', 'Completed');
INSERT INTO projects (id, name, status) VALUES (18, 'Data Analysis Tool', 'In Progress');
INSERT INTO projects (id, name, status) VALUES (19, 'Project Management Application', 'Completed');

-- For Project 10: Inventory Management System
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (10, 10, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Inventory Management System');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (11, 10, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-03-01','YYYY-MM-DD'), 11, 'Consulting stage for Inventory Management System');

-- For Project 11: Online Booking Platform
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (12, 11, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Online Booking Platform');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (13, 11, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-03-01','YYYY-MM-DD'), 11, 'Consulting stage for Online Booking Platform');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (14, 11, TO_DATE('2023-03-02','YYYY-MM-DD'), TO_DATE('2023-04-01','YYYY-MM-DD'), 12, 'Testing stage for Online Booking Platform');

-- For Project 12: E-commerce Website
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (15, 12, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for E-commerce Website');

-- For Project 13: Customer Relationship Management
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (16, 13, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Customer Relationship Management');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (17, 13, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-03-01','YYYY-MM-DD'), 11, 'Consulting stage for Customer Relationship Management');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (18, 13, TO_DATE('2023-03-02','YYYY-MM-DD'), TO_DATE('2023-04-01','YYYY-MM-DD'), 12, 'Testing stage for Customer Relationship Management');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (19, 13, TO_DATE('2023-04-02','YYYY-MM-DD'), TO_DATE('2023-05-01','YYYY-MM-DD'), 13, 'Management stage for Customer Relationship Management');

-- For Project 14: Content Management System
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (20, 14, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Content Management System');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (21, 14, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-03-01','YYYY-MM-DD'), 11, 'Consulting stage for Content Management System');

-- For Project 15: Human Resources Management
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (22, 15, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Human Resources Management');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (23, 15, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-03-01','YYYY-MM-DD'), 11, 'Consulting stage for Human Resources Management');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (24, 15, TO_DATE('2023-03-02','YYYY-MM-DD'), TO_DATE('2023-04-01','YYYY-MM-DD'), 12, 'Testing stage for Human Resources Management');

-- For Project 16: Financial Management System
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (25, 16, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Financial Management System');

-- For Project 17: Supply Chain Management System
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (26, 17, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Supply Chain Management System');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (27, 17, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-03-01','YYYY-MM-DD'), 11, 'Consulting stage for Supply Chain Management System');

-- For Project 18: Data Analysis Tool
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (28, 18, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Data Analysis Tool');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (29, 18, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-03-01','YYYY-MM-DD'), 11, 'Consulting stage for Data Analysis Tool');
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (30, 18, TO_DATE('2023-03-02','YYYY-MM-DD'), TO_DATE('2023-04-01','YYYY-MM-DD'), 12, 'Testing stage for Data Analysis Tool');

-- For Project 19: Project Management Application
INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, description) VALUES (31, 19, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-02-01','YYYY-MM-DD'), 10, 'Development stage for Project Management Application');

INSERT INTO clients (id, name) VALUES (10, 'TechSolutions Ltd.');
INSERT INTO clients (id, name) VALUES (11, 'HealthCare Inc.');
INSERT INTO clients (id, name) VALUES (12, 'EduServices Pvt. Ltd.');
INSERT INTO clients (id, name) VALUES (13, 'FinManage Corp.');
INSERT INTO clients (id, name) VALUES (14, 'RetailMarkets LLC');
INSERT INTO clients (id, name) VALUES (15, 'SupplyChain Co.');

INSERT INTO project_clients (id, project_id, client_id) VALUES (10, 10, 10);
INSERT INTO project_clients (id, project_id, client_id) VALUES (11, 11, 11);
INSERT INTO project_clients (id, project_id, client_id) VALUES (12, 12, 12);
INSERT INTO project_clients (id, project_id, client_id) VALUES (13, 13, 13);
INSERT INTO project_clients (id, project_id, client_id) VALUES (14, 14, 14);
INSERT INTO project_clients (id, project_id, client_id) VALUES (15, 15, 15);
INSERT INTO project_clients (id, project_id, client_id) VALUES (16, 16, 12);
INSERT INTO project_clients (id, project_id, client_id) VALUES (17, 17, 13);
INSERT INTO project_clients (id, project_id, client_id) VALUES (18, 18, 14);
INSERT INTO project_clients (id, project_id, client_id) VALUES (19, 19, 15);

-- Payments for Project 10: Inventory Management System
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (10, 10, TO_DATE('2021-02-01','YYYY-MM-DD'), 5000.00, 10);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (11, 10, TO_DATE('2022-03-01','YYYY-MM-DD'), 3000.00, 10);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (12, 10, TO_DATE('2023-04-01','YYYY-MM-DD'), 2000.00, 10);

-- Payments for Project 11: Online Booking Platform
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (13, 11, TO_DATE('2021-05-01','YYYY-MM-DD'), 6000.00, 11);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (14, 11, TO_DATE('2021-07-01','YYYY-MM-DD'), 4000.00, 11);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (15, 11, TO_DATE('2021-09-01','YYYY-MM-DD'), 3000.00, 11);

-- Payments for Project 12: E-commerce Website
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (16, 12, TO_DATE('2021-10-01','YYYY-MM-DD'), 7000.00, 12);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (17, 12, TO_DATE('2022-03-01','YYYY-MM-DD'), 5000.00, 12);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (18, 12, TO_DATE('2023-04-01','YYYY-MM-DD'), 4000.00, 12);

-- Payments for Project 13: Customer Relationship Management
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (19, 13, TO_DATE('2023-01-01','YYYY-MM-DD'), 8000.00, 13);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (20, 13, TO_DATE('2023-03-01','YYYY-MM-DD'), 6000.00, 13);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (21, 13, TO_DATE('2023-07-01','YYYY-MM-DD'), 5000.00, 13);

-- Payments for Project 14: Content Management System
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (22, 14, TO_DATE('2021-02-01','YYYY-MM-DD'), 9000.00, 14);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (23, 14, TO_DATE('2021-09-01','YYYY-MM-DD'), 7000.00, 14);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (24, 14, TO_DATE('2021-11-01','YYYY-MM-DD'), 6000.00, 14);

-- Payments for Project 15: Human Resources Management
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (25, 15, TO_DATE('2021-02-01','YYYY-MM-DD'), 10000.00, 15);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (26, 15, TO_DATE('2022-03-01','YYYY-MM-DD'), 8000.00, 15);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (27, 15, TO_DATE('2022-04-01','YYYY-MM-DD'), 7000.00, 15);

-- Payments for Project 16: Financial Management System
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (28, 16, TO_DATE('2023-02-01','YYYY-MM-DD'), 11000.00, 16);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (29, 16, TO_DATE('2023-05-01','YYYY-MM-DD'), 9000.00, 16);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (30, 16, TO_DATE('2023-07-01','YYYY-MM-DD'), 8000.00, 16);

-- Payments for Project 17: Supply Chain Management System
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (31, 17, TO_DATE('2021-06-01','YYYY-MM-DD'), 12000.00, 17);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (32, 17, TO_DATE('2023-02-01','YYYY-MM-DD'), 10000.00, 17);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (33, 17, TO_DATE('2023-09-01','YYYY-MM-DD'), 9000.00, 17);

-- Payments for Project 18: Data Analysis Tool
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (34, 18, TO_DATE('2021-02-01','YYYY-MM-DD'), 13000.00, 18);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (35, 18, TO_DATE('2022-01-01','YYYY-MM-DD'), 11000.00, 18);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (36, 18, TO_DATE('2022-02-01','YYYY-MM-DD'), 10000.00, 18);

-- Payments for Project 19: Project Management Application
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (37, 19, TO_DATE('2021-02-01','YYYY-MM-DD'), 14000.00, 19);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (38, 19, TO_DATE('2022-03-01','YYYY-MM-DD'), 12000.00, 19);
INSERT INTO project_payments (id, project_id, payment_date, payment_amount, associated_stage) VALUES (39, 19, TO_DATE('2022-04-01','YYYY-MM-DD'), 11000.00, 19);
