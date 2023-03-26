--env | grep ORACLE_HOME
--/opt/oracle/dbs

SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME = 'open_cursors';

CREATE PFILE = 'VND_PFILE.ora' FROM SPFILE;

--docker exec -t -i oracledb /bin/bash

--docker exec -it oracledb sqlplus / as sysdba

--CREATE SPFILE FROM PFILE = 'VND_PFILE.ora';

SHOW PARAMETER OPEN_CURSORS;

ALTER SYSTEM SET OPEN_CURSORS = 300;

SHOW PARAMETER OPEN_CURSORS;

SHOW PARAMETER CONTROL_FILES;

--9?

SELECT * FROM V$PASSWORDFILE_INFO;

--/opt/oracle/diag

SELECT MESSAGE_TEXT FROM X$DBGALERTEXT WHERE MESSAGE_TEXT LIKE '%Current log%';

--http://www.rebellionrider.com/how-to-read-control-file-in-oracle-database/    