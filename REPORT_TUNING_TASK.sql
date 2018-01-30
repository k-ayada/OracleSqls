DECLARE
  MY_SQLTEXT CLOB;
  TASK_NAME VARCHAR2(30);
BEGIN
  MY_SQLTEXT := 'SQL to be tuned ';
  TASK_NAME := DBMS_SQLTUNE.CREATE_TUNING_TASK( SQL_TEXT => MY_SQLTEXT,
                                   BIND_LIST => SQL_BINDS(ANYDATA.CONVERTNUMBER(100)),
                                   USER_NAME => 'DABR',
                                   SCOPE => 'COMPREHENSIVE',
                                   TIME_LIMIT => 60,
                                   TASK_NAME => 'SQL_TUNING_TASK1');
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK ('SQL_TUNING_TASK1');
END;
/
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK('SQL_TUNING_TASK1') FROM DUAL;
