ALTER SESSION SET CONTAINER = XEPDB1;

CREATE USER VNDS
    IDENTIFIED BY pass
    ACCOUNT UNLOCK;
    
GRANT
    CREATE SESSION,
    CREATE TABLE
    TO VNDS;
    
SELECT DEFAULT_TABLESPACE FROM DBA_USERS WHERE USERNAME = 'VNDS';

ALTER USER VNDS QUOTA 125M ON USERS;

SELECT OWNER, TABLE_NAME FROM DBA_PART_TABLES;

SELECT PARTITION_NAME, HIGH_VALUE
    FROM DBA_TAB_PARTITIONS
    WHERE TABLE_NAME = 'T_RANGE';
    
SELECT * FROM VNDS.T_RANGE PARTITION (p_range_400);

SELECT * FROM VNDS.T_RANGE PARTITION FOR (300);
    
--DROP USER VNDS CASCADE;