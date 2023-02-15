CREATE TABLE VND_t (
    ID NUMBER(3) PRIMARY KEY,
    name VARCHAR2(50)
);

INSERT INTO vnd_t VALUES (10, 'Andrey');
INSERT INTO vnd_t VALUES (11, 'Dmitry');
INSERT INTO vnd_t VALUES (12, 'Andrey');
COMMIT;

UPDATE vnd_t SET name = 'Alex' WHERE name = 'Andrey';
COMMIT;

SELECT ID, COUNT(name) FROM vnd_t
WHERE ID < 12
GROUP BY ID;

DELETE FROM vnd_t WHERE ID = 12;
ROLLBACK;

CREATE TABLE VND_t_child (
    person_ID NUMBER(3),
    phone_number VARCHAR2(20),
    CONSTRAINT FK_PersonOrder FOREIGN KEY (person_ID)
    REFERENCES vnd_t(ID)
);

INSERT INTO vnd_t_child VALUES (11, '+375291110202');
INSERT INTO vnd_t_child VALUES (11, '+375441899001');

SELECT vnd_t.ID, VND_t_child.phone_number
FROM vnd_t INNER JOIN vnd_t_child
ON ID = person_ID;

DROP TABLE vnd_t_child;
DROP TABLE vnd_t;
