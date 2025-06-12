SET ECHO ON;
SET SERVEROUTPUT ON;
spool BTR_history_data_update_292020.log

DECLARE
  c_limit PLS_INTEGER := 10000;

  TYPE t_session_id IS TABLE OF btr_history_summary.session_nmbr%TYPE;

  l_session_id t_session_id;
  cursor btr_updt is
    select distinct (b.session_nmbr)
  from btr_history_summary_extn_1 a, btr_history_summary b
 where a.session_nmbr = b.session_nmbr
   and b.source_system <> 'BAI2'
   and (a.type78_amnt <> a.type65_amnt OR a.type68_amnt <> a.type379_amnt)
   and (a.type65_amnt <> 0 OR a.type379_amnt <> 0);
BEGIN

  OPEN btr_updt;

  LOOP
    FETCH btr_updt BULK COLLECT
      INTO l_session_id LIMIT c_limit;
  
    FORALL indx IN 1 .. l_session_id.COUNT()
    
      UPDATE btr_history_summary_extn_1
         SET type78_amnt = type65_amnt, type68_amnt = type379_amnt
       WHERE session_nmbr = l_session_id(indx);
  
    COMMIT;
  
    EXIT WHEN btr_updt%Notfound;
  
  END LOOP;

  IF btr_updt%ISOPEN THEN
    CLOSE btr_updt;
  END IF;
  
  dbms_output.put_line('BTR history data updated sucessfully' );

EXCEPTION
  WHEN OTHERS THEN
    IF btr_updt%ISOPEN THEN
      CLOSE btr_updt;
    END IF;
    dbms_output.put_line('Error while processing the update ' || sqlcode || ' ' ||
                         sqlerrm);
    ROLLBACK;
  
End;
/
show error;