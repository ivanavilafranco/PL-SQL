
SET SERVEROUTPUT ON

DECLARE

	 TYPE registro IS RECORD (
 		NOMBRE_DEPARTAMENTO DEPARTAMENTO.NOMBRE%TYPE,
  		N_EMPLEADO NUMBER(5),
  		TIPO_OCUPACION VARCHAR2(20));
  
  		V_registro registro;

	TYPE tabla_registro_departamento IS
	TABLE  OF registro INDEX BY BINARY_INTEGER;

      	v_tabla_departamento tabla_registro_departamento;

BEGIN

        SELECT 
		D.NOMBRE, 
		COUNT(E.EMP_NIF)
	INTO
		v_tabla_departamento(1).NOMBRE_DEPARTAMENTO,
		v_tabla_departamento(1).N_EMPLEADO

        FROM 
		DEPARTAMENTO D, 
		DEPARTAMENTO_EMPLEADO E
        WHERE 
		UPPER(D.NOMBRE) = UPPER('&Indique_departamento')
       		AND E.DEPT_CODIGO = D.CODIGO
        GROUP BY D.NOMBRE;
        

          IF v_tabla_departamento(1).N_EMPLEADO < 10 THEN
                          v_tabla_departamento(1).TIPO_OCUPACION :='BAJA';

          ELSIF v_tabla_departamento(1).N_EMPLEADO BETWEEN 10 AND 19 THEN
                           v_tabla_departamento(1).TIPO_OCUPACION :='MEDIA';

          ELSE
                           v_tabla_departamento(1).TIPO_OCUPACION :='ALTA';
          END IF;
                
     
     DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(10)||'Datos de ocupación del departamento:'||v_tabla_departamento(1).NOMBRE_DEPARTAMENTO);
     DBMS_OUTPUT.PUT_LINE ('-------------------------------------------------------------'||CHR(10));
     DBMS_OUTPUT.PUT_LINE('Ocupación actual (Tipo/nº empleados):'||v_tabla_departamento(1).TIPO_OCUPACION||'/'||v_tabla_departamento(1).N_EMPLEADO);
     
END;
/