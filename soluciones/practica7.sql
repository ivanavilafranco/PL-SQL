-- procedimiento para procedimiento que sea capaz mediante un cursor del tipo FOR UPDATE, de actualizar única y exclusivamente el campo SALARIO...
CREATE OR REPLACE PROCEDURE actualiza_salarios IS
    v_max plantilla.salario%TYPE;

CURSOR cursor_for IS 
    SELECT * FROM plantilla 
    WHERE EXISTS
            (SELECT NULL FROM doctor 
            WHERE doctor.nif = plantilla.nif 
            AND doctor.especialidad = plantilla.funcion) 
  
FOR UPDATE OF salario;

BEGIN 

    FOR v_doctor IN cursor_for LOOP 
         begin
            SELECT max(salario) INTO v_max FROM plantilla; -- seleccionamos el salario maximo que existe en la plantilla
                   UPDATE plantilla SET   -- actualizamos
                   salario = v_max 
                   WHERE CURRENT OF cursor_for; 
            
         EXCEPTION
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No se puede actualizar el salario');
            WHEN OTHERS THEN
                 dbms_output.put_line('código del error WHENOTHERS '||SQLCODE);
                 dbms_output.put_line('texto del error '||sqlerrm);
        END;
    END LOOP; 
COMMIT; 
END actualiza_salarios;


--Ejecutar la consulta que nos muestre el nombre y salario de todos los doctores de la tabla plantilla 
--(comparándolos con la tabla doctores) y observar el salario de todos ellos antes de actualizarlo. 

--Paso 1 ejecutamos la consulta
            SELECT NOMBRE, SALARIO FROM plantilla
            WHERE EXISTS (SELECT NULL FROM DOCTOR
            WHERE DOCTOR.NIF = PLANTILLA.NIF
            AND DOCTOR.ESPECIALIDAD =PLANTILLA.FUNCION);
--paso 2 ejecutamos el procedimiento actualiza_salarios
            SET SERVEROUTPUT ON
            EXECUTE actualiza_salarios;
--paso 3 ejecutamos de nuevo la consulta y comprobamos que se ha modificado el salario.

           SELECT NOMBRE, SALARIO FROM plantilla
            WHERE EXISTS (SELECT NULL FROM DOCTOR
            WHERE DOCTOR.NIF = PLANTILLA.NIF
            AND DOCTOR.ESPECIALIDAD =PLANTILLA.FUNCION);
            
            
            



