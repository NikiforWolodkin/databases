CREATE TABLE VND_T (ID NUMBER);

INSERT INTO VND_T VALUES (10);
COMMIT;

SELECT * FROM VND_T;

SELECT DISTINCT OBJECT_NAME FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'TABLE';