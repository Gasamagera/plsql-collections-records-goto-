-- 10_collections.sql
SET SERVEROUTPUT ON
DECLARE
----------------------------------------------------------------
-- Associative Array: map city -> population
----------------------------------------------------------------
TYPE t_population IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
city_population t_population;


----------------------------------------------------------------
-- VARRAY: exactly like the class example (max 5 salaries)
----------------------------------------------------------------
TYPE t_salary_varray IS VARRAY(5) OF NUMBER;
v_salaries t_salary_varray := t_salary_varray(5000, 6000, 7000, 8000, 9000);


----------------------------------------------------------------
-- Nested Table: dynamic list of bonuses, with gaps
----------------------------------------------------------------
TYPE t_bonus_list IS TABLE OF NUMBER;
v_bonuses t_bonus_list := t_bonus_list(200, 300, 400);


total NUMBER := 0;
BEGIN
-- Associative Array usage
city_population('Kigali') := 1200000;
city_population('Musanze') := 450000;
DBMS_OUTPUT.PUT_LINE('Population of Kigali: ' || city_population('Kigali'));


-- VARRAY iteration (dense, 1..COUNT)
DBMS_OUTPUT.PUT_LINE('VARRAY salaries:');
FOR i IN 1..v_salaries.COUNT LOOP
DBMS_OUTPUT.PUT_LINE(' salary['||i||']='||v_salaries(i));
END LOOP;


-- Nested Table with DELETE creates gaps
v_bonuses.DELETE(2); -- remove middle -> creates gap
DBMS_OUTPUT.PUT_LINE('Nested Table bonuses (checking EXISTS due to gaps):');
FOR i IN 1..v_bonuses.LAST LOOP
IF v_bonuses.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(' bonus['||i||']='||v_bonuses(i));
total := total + v_bonuses(i);
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Bonus total: '|| total);
END;
/
