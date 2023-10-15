CREATE SEQUENCE contact_types_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE roles_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE staff_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE staff_contacts_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE staff_roles_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_event_types_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_resource_types_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE projects_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_stages_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_resources_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE clients_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE client_contacts_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_clients_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_employees_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_roles_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_stage_employees_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE project_payments_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE staff_payments_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE hardware_types_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE hardware_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE hardware_usage_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE developer_access_to_resources_and_credentials_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;



CREATE INDEX idx_staff_name ON staff (name);

CREATE INDEX idx_staff_contacts_employee_id ON staff_contacts (employee_id);
CREATE INDEX idx_staff_roles_employee_id ON staff_roles (employee_id);

CREATE INDEX idx_projects_name ON projects (name);

CREATE INDEX idx_project_stages_project_id ON project_stages (project_id);
CREATE INDEX idx_project_resources_project_id ON project_resources (project_id);

CREATE INDEX idx_clients_name ON clients (name);

CREATE INDEX idx_client_contacts_client_id ON client_contacts (client_id);

CREATE INDEX idx_project_clients_project_id ON project_clients (project_id);
CREATE INDEX idx_project_clients_client_id ON project_clients (client_id);

CREATE INDEX idx_project_employees_project_id ON project_employees (project_id);
CREATE INDEX idx_project_employees_employee_id ON project_employees (employee_id);

CREATE INDEX idx_project_roles_project_employee_id ON project_roles(project_employee_id);

CREATE INDEX idx_project_stage_employees_project_role_id ON project_stage_employees(project_role_id);
CREATE INDEX idx_project_stage_employees_stage_id ON project_stage_employees(stage_id);

CREATE INDEX idx_project_payments_project_id ON project_payments(project_id);

CREATE INDEX idx_staff_payments_employee_id ON staff_payments(employee_id);

CREATE INDEX idx_hardware_usage_employee_id ON hardware_usage(employee_id);
CREATE INDEX idx_hardware_usage_hardware_id ON hardware_usage(hardware_id);

CREATE INDEX idx_developer_access_to_resources_and_credentials_employee_id ON developer_access_to_resources_and_credentials(employee_id);
CREATE INDEX idx_developer_access_to_resources_and_credentials_resource_id ON developer_access_to_resources_and_credentials(resource_id);



CREATE OR REPLACE VIEW employee_project_info AS
SELECT 
    s.id AS employee_id,
    s.name AS employee_name,
    p.name AS project_name,
    et.event_type AS project_stage_event_type,
    r.role AS role_name_on_project,
    pse.rate AS rate,
    s.salary AS salary
FROM 
    staff s
JOIN 
    project_employees pe ON s.id = pe.employee_id
JOIN 
    projects p ON pe.project_id = p.id
JOIN 
    project_roles pr ON pe.id = pr.project_employee_id
JOIN 
    staff_roles sr ON pr.staff_role_id = sr.id
JOIN 
    roles r ON sr.role = r.id
JOIN 
    project_stage_employees pse ON pr.id = pse.project_role_id
JOIN 
    project_stages ps ON pse.stage_id = ps.id
JOIN 
    project_event_types et ON ps.event_type = et.id;

SELECT * FROM employee_project_info;



CREATE OR REPLACE TYPE project_payment AS OBJECT (
  project_id INT,
  project_name VARCHAR2(50),
  total_payment_amount DECIMAL(10,2)
);

CREATE OR REPLACE TYPE project_payment_tab IS TABLE OF project_payment;

CREATE OR REPLACE FUNCTION get_top_paying_projects RETURN project_payment_tab PIPELINED AS
BEGIN
  FOR rec IN (
    SELECT p.id AS project_id, p.name AS project_name, SUM(pp.payment_amount) AS total_payment_amount
    FROM project_payments pp
    JOIN projects p ON pp.project_id = p.id
    GROUP BY p.id, p.name
    ORDER BY total_payment_amount DESC
  ) LOOP
    PIPE ROW(project_payment(rec.project_id, rec.project_name, rec.total_payment_amount));
  END LOOP;
  
  RETURN;
END get_top_paying_projects;

SELECT * FROM TABLE(get_top_paying_projects());



CREATE OR REPLACE TYPE profit_row AS OBJECT (
    month VARCHAR2(7),
    profit DECIMAL(10, 2)
);

CREATE OR REPLACE TYPE profit_table AS TABLE OF profit_row;

CREATE OR REPLACE FUNCTION get_monthly_profits RETURN profit_table PIPELINED IS
BEGIN
    FOR row IN (
        SELECT project_month.month, NVL(project_payments, 0) - NVL(staff_payments, 0) AS profit
        FROM (
            SELECT TO_CHAR(payment_date, 'YYYY-MM') AS month, SUM(payment_amount) AS project_payments
            FROM project_payments
            GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
        ) project_month
        FULL OUTER JOIN (
            SELECT TO_CHAR(payment_date, 'YYYY-MM') AS month, SUM(payment_amount) AS staff_payments
            FROM staff_payments
            GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
        ) staff_month ON project_month.month = staff_month.month
        ORDER BY month
    )
    LOOP
        PIPE ROW(profit_row(row.month, row.profit));
    END LOOP;
    RETURN;
END get_monthly_profits;

SELECT * FROM TABLE(get_monthly_profits());



CREATE OR REPLACE TYPE project_profit_row AS OBJECT (
    project_id INT,
    project_name VARCHAR2(50),
    profit DECIMAL(10, 2)
);

CREATE OR REPLACE TYPE project_profit_table AS TABLE OF project_profit_row;

CREATE OR REPLACE FUNCTION get_project_profits RETURN project_profit_table PIPELINED IS
BEGIN
    FOR row IN (
        SELECT p.id AS project_id,
               p.name AS project_name,
               SUM(pp.payment_amount) - 
               (SELECT SUM(spe.rate * sp.payment_amount)
                FROM project_employees pe
                JOIN project_roles pr ON pe.id = pr.project_employee_id
                JOIN project_stage_employees spe ON pr.id = spe.project_role_id
                JOIN staff_payments sp ON pe.employee_id = sp.employee_id
                JOIN project_stages ps ON spe.stage_id = ps.id
                WHERE pe.project_id = p.id AND sp.payment_date BETWEEN ps.start_date AND NVL(ps.end_date, SYSDATE)) AS profit
        FROM projects p
        JOIN project_payments pp ON p.id = pp.project_id
        GROUP BY p.id, p.name
    )
    LOOP
        PIPE ROW(project_profit_row(row.project_id, row.project_name, row.profit));
    END LOOP;
    RETURN;
END get_project_profits;

SELECT * FROM TABLE(get_project_profits());

