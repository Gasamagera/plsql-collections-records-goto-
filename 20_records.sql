-- 20_records.sql
SET SERVEROUTPUT ON
DECLARE
-- Table-based record
emp_row employees_demo%ROWTYPE;


-- User-defined record
TYPE t_employee_rec IS RECORD (
emp_id NUMBER,
emp_name VARCHAR2(120),
salary NUMBER,
city VARCHAR2(64)
);
emp t_employee_rec;
BEGIN
-- %ROWTYPE with SELECT ... INTO (primary key fetch)
SELECT * INTO emp_row
FROM employees_demo
WHERE employee_id = (SELECT MIN(employee_id) FROM employees_demo);


DBMS_OUTPUT.PUT_LINE('ROWTYPE -> '||emp_row.first_name||' '||emp_row.last_name||', salary='||emp_row.base_salary);


-- Fill user-defined record from row
emp.emp_id := emp_row.employee_id;
emp.emp_name := emp_row.first_name || ' ' || emp_row.last_name;
emp.salary := emp_row.base_salary;
emp.city := emp_row.city;


DBMS_OUTPUT.PUT_LINE('RECORD -> ID='||emp.emp_id||', '||emp.emp_name||', city='||emp.city||', salary='||emp.salary);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('No employee found.');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error: '||SQLERRM);
END;
/
