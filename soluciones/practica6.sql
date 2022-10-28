
create or replace  procedure BUSCA_ENFERMOS(codigo in number) is contador number;
    V_nombre enfermo.nombre%TYPE;
    V_apellidos enfermo.apellidos%TYPE;
  


begin
-- consulta que obtiene el nombre y apellidos
    SELECT NOMBRE, APELLIDOS INTO v_nombre, v_apellidos
    FROM ENFERMO, HOSPITAL_ENFERMO
    WHERE HOSP_CODIGO = Codigo
    AND NUMSEGSOCIAL = ENF_NUMSEGSOCIAL;
    DBMS_OUTPUT.PUT_LINE('El único enfermo del hospital '||TO_CHAR(CODIGO)||' es '||v_nombre||','||v_apellidos);


    EXCEPTION
    --caso no tienen
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No hay enfermos en el hospital con código '||TO_CHAR(codigo));
            
            -- caso para la cuenta de enfermos
            WHEN TOO_MANY_ROWS THEN 
             -- consulta para contar(contador)
                                SELECT COUNT(DISTINCT ENF_NUMSEGSOCIAL) INTO contador
                                FROM HOSPITAL_ENFERMO
                                WHERE HOSP_CODIGO = codigo;
                            DBMS_OUTPUT.PUT_LINE('El hospital con código '||TO_CHAR(codigo)||' tiene '||TO_CHAR(contador)||' enfermos.');
            WHEN OTHERS THEN
                   dbms_output.put_line('Se ha producido un error WHENOTHERS '||SQLCODE);
                   dbms_output.put_line('con el mensaje '||sqlerrm);
 
END;

Para probar la ejecucion del procedimiento y obtener los resultados debemos ejecutar cada una de los siguienes supuestos
-- solución prueba de evaluación 6(punto2.a)

SET SERVEROUTPUT ON
EXECUTE busca_enfermos(1);-- codigo de hospital =1

-- solución prueba de evaluación 6(punto2.b)
SET SERVEROUTPUT ON
EXECUTE busca_enfermos(6)-- codigo de hospital=6

-- solución prueba de evaluación 6(punto2.c)
SET SERVEROUTPUT ON
EXECUTE busca_enfermos(7)-- codigo de hospital =7