CREATE OR REPLACE PROCEDURE LOGIT
        (ID         VARCHAR2
        ,STEP       VARCHAR2
        ,MESSAGE    VARCHAR2 )
  IS
    L_TS  TIMESTAMP := SYSTIMESTAMP;
  BEGIN
    INSERT INTO WORK_STG_LOG(ID, STEP, DATE_TIME,MESSAGE)
    VALUES (ID, STEP, L_TS,MESSAGE);
  END LOGIT;
 GRANT ALL ON WORK_STG_LOG TO PUBLIC;
 GRANT ALL ON LOGIT TO PUBLIC;

--COL DATE_TIME FOR A30
--COL MESSAGE   FOR A50
--COL STEP      FOR A05
--&&SCHMA_STAG.logit('ID- 30 chars' ,lpad(to_char(v_step),7,' '), ' Rows Deleted: ' || TO_Char(SQL%ROWCOUNT));

-- SELECT * FROM WORK_STG_LOG WHERE ID = 'JPMRPSW8-CNVYRBAL' ORDER BY DATE_TIME DESC FETCH FIRST 10 ROWS ONLY;
