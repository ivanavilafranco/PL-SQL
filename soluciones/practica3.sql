SET SERVEROUTPUT ON;

DECLARE
    v_nombre_departamento departamento.nombre%TYPE;
    v_codigo              departamento.codigo%TYPE;
    v_nombre              VARCHAR2(100);
    cuenta            NUMBER := 0;
   
   
    CURSOR cursor_deptart ( v_codigo departamento_empleado.dept_codigo%TYPE ) IS
                   SELECT nombre FROM departamento_empleado, empleado WHERE dept_codigo = v_codigo AND nif = emp_nif;

    CURSOR cursor_deptart_nom (v_codigo departamento_empleado.dept_codigo%TYPE) IS
                    SELECT nombre FROM departamento WHERE codigo = v_codigo; 

    TYPE t_nombre IS
                    TABLE OF empleado.nombre%TYPE INDEX BY BINARY_INTEGER;

                    v_tabla          t_nombre;

BEGIN
---- primera parte del ejercicio
/*
  FOR i IN 1..6
  LOOP
    IF i != 4 THEN --> no inserción en tabla
      INSERT INTO departamento_empleado VALUES
                  (
                              i,
                              '10000000A'
                  );
    
    END IF;
  END LOOP;
  
  COMMIT;
*/


    v_codigo := '&Indique_codigo_departamento';
    
    OPEN cursor_deptart_nom(v_codigo);
    FETCH cursor_deptart_nom INTO v_nombre_departamento;
    OPEN cursor_deptart(v_codigo);
    LOOP
        FETCH cursor_deptart INTO v_nombre;
        EXIT WHEN cursor_deptart%notfound;
        cuenta := cuenta + 1;
        v_tabla(cuenta) := v_nombre;
    END LOOP;





    IF cursor_deptart%rowcount < 1 THEN
        dbms_output.put_line(chr(10) || 'No se recuperó ningún empleado en el departamento con código ' || v_nombre_departamento);
    ELSE 
        dbms_output.put_line(chr(10) || 'Se han encontrado ' || cursor_deptart%rowcount || ' empleados pertenecientes al departamento ' || v_nombre_departamento);
        dbms_output.put_line(chr(10) || 'Relación de empleados del departamento ' || v_nombre_departamento);
        dbms_output.put_line('-------------------------------------------------------');


        FOR j IN 1..cuenta LOOP
            dbms_output.put_line(v_tabla(j));
        END LOOP;

    END IF;

 dbms_output.put_line(chr(10));
    
	
	
	FOR l IN v_tabla.first..v_tabla.last 
    LOOP
        IF v_tabla.EXISTS(l) THEN
            UPDATE empleado SET
                salario = 0,
                comision = 0
            WHERE nombre = v_tabla(l);

            UPDATE plantilla SET
                salario = 0
            WHERE nombre = v_tabla(l);

            IF SQL%notfound THEN
                dbms_output.put_line(chr(10) || 'No se encontraron empleados sanitarios con el nombre de ' || v_tabla(l));
            ELSE
                dbms_output.put_line(chr(10) || 'Se han actualizado ' || SQL%rowcount || ' empleados sanitarios con el nombre de ' || v_tabla(l));
            END IF;

        END IF;
    END LOOP;

    ROLLBACK;
	
    CLOSE cursor_deptart_nom;
    CLOSE cursor_deptart;
END;
/ 

