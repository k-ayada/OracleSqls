CLEAR BREAK;
CLEAR COL;
BREAK ON TABLE_NAME ON UNIQUENESS SKIP 1;
COLUMN COLUMN_EXPRESSION FORMAT A40;
COLUMN TABLE_NAME        FORMAT A30;
COLUMN INDEX_NAME        FORMAT A30;
COLUMN COLUMN_NAME       FORMAT A30;
COLUMN OWNER             FORMAT A10;
SET VERIFY OFF;
SET LINES 150;
SET PAGES 0 EMBEDDED ON;
COLUMN PKN NEW_VALUE PK;
SET HEADING OFF;
PROMPT;
SELECT 'Primary Key details for :' AS TXT , UPPER('&1.') AS PKN FROM DUAL;
PROMPT;
SET HEADING ON;
SELECT CONS.OWNER,
       COLS.TABLE_NAME,
       COLS.COLUMN_NAME,
       COLS.POSITION,
       CONS.STATUS
  FROM ALL_CONSTRAINTS CONS,
       ALL_CONS_COLUMNS COLS
 WHERE COLS.CONSTRAINT_NAME = '&pk'
   AND CONS.CONSTRAINT_TYPE = 'P'
   AND CONS.OWNER           = COLS.OWNER
   AND CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
  ORDER BY COLS.TABLE_NAME, COLS.POSITION;
