cl scr
col OWNER       for a10
col table_name  for a30
col column_name for a30
col DataType    for a20
col COMMENTS    for a100 WORD_WRAPPED
set linesize 200
set termout off;
set pagesize 0 embedded on;
SPO col_xRef.txt;
SELECT  trim(ALL_TAB_COLUMNS.TABLE_NAME)  as table_name
       ,trim(ALL_TAB_COLUMNS.COLUMN_NAME) as column_name
       ,trim(ALL_TAB_COLUMNS.DATA_TYPE ||
        CASE WHEN ALL_TAB_COLUMNS.DATA_TYPE = 'NUMBER' AND
                  ALL_TAB_COLUMNS.DATA_PRECISION IS NOT NULL
                  THEN '(' || ALL_TAB_COLUMNS.DATA_PRECISION || ',' || ALL_TAB_COLUMNS.DATA_SCALE || ')'
             WHEN ALL_TAB_COLUMNS.DATA_TYPE LIKE '%CHAR%' THEN '(' || ALL_TAB_COLUMNS.DATA_LENGTH || ')'
             ELSE NULL
        END)  as DataType
       ,trim(ALL_TAB_COLUMNS.NULLABLE)  as "nullable?"
       ,trim(ALL_TAB_COLUMNS.OWNER)  as OWNER
       ,replace(replace(trim('"' || NVL(ALL_COL_COMMENTS.COMMENTS,'(null)') 
                                 || '"'), chr(10), ' '), chr(13), ' ') AS COMMENTS
   FROM ALL_TAB_COLUMNS
       ,ALL_COL_COMMENTS
   WHERE ALL_TAB_COLUMNS.OWNER IN ('?????schema_list?????')
     AND ALL_TAB_COLUMNS.OWNER       = ALL_COL_COMMENTS.OWNER
     AND ALL_TAB_COLUMNS.TABLE_NAME  = ALL_COL_COMMENTS.TABLE_NAME
     AND ALL_TAB_COLUMNS.COLUMN_NAME = ALL_COL_COMMENTS.COLUMN_NAME
   order by OWNER, table_name,column_name;
spo off;   
