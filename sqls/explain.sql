  cl scr
  set lines 150;
  set pages 0 embedded on;
--
      EXPLAIN PLAN FOR 
   --> Add your SQL below    

--#- --> End of SQL    
--#-     ;
  SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMs_XPLAN.DISPLAY('PLAN_TABLE',NULL,'typical'))
--SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMs_XPLAN.DISPLAY('PLAN_TABLE',NULL,'typical -cost -bytes'))
--SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMs_XPLAN.DISPLAY(null,NULL,'BASIC'))
  ;
