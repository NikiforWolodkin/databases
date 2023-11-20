DECLARE
  FUNCTION total_project_payments(p_project_id INT) RETURN DECIMAL IS 
    v_total DECIMAL(10, 2); 
  BEGIN 
    SELECT SUM(payment_amount) INTO v_total
    FROM project_payments
    WHERE project_id = p_project_id;
    
    RETURN v_total; 
  END total_project_payments; 

  PROCEDURE show_project_name(p_project_id INT) IS 
    v_name VARCHAR(50);
  BEGIN 
    SELECT name INTO v_name
    FROM projects
    WHERE id = p_project_id;
    
    DBMS_OUTPUT.PUT_LINE ('Project Name: ' || v_name); 
  END show_project_name; 

BEGIN
  DBMS_OUTPUT.PUT_LINE ('Total Payments: ' || TO_CHAR(total_project_payments(1)));
  show_project_name(1);
END;



CREATE OR REPLACE PROCEDURE add_project_payment(
  p_id INT,
  p_project_id INT, 
  p_payment_date DATE, 
  p_payment_amount DECIMAL, 
  p_associated_stage INT
) AS 
BEGIN 
  INSERT INTO project_payments(id, project_id, payment_date, payment_amount, associated_stage)
  VALUES (p_id, p_project_id, p_payment_date, p_payment_amount, p_associated_stage);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error code ' || SQLCODE || ': ' || SQLERRM);
END add_project_payment;

BEGIN
  add_project_payment(50, 10, SYSDATE, 1000, NULL);
END;

CREATE OR REPLACE TYPE project_payment_obj AS OBJECT (
  payment_date DATE,
  payment_amount DECIMAL(10, 2)
);

CREATE OR REPLACE TYPE project_payment_tab AS TABLE OF project_payment_obj;

CREATE OR REPLACE FUNCTION view_project_payments(p_project_id INT)
RETURN project_payment_tab PIPELINED IS
BEGIN
  FOR rec IN (SELECT payment_date, payment_amount 
              FROM project_payments 
              WHERE project_id = p_project_id) LOOP
    PIPE ROW(project_payment_obj(rec.payment_date, rec.payment_amount));
  END LOOP;
  
  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error code ' || SQLCODE || ': ' || SQLERRM);
END view_project_payments;

SELECT * FROM view_project_payments(10);



CREATE OR REPLACE FUNCTION avg_project_payment(p_project_id INT) 
RETURN NUMBER IS
    total NUMBER(10,2);
BEGIN
    SELECT AVG(payment_amount) INTO total
    FROM project_payments
    WHERE project_id = p_project_id;

    RETURN total;
END avg_project_payment;

CREATE OR REPLACE FUNCTION payment_date_difference_first_last(p_project_id INT) 
RETURN INT IS
    first_date DATE;
    last_date DATE;
BEGIN
    SELECT MIN(payment_date) INTO first_date
    FROM project_payments
    WHERE project_id = p_project_id;

    SELECT MAX(payment_date) INTO last_date
    FROM project_payments
    WHERE project_id = p_project_id;

    RETURN last_date - first_date;
END payment_date_difference_first_last;

BEGIN
    DBMS_OUTPUT.PUT_LINE ('Average Payments: ' || TO_CHAR(avg_project_payment(10)));
    DBMS_OUTPUT.PUT_LINE ('Date Difference: ' || TO_CHAR(payment_date_difference_first_last(10)) || ' days');
END;

SELECT avg_project_payment(10) FROM DUAL;
SELECT payment_date_difference_first_last(10) FROM DUAL;



CREATE OR REPLACE PACKAGE project_payments_pkg AS
    FUNCTION avg_project_payments(p_project_id INT) RETURN NUMBER;
    FUNCTION payment_date_difference_first_last(p_project_id INT) RETURN INT;
    PROCEDURE add_project_payment(
        p_id INT,
        p_project_id INT, 
        p_payment_date DATE, 
        p_payment_amount DECIMAL, 
        p_associated_stage INT
    );
END project_payments_pkg;

CREATE OR REPLACE PACKAGE BODY project_payments_pkg AS
    FUNCTION avg_project_payments(p_project_id INT) 
    RETURN NUMBER IS
        total NUMBER(10,2);
    BEGIN
        SELECT AVG(payment_amount) INTO total
        FROM project_payments
        WHERE project_id = p_project_id;

        RETURN total;
    END avg_project_payments;

    FUNCTION payment_date_difference_first_last(p_project_id INT) 
    RETURN INT IS
        first_date DATE;
        last_date DATE;
    BEGIN
        SELECT MIN(payment_date) INTO first_date
        FROM project_payments
        WHERE project_id = p_project_id;

        SELECT MAX(payment_date) INTO last_date
        FROM project_payments
        WHERE project_id = p_project_id;

        RETURN last_date - first_date;
    END payment_date_difference_first_last;

    PROCEDURE add_project_payment(
        p_id INT,
        p_project_id INT, 
        p_payment_date DATE, 
        p_payment_amount DECIMAL, 
        p_associated_stage INT
    ) AS 
    BEGIN 
        INSERT INTO project_payments(id, project_id, payment_date, payment_amount, associated_stage)
        VALUES (p_id, p_project_id, p_payment_date, p_payment_amount, p_associated_stage);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error code ' || SQLCODE || ': ' || SQLERRM);
    END add_project_payment;
END project_payments_pkg;

DECLARE
    avg NUMBER(10,2);
    diff INT;
BEGIN
    avg := project_payments_pkg.avg_project_payments(10);
    DBMS_OUTPUT.PUT_LINE('Avg: ' || avg);

    diff := project_payments_pkg.payment_date_difference_first_last(10);
    DBMS_OUTPUT.PUT_LINE('Diff: ' || diff);

    project_payments_pkg.add_project_payment(51, 10, SYSDATE, 1000, NULL);
END;
