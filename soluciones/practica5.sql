-- Creación de la tabla histo_cambios_departamento
CREATE TABLE HISTO_CAMBIOS_DEPARTAMENTO
(DIAYHORA	DATE,
TEXTO		VARCHAR2(500),
CONSTRAINT pk_histo_cambios_departamento PRIMARY KEY(diayhora));
/

-- Creación del trigger tr_departamento
CREATE OR REPLACE TRIGGER tr_departamento
	BEFORE DELETE OR INSERT OR UPDATE OF codigo ON departamento
	FOR EACH ROW
DECLARE
Contador	NUMBER;
BEGIN
	IF INSERTING THEN
		INSERT INTO histo_cambios_departamento
		VALUES(sysdate,'Se ha insertado una fila con datos: '||TO_CHAR(:new.codigo)||'-'||:new.nombre);
	ELSIF DELETING THEN
		SELECT COUNT(*) INTO contador FROM departamento_empleado
		WHERE dept_codigo = :old.codigo;

		IF contador > 0 THEN
			INSERT INTO histo_cambios_departamento
			VALUES (sysdate,'Se ha intentado borrar el departamento: '||TO_CHAR(:old.codigo));
		ELSE
			INSERT INTO histo_cambios_departamento
			VALUES (sysdate,'Se ha borrado el departamento: '||TO_CHAR(:old.codigo));
		END IF;
	ELSE
		SELECT COUNT(*) INTO contador FROM departamento_empleado
		WHERE dept_codigo = :old.codigo;
		
		IF contador > 0 THEN
			UPDATE departamento_empleado
			SET dept_codigo = :new.codigo
			WHERE dept_codigo = :old.codigo;
		END IF;
		INSERT INTO histo_cambios_departamento
		VALUES (sysdate,'Se ha actualizado el departamento '||TO_CHAR(:old.codigo)||' al valor '||TO_CHAR(:new.codigo));
	END IF;
END;
/
