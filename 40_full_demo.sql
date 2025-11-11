-- 40_full_demo.sql
----------------------------------------------------------------
TYPE t_city_allowance IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
city_allow t_city_allowance;


----------------------------------------------------------------
-- Monthly adjustments (fixed upper bound): VARRAY
----------------------------------------------------------------
TYPE t_adjustments IS VARRAY(5) OF NUMBER; -- e.g., transport, lunch, overtime cap, ...
v_adj t_adjustments := t_adjustments(150, 200, 100); -- 3 used, room up to 5


----------------------------------------------------------------
-- Penalties per employee: Nested Table (may have gaps after DELETE)
----------------------------------------------------------------
TYPE t_penalties IS TABLE OF NUMBER;


----------------------------------------------------------------
-- Records
----------------------------------------------------------------
emp_row employees_demo%ROWTYPE; -- table-based record
TYPE t_emp_out IS RECORD (
emp_id NUMBER,
full_nm VARCHAR2(120),
city VARCHAR2(64),
payable NUMBER
);
out_rec t_emp_out;


----------------------------------------------------------------
-- Cursor over all employees (ordered for deterministic output)
----------------------------------------------------------------
CURSOR c_emp IS
SELECT * FROM employees_demo ORDER BY employee_id;


v_total NUMBER;
v_pen t_penalties;
BEGIN
-- Seed city allowances
city_allow('Kigali') := 300;
city_allow('Musanze') := 150;
city_allow('Huye') := 200;


OPEN c_emp;
LOOP
FETCH c_emp INTO emp_row;
EXIT WHEN c_emp%NOTFOUND;


-- Skip TERMINATED employees using GOTO to a label
IF emp_row.status = 'TERMINATED' THEN
GOTO skip_employee;
END IF;


-- Build penalties list (example: late = 50, safety = 20) then delete one to show gaps
v_pen := t_penalties(50, 20, 10);
v_pen.DELETE(2);


-- Compute payable: base + sum(adjustments) + allowance(city) - sum(penalties)
v_total := NVL(emp_row.base_salary, 0);


-- Sum VARRAY adjustments
FOR i IN 1..v_adj.COUNT LOOP
v_total := v_total + v_adj(i);
END LOOP;


-- City allowance via associative array
IF city_allow.EXISTS(emp_row.city) THEN
v_total := v_total + city_allow(emp_row.city);
END IF;


-- Subtract penalties (ne
