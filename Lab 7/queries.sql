SELECT *
FROM (
    SELECT project_payments.project_id, TO_CHAR(payment_date, 'YYYY-MM') AS month, SUM(payment_amount) AS payment
    FROM project_payments
    INNER JOIN
        project_stages
        ON project_payments.associated_stage = project_stages.id
    INNER JOIN
        project_event_types
        ON project_stages.event_type = project_event_types.id
    WHERE payment_date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-12-31', 'YYYY-MM-DD')
    AND project_event_types.id = 10
    GROUP BY project_payments.project_id, TO_CHAR(payment_date, 'YYYY-MM')
)
MODEL
    PARTITION BY (project_id)
    DIMENSION BY (TO_NUMBER(SUBSTR(month, 6)) AS month_num)
    MEASURES (payment)
    RULES (
        payment[FOR month_num FROM 1 TO 12 INCREMENT 1] = payment[CV()] * 1.05
    )
ORDER BY project_id, month_num;

SELECT project_id, start_quarter, end_quarter
FROM (
    SELECT project_payments.project_id, 
           TO_CHAR(payment_date, 'YYYY-Q') AS quarter, 
           SUM(payment_amount) AS payment
    FROM project_payments
    INNER JOIN
        project_stages
        ON project_payments.associated_stage = project_stages.id
    INNER JOIN
        project_event_types
        ON project_stages.event_type = project_event_types.id
    WHERE project_event_types.id = 13
    GROUP BY project_payments.project_id, TO_CHAR(payment_date, 'YYYY-Q')
)
MATCH_RECOGNIZE (
    PARTITION BY project_id
    ORDER BY quarter
    MEASURES FIRST(quarter) AS start_quarter,
             NEXT(quarter) AS second_quarter,
             LAST(quarter) AS end_quarter
    ONE ROW PER MATCH
    PATTERN (GROWTH FALL GROWTH)
    DEFINE 
        GROWTH AS payment > PREV(payment),
        FALL AS payment < PREV(payment)
);
