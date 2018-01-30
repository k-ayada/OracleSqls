CREATE OR REPLACE FUNCTION FRM_ZONED(P_VAL IN VARCHAR2, P_DEC IN NUMBER DEFAULT 0)
RETURN NUMBER IS 
  L_ASCII VARCHAR2(50); 
  L_CHAR  VARCHAR2(1);
  L_NUM   NUMBER;
  L_NUM_deD NUMBER;
BEGIN 
   L_ASCII := UPPER(TRIM(P_VAL));
   L_CHAR  := SUBSTR(L_ASCII, -1);    
   CASE                        
   WHEN INSTR('}JKLMNOPQR-', L_CHAR) > 0 THEN 
        L_ASCII := TRANSLATE(L_ASCII, '}JKLMNOPQR-','0123456789');       
        L_NUM   := TO_NUMBER(L_ASCII) * -1;
   ELSE 
        L_ASCII := TRANSLATE(L_ASCII, '{ABCDEFGHI+','0123456789');       
        L_NUM   := TO_NUMBER(L_ASCII);
   END CASE; 
   IF P_DEC = 0 THEN 
      RETURN L_NUM; 
   END IF; 
   RETURN (L_NUM / POWER(10,P_DEC) ) ;
EXCEPTION 
   WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('FRM_ZONED-Err : ' || SQLERRM) 
   ;
END FRM_ZONED;
/   


-- select FRM_ZONED('1232{', 2) as "123.20" from dual;
-- select FRM_ZONED('1232{', 0) as "12320" from dual;
