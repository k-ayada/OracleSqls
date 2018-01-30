DROP  TYPE TYP_TAB_BT_TEXT
/
DROP  TYPE TYP_ROW_BT_TEXT
/
CREATE OR REPLACE TYPE TYP_ROW_BT_TEXT AS OBJECT
( COL_1   VARCHAR2(13)
 ,COL_2   VARCHAR2(9)
 ,COL_3   VARCHAR2(40)
);
/
CREATE OR REPLACE TYPE TYP_TAB_BT_TEXT IS TABLE OF TYP_ROW_BT_TEXT;
/
CREATE OR REPLACE FUNCTION PIPE_FUNC_BT (
  aTABLE        VARCHAR2
 ,aWHERE_CLAUSE VARCHAR2 := NULL
)
RETURN TYP_TAB_BT_TEXT PIPELINED AS
  type type_record is record (
       COL_1   VARCHAR2(13)
      ,COL_2    VARCHAR2(9)
      ,COL_3   VARCHAR2(40)
  );
  vROW    type_record;
  CUR_BT  SYS_REFCURSOR;
  vSQLSTR VARCHAR2(1000);
  vWHERE  VARCHAR2(1000);
  BEGIN
       vSQLSTR := 'SELECT COL_1, SS, COL_3  FROM ' || aTABLE ;
       IF aWHERE_CLAUSE IS NOT NULL THEN
          vWHERE  :=  REPLACE(aWHERE_CLAUSE, '`', '''');
          vSQLSTR :=  vSQLSTR || ' WHERE ' || vWHERE;
       END IF;
       OPEN CUR_BT FOR vSQLSTR;
       LOOP
           FETCH CUR_BT INTO vROW;
           EXIT WHEN CUR_BT%NOTFOUND;
           PIPE ROW (TYP_ROW_BT_TEXT(vROW.COL_1, vROW.COL_2, vROW.COL_3));
       END LOOP;
       CLOSE CUR_BT;
       RETURN;
  END;
/
--  SELECT *
--    FROM table(PIPE_FUNC_BT('schema.aTABLE','COL_1 IS NOT NULL')) BT_1