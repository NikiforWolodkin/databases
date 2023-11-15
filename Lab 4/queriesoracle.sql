SELECT 
    year,
    month,
    quarter,
    half_year,
    SUM(profit) AS profit
FROM (
    SELECT 
        TO_CHAR(project_month.payment_date, 'YYYY') AS year,
        CASE 
            WHEN TO_CHAR(project_month.payment_date, 'MM') IN ('01', '02', '03', '04', '05', '06') THEN 'H1'
            ELSE 'H2'
        END AS half_year,
        TO_CHAR(project_month.payment_date, 'Q') AS quarter,
        TO_CHAR(project_month.payment_date, 'MM') AS month,
        NVL(project_payments, 0) AS profit
    FROM (
        SELECT 
            payment_date,
            SUM(payment_amount) AS project_payments
        FROM 
            project_payments
        -- INNER JOIN
        --     project_stages
        --     ON project_payments.associated_stage = project_stages.id
        -- INNER JOIN
        --     project_event_types
        --     ON project_stages.event_type = project_event_types.id
        -- WHERE project_event_types.id = 1
        GROUP BY 
            payment_date
    ) project_month
)
GROUP BY ROLLUP (year, half_year, quarter, month)
ORDER BY year, half_year, quarter, month;



SELECT 
    service_count AS volume,
    (service_count / total_count) * 100 AS percent_of_total,
    (service_count / max_count) * 100 AS percent_of_total
FROM 
    (
        SELECT COUNT(*) as service_count 
        FROM project_payments
        -- INNER JOIN
        --     project_stages
        --     ON project_payments.associated_stage = project_stages.id
        -- INNER JOIN
        --     project_event_types
        --     ON project_stages.event_type = project_event_types.id
        -- WHERE project_event_types.id = 1
        WHERE payment_date BETWEEN date '2020-01-01' AND date '2024-01-01'
    ),
    (
        SELECT COUNT(*) as total_count 
        FROM project_payments 
        WHERE payment_date BETWEEN date '2020-01-01' AND date '2024-01-01'
    ),
    (
        SELECT MAX(service_count) as max_count FROM
        (
            SELECT COUNT(*) as service_count 
            FROM project_payments
            -- INNER JOIN
            --     project_stages
            --     ON project_payments.associated_stage = project_stages.id
            -- INNER JOIN
            --     project_event_types
            --     ON project_stages.event_type = project_event_types.id
            WHERE payment_date BETWEEN date '2020-01-01' AND date '2024-01-01'
            -- GROUP BY project_event_types.id
        )
    );



SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY payment_date) AS row_num,
        project_payments.*
    FROM 
        project_payments
    WHERE 
        payment_date BETWEEN date '2020-01-01' AND date '2024-01-01'
) 
WHERE row_num BETWEEN 1 AND 20;

SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY project_id ORDER BY payment_date) AS row_num,
        project_payments.*
    FROM 
        project_payments
    WHERE 
        payment_date BETWEEN date '2020-01-01' AND date '2024-01-01'
) 
WHERE row_num = 1;



SELECT 
    client_id,
    TO_CHAR(payment_date, 'YYYY-MM') AS month,
    COUNT(payment_amount) AS total_payment
FROM 
    project_payments
INNER JOIN 
    project_clients
    ON project_payments.project_id = project_clients.project_id
WHERE 
    payment_date >= ADD_MONTHS(SYSDATE, -6)
GROUP BY 
    client_id,
    TO_CHAR(payment_date, 'YYYY-MM')
ORDER BY 
    client_id,
    month;
