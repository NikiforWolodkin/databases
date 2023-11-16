SELECT 
    YEAR(payment_date) AS year,
    CASE 
        WHEN MONTH(payment_date) BETWEEN 1 AND 6 THEN 'H1'
        ELSE 'H2'
    END AS half_year,
    DATEPART(QUARTER, payment_date) AS quarter,
    MONTH(payment_date) AS month,
    SUM(payment_amount) AS profit
FROM 
    project_payments
-- INNER JOIN
--     project_stages
--     ON project_payments.associated_stage = project_stages.id
-- INNER JOIN
--     project_event_types
--     ON project_stages.event_type = project_event_types.id
-- WHERE project_event_types.id = 10
GROUP BY 
    GROUPING SETS (
        (YEAR(payment_date), CASE WHEN MONTH(payment_date) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END, DATEPART(QUARTER, payment_date), MONTH(payment_date)),
        (YEAR(payment_date), CASE WHEN MONTH(payment_date) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END, DATEPART(QUARTER, payment_date)),
        (YEAR(payment_date), CASE WHEN MONTH(payment_date) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END),
        (YEAR(payment_date))
    )
ORDER BY 
    YEAR(payment_date), 
    CASE WHEN MONTH(payment_date) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END, 
    DATEPART(QUARTER, payment_date), 
    MONTH(payment_date);




SELECT 
    service_count AS volume,
    (CONVERT(DECIMAL(10, 2), service_count) / total_count) * 100 AS percent_of_total,
    (CONVERT(DECIMAL(10, 2), service_count) / max_count) * 100 AS percent_of_max
FROM 
    (
        SELECT COUNT(*) as service_count 
        FROM project_payments
        INNER JOIN
            project_stages
            ON project_payments.associated_stage = project_stages.id
        INNER JOIN
            project_event_types
            ON project_stages.event_type = project_event_types.id
        WHERE project_event_types.id = 12
        AND payment_date BETWEEN '2020-01-01' AND '2024-01-01'
    ) AS service,
    (
        SELECT COUNT(*) as total_count 
        FROM project_payments 
        WHERE payment_date BETWEEN '2020-01-01' AND '2024-01-01'
    ) AS total,
    (
        SELECT MAX(service_count) as max_count FROM
        (
            SELECT COUNT(*) as service_count 
            FROM project_payments
            INNER JOIN
                project_stages
                ON project_payments.associated_stage = project_stages.id
            INNER JOIN
                project_event_types
                ON project_stages.event_type = project_event_types.id
            WHERE payment_date BETWEEN '2020-01-01' AND '2024-01-01'
            GROUP BY project_event_types.id
        ) AS service_counts
    ) AS max_service;



SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY payment_date) AS row_num,
        project_payments.*
    FROM 
        project_payments
    WHERE 
        payment_date BETWEEN '2020-01-01' AND '2024-01-01'
) AS numbered_payments
WHERE row_num BETWEEN 1 AND 20;


SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY project_id ORDER BY payment_date) AS row_num,
        project_payments.*
    FROM 
        project_payments
    WHERE 
        payment_date BETWEEN '2020-01-01' AND '2024-01-01'
) AS partitioned_payments
WHERE row_num = 1;




SELECT 
    client_id,
    FORMAT(payment_date, 'yyyy-MM') AS month,
    COUNT(payment_amount) AS total_payment
FROM 
    project_payments
INNER JOIN 
    project_clients
    ON project_payments.project_id = project_clients.project_id
WHERE 
    payment_date >= DATEADD(MONTH, -6, GETDATE())
GROUP BY 
    client_id,
    FORMAT(payment_date, 'yyyy-MM')
ORDER BY 
    client_id,
    month;

