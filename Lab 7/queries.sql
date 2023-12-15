SELECT *
FROM (
    SELECT project_event_types.id AS event_type_id, TO_CHAR(payment_date, 'YYYY-MM') AS month, SUM(payment_amount) AS payment
    FROM project_payments
    INNER JOIN
        project_stages
        ON project_payments.associated_stage = project_stages.id
    INNER JOIN
        project_event_types
        ON project_stages.event_type = project_event_types.id
    WHERE payment_date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-12-31', 'YYYY-MM-DD')
    GROUP BY project_event_types.id, TO_CHAR(payment_date, 'YYYY-MM')
)
MODEL
    PARTITION BY (event_type_id)
    DIMENSION BY (TO_NUMBER(SUBSTR(month, 6)) AS month_num)
    MEASURES (payment)
    RULES (
        payment[FOR month_num FROM 1 TO 12 INCREMENT 1] = payment[CV()] * 1.05
    )
ORDER BY event_type_id, month_num;

select * from project_event_types;

SELECT start_quarter, end_quarter
FROM (
    SELECT TO_CHAR(payment_date, 'YYYY-Q') AS quarter, 
           SUM(payment_amount) AS total_income
    FROM project_payments
    GROUP BY TO_CHAR(payment_date, 'YYYY-Q')
)
MATCH_RECOGNIZE (
    ORDER BY quarter
    MEASURES FIRST(quarter) AS start_quarter,
             LAST(quarter) AS end_quarter
    ONE ROW PER MATCH
    PATTERN (GROWTH FALL GROWTH)
    DEFINE 
        GROWTH AS total_income > PREV(total_income),
        FALL AS total_income < PREV(total_income)
);
