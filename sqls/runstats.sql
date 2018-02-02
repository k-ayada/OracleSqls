--@/home/d_keys/krnydc/s/runstats.sql;
SET LINES 200;
SET PAGES 0 EMBEDDED ON;
SET ECHO     OFF;
SET VERIFY   OFF;
SET TERMOUT  OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
DEFINE OWN = '&&_USER.';
DEFINE TBL = 'ALL';
DEFINE TBS = '????????';
DEFINE RUN_STATS = 'YES';
SPO /home/d_keys/krnydc/test/STATS_INFO_&&TBS.-&&OWN.-&&TBL..csv;
DECLARE
  CURSOR C_TBLS (CP_TBS VARCHAR2, CP_OWN VARCHAR2, CP_TBL VARCHAR2)
  IS SELECT US.TABLESPACE_NAME, DT.OWNER, DT.TABLE_NAME, DT.NUM_ROWS, DT.STATUS, DT.LAST_ANALYZED, SUM(BYTES) AS TBL_SIZE
               FROM DBA_TABLES    DT
                   ,USER_SEGMENTS US
              WHERE US.SEGMENT_NAME     = DT.TABLE_NAME
                AND (US.TABLESPACE_NAME = CP_TBS OR CP_TBS = 'ALL')
                AND (DT.OWNER           = CP_OWN OR CP_OWN = 'ALL')
                AND (DT.TABLE_NAME      = CP_TBL OR CP_TBL = 'ALL')
              GROUP BY US.TABLESPACE_NAME, DT.OWNER, DT.TABLE_NAME,DT.NUM_ROWS, DT.STATUS, DT.LAST_ANALYZED
              ORDER BY TBL_SIZE DESC, TABLE_NAME
  ;
  R_TBL C_TBLS%ROWTYPE;
  BOOL NUMBER(5,0) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE( 'TABLESPACE_NAME,OWNER,TABLE_NAME,old_TBL_SIZE(MBs),new_TBL_SIZE(MBs),' ||
                          'old_STATUS,new_STATUS,old_NUM_ROWS,new_NUM_ROWS,' ||
                          'old_LAST_ANALYZED,new_LAST_ANALYZED,')
    ;
    FOR R_TBLS IN C_TBLS('&&TBS.', '&&OWN.' , '&&TBL.')
    LOOP
         BOOL:= 0;
--      CHECK IF WE NEED TO GATHER THE STATS  AND RUN IT NEEDED.
        IF (R_TBLS.LAST_ANALYZED IS NULL)  THEN
            BOOL := 1;
        ELSE
           SELECT COUNT(DISTINCT OBJNAME) INTO BOOL
             FROM TABLE(STATS_REQUIRED('LIST STALE' ,'&&OWN.')) T
            WHERE T.OBJNAME =  R_TBLS.TABLE_NAME
           ;
        END IF;
        IF (BOOL > 0 AND '&&RUN_STATS.' = 'YES') THEN
            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>R_TBLS.OWNER, TABNAME =>  R_TBLS.TABLE_NAME);
        END IF;
--
---     GET THE NEW VALUES.
--
        SELECT DT.TABLE_NAME   , DT.NUM_ROWS   , DT.STATUS   , SUM(BYTES) AS TBL_SIZE, DT.LAST_ANALYZED
          INTO R_TBL.TABLE_NAME, R_TBL.NUM_ROWS, R_TBL.STATUS, R_TBL.TBL_SIZE        , R_TBL.LAST_ANALYZED
          FROM DBA_TABLES DT
              ,USER_SEGMENTS US
         WHERE US.SEGMENT_NAME    = DT.TABLE_NAME
           AND US.TABLESPACE_NAME = R_TBLS.TABLESPACE_NAME
           AND DT.OWNER           = R_TBLS.OWNER
           AND DT.TABLE_NAME      = R_TBLS.TABLE_NAME
         GROUP BY DT.TABLE_NAME,DT.NUM_ROWS, DT.STATUS,DT.LAST_ANALYZED
        ;
        DBMS_OUTPUT.PUT_LINE( R_TBLS.TABLESPACE_NAME
                 || ',' || R_TBLS.OWNER
                 || ',' || R_TBLS.TABLE_NAME
                 || ',' || to_char((R_TBLS.TBL_SIZE/1024/1024), '999999999.9999')
                 || ',' || to_char((R_TBL.TBL_SIZE /1024/1024), '999999999.9999')
                 || ',' || R_TBLS.STATUS
                 || ',' || R_TBL.STATUS
                 || ',' || R_TBLS.NUM_ROWS
                 || ',' || R_TBL.NUM_ROWS
                 || ',' || R_TBLS.LAST_ANALYZED
                 || ',' || R_TBL.LAST_ANALYZED
                 || ',' )
        ;
    END LOOP;
END;
/
SPO OFF;

