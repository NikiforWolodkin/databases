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



CREATE VIEW employee_project_info AS
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



CREATE PROCEDURE get_top_paying_projects AS
BEGIN
  SELECT p.id AS project_id, p.name AS project_name, SUM(pp.payment_amount) AS total_payment_amount
  FROM project_payments pp
  JOIN projects p ON pp.project_id = p.id
  GROUP BY p.id, p.name
  ORDER BY total_payment_amount DESC;
END;

EXEC get_top_paying_projects;



CREATE PROCEDURE get_monthly_profits AS
BEGIN
  SELECT 
    ISNULL(project_month.month, staff_month.month) AS month, 
    ISNULL(project_payments, 0) - ISNULL(staff_payments, 0) AS profit
  FROM (
    SELECT FORMAT(payment_date, 'yyyy-MM') AS month, SUM(payment_amount) AS project_payments
    FROM project_payments
    GROUP BY FORMAT(payment_date, 'yyyy-MM')
  ) project_month
  FULL OUTER JOIN (
    SELECT FORMAT(payment_date, 'yyyy-MM') AS month, SUM(payment_amount) AS staff_payments
    FROM staff_payments
    GROUP BY FORMAT(payment_date, 'yyyy-MM')
  ) staff_month ON project_month.month = staff_month.month
  ORDER BY month;
END;

EXEC get_monthly_profits;



CREATE PROCEDURE get_project_profits AS
BEGIN
    SELECT p.id AS project_id,
           p.name AS project_name,
           SUM(pp.payment_amount) - 
           (SELECT SUM(spe.rate * sp.payment_amount)
            FROM project_employees pe
            JOIN project_roles pr ON pe.id = pr.project_employee_id
            JOIN project_stage_employees spe ON pr.id = spe.project_role_id
            JOIN staff_payments sp ON pe.employee_id = sp.employee_id
            JOIN project_stages ps ON spe.stage_id = ps.id
            WHERE pe.project_id = p.id AND sp.payment_date BETWEEN ps.start_date AND ISNULL(ps.end_date, GETDATE())) AS profit
    FROM projects p
    JOIN project_payments pp ON p.id = pp.project_id
    GROUP BY p.id, p.name;
END;

EXEC get_project_profits;