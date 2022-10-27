--diseñar proceidmietno que tome como argumento un código de hospital(codigo numerico )


CREATE OR REPLACE PROCEDURE BUSCA_ENFERMOS(codigo IN NUMBER) IS Cuenta NUMBER;
    V_nombre enfermo.nombre%TYPE;
    V_apellidos enfermo.apellidos%TYPE;
BEGIN
    SELECT NOMBRE, APELLIDOS INTO v_nombre, v_apellidos
    FROM ENFERMO, HOSPITAL_ENFERMO
    WHERE HOSP_CODIGO = Codigo
    AND NUMSEGSOCIAL = ENF_NUMSEGSOCIAL;
DBMS_OUTPUT.PUT_LINE('El único enfermo del hospital '||TO_CHAR(CODIGO)||' es
'||v_nombre||','||v_apellidos);

    EXCEPTION
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No hay enfermos en el hospital con código '||TO_CHAR(codigo));
            WHEN TOO_MANY_ROWS THEN 
                                SELECT COUNT(DISTINCT ENF_NUMSEGSOCIAL) INTO cuenta
                                FROM HOSPITAL_ENFERMO
                                WHERE HOSP_CODIGO = codigo;
                            DBMS_OUTPUT.PUT_LINE('El hospital con código '||TO_CHAR(codigo)||' tiene '||TO_CHAR(cuenta)||' enfermos.');
END;


-- Para probar el procedimiento debemos ejecutar las siguienes supuestos

-- solución prueba de evaluación 6(punto2.a)

SET SERVEROUTPUT ON
EXECUTE busca_enfermos(1);-- codigo de hospital =1

-- solución prueba de evaluación 6(punto2.b)
SET SERVEROUTPUT ON
EXECUTE busca_enfermos(6)-- codigo de hospital=6



-- solución prueba de evaluación 6(punto2.c)
SET SERVEROUTPUT ON
EXECUTE busca_enfermos(7)-- codigo de hospital =7
