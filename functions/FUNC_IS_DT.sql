CREATE or replace FUNCTION is_dt (p_date IN VARCHAR2, p_format IN VARCHAR2 )
RETURN VARCHAR2 IS
  L_DT DATE;
BEGIN
    L_DT := TO_DATE(p_date, p_format );
    RETURN 'Y';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'N';
END is_dt;

--select is_dt('01011990','dd-mm-yyyy') as dt from dual;
