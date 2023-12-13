show errors

DROP TYPE employee_type FORCE;
DROP TYPE employee_contact_type FORCE;
DROP TYPE employee_role_type FORCE;


CREATE OR REPLACE TYPE employee_type AS OBJECT (
    id INT,
    name VARCHAR2(50),
    salary NUMBER,
    roles employee_role_table,
    contacts employee_contact_table,
    CONSTRUCTOR FUNCTION employee_type(self IN OUT NOCOPY employee_type, id NUMBER, name VARCHAR2, salary NUMBER, roles employee_role_table, contacts employee_contact_table) RETURN SELF AS RESULT,
    MEMBER FUNCTION get_annual_salary RETURN NUMBER,
    MEMBER PROCEDURE increase_salary (increase_rate NUMBER),
    MAP MEMBER FUNCTION compare_salary RETURN NUMBER
) NOT FINAL;

CREATE OR REPLACE TYPE BODY employee_type AS
    CONSTRUCTOR FUNCTION employee_type(self IN OUT NOCOPY employee_type, id NUMBER, name VARCHAR2, salary NUMBER, roles employee_role_table, contacts employee_contact_table) RETURN SELF AS RESULT IS
    BEGIN
        self.id := id;
        self.name := name;
        self.salary := salary;
        self.roles := roles;
        self.contacts := contacts;
        RETURN;
    END;

    MEMBER FUNCTION get_annual_salary RETURN NUMBER IS
    BEGIN
        RETURN self.salary * 12;
    END;

    MEMBER PROCEDURE increase_salary (increase_rate NUMBER) IS
    BEGIN
        self.salary := self.salary * (1 + increase_rate);
    END;

    MAP MEMBER FUNCTION compare_salary RETURN NUMBER IS
    BEGIN
        RETURN self.salary;
    END;
END;



CREATE OR REPLACE TYPE employee_contact_type AS OBJECT (
    id INT,
    contact VARCHAR2(20),
    CONSTRUCTOR FUNCTION employee_contact_type(self IN OUT NOCOPY employee_contact_type, id INT, contact VARCHAR2) RETURN SELF AS RESULT,
    ORDER MEMBER FUNCTION compare_contact (other IN employee_contact_type) RETURN INTEGER
);

CREATE OR REPLACE TYPE BODY employee_contact_type AS
    CONSTRUCTOR FUNCTION employee_contact_type(self IN OUT NOCOPY employee_contact_type, id INT, contact VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        self.id := id;
        self.contact := contact;
        RETURN;
    END;

    ORDER MEMBER FUNCTION compare_contact (other IN employee_contact_type) RETURN INTEGER IS
    BEGIN
        IF self.id < other.id THEN
            RETURN -1;
        ELSIF self.id > other.id THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END compare_contact;
END;



CREATE OR REPLACE TYPE employee_role_type AS OBJECT (
    id INT,
    role VARCHAR2(20),
    CONSTRUCTOR FUNCTION employee_role_type(self IN OUT NOCOPY employee_role_type, id INT, role VARCHAR2) RETURN SELF AS RESULT,
    ORDER MEMBER FUNCTION compare_role (other IN employee_role_type) RETURN INTEGER
);

CREATE OR REPLACE TYPE BODY employee_role_type AS
    CONSTRUCTOR FUNCTION employee_role_type(self IN OUT NOCOPY employee_role_type, id INT, role VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        self.id := id;
        self.role := role;
        RETURN;
    END;

    ORDER MEMBER FUNCTION compare_role (other IN employee_role_type) RETURN INTEGER IS
    BEGIN
        IF self.id < other.id THEN
            RETURN -1;
        ELSIF self.id > other.id THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END compare_role;
END;

DROP TYPE employee_role_table;
DROP TYPE employee_contact_table;

CREATE OR REPLACE TYPE employee_role_table IS TABLE OF employee_role_type;
CREATE OR REPLACE TYPE employee_contact_table IS TABLE OF employee_contact_type;


DROP TABLE employees;

CREATE TABLE employees OF employee_type (
    PRIMARY KEY (id)
) NESTED TABLE roles STORE AS employee_roles_nt
  NESTED TABLE contacts STORE AS employee_contacts_nt;

DECLARE
    roles employee_role_table;
    contacts employee_contact_table;
BEGIN
    roles := employee_role_table();
    roles.extend;
    roles(1) := employee_role_type(10, 'Dev');

    contacts := employee_contact_table();
    contacts.extend(1);
    contacts(1) := employee_contact_type(10, '123-456-7890');

    INSERT INTO employees
    VALUES (employee_type(10, 'John Doe', 50000, roles, contacts));
END;

SELECT * FROM employees;



CREATE VIEW employee_view AS
SELECT id, name, salary, (SELECT COUNT(id) FROM TABLE(employees.roles)) AS role_count FROM employees;

SELECT * FROM employee_view;

CREATE INDEX salary_idx ON employees (salary);



CREATE OR REPLACE FUNCTION get_roles (p_id INT)
RETURN employee_role_table PIPELINED
IS
  v_role employee_role_type;
BEGIN
  FOR r IN (SELECT sr.id, r.role
            FROM staff_roles sr
            JOIN roles r ON sr.role = r.id
            WHERE sr.employee_id = p_id)
  LOOP
    v_role := employee_role_type(r.id, r.role);
    PIPE ROW (v_role);
  END LOOP;
  
  RETURN;
END;

SELECT get_roles(1) FROM DUAL;

CREATE OR REPLACE FUNCTION get_contacts (p_id INT)
RETURN employee_contact_table PIPELINED
IS
  v_contact employee_contact_type;
BEGIN
  FOR c IN (SELECT sc.id, SUBSTR(sc.contact, 1, 20) AS contact
            FROM staff_contacts sc
            WHERE sc.employee_id = p_id)
  LOOP
    v_contact := employee_contact_type(c.id, c.contact);
    PIPE ROW (v_contact);
  END LOOP;
  
  RETURN;
END;

SELECT get_contacts(1) FROM DUAL;

INSERT INTO employees (id, name, salary, roles, contacts)
SELECT id, name, salary, CAST(get_roles(id) AS employee_role_table), CAST(get_contacts(id) AS employee_contact_table)
FROM staff;

SELECT * FROM employees;