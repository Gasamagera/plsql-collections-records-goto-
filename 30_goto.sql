-- 30_goto.sql
SET SERVEROUTPUT ON
DECLARE
v_attempts PLS_INTEGER := 0;
v_max_attempts CONSTANT PLS_INTEGER := 3;
v_status VARCHAR2(20);
BEGIN
v_status := 'START';


<<retry_check>>
v_attempts := v_attempts + 1;
DBMS_OUTPUT.PUT_LINE('Attempt #'||v_attempts||' status='||v_status);


-- Simulate a condition that needs skipping: after first attempt, skip work
IF v_attempts = 1 THEN
v_status := 'SKIP_THIS_TIME';
GOTO skip_work; -- demonstrate jump
END IF;


DBMS_OUTPUT.PUT_LINE('Doing important work (only after first skip)...');


GOTO finished;


<<skip_work>>
DBMS_OUTPUT.PUT_LINE('Skipped work on first attempt.');
IF v_attempts < v_max_attempts THEN
GOTO retry_check; -- try again, now the IF won''t trigger
END IF;


<<finished>>
DBMS_OUTPUT.PUT_LINE('Done. Attempts='||v_attempts||', final status='||v_status);
END;
/
