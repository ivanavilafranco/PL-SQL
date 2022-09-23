-- Antes de ejecutar el c�digo hay que crear una carpeta en Windows en la unidad C: con el nombre CursoPL_INAP

-- Conexi�n con el usuario SYS para poder crear un objeto directorio y asociar permisos al usuario CURSOINAP
CONNECT SYS/CURSOINAP AS SYSDBA;
-- Creaci�n del objeto directorio C:\CursoPL_INAP
-- Para poder manejar archivos en una ruta (sea de Windows, Linux o Unix), hay que crear un objeto directorio que apunte a dicha ruta.
CREATE DIRECTORY CURSOPLSQL AS 'C:\CursoPL_INAP';
-- Se asocia permisos para crear directorios al usuario CURSOINAP
GRANT CREATE ANY DIRECTORY TO CURSOINAP;
-- Se asocia permisos de lectura sobre el objeto directorio creado anteriormente al usuario CURSOINAP
GRANT READ ON DIRECTORY CURSOPLSQL TO CURSOINAP;
-- Se asocia permisos de escritura sobre el objeto directorio creado anteriormente al usuario CURSOINAP
GRANT WRITE ON DIRECTORY CURSOPLSQL TO CURSOINAP;
-- Se asocia permisos de ejecuci�n sobre el paquete UTL_FILE al usuario CURSOINAP
GRANT EXECUTE ON SYS.UTL_FILE TO CURSOINAP;

-- Conexi�n con el usuario CURSOINAP
CONNECT CURSOINAP/CURSOINAP;

-- Habilitar salida de resultados por pantalla
SET SERVEROUTPUT ON;

-- Creaci�n del procedimiento ESCRIBIR_FILE
-- Este procedimiento crea un archivo dentro del objeto directorio CURSOPLSQL con el nombre prueba.txt. F�sicamente este archivo se encontrar� en la carpeta de Windows C:\CursoPL_INAP
CREATE OR REPLACE PROCEDURE ESCRIBIR_FILE IS
  CADENA  VARCHAR2(32767);
  FILE    UTL_FILE.FILE_TYPE;
 
BEGIN
 
  -- En este ejemplo escribo una cadena de caracteres en el fichero prueba.txt
   
  -- Cadena a escribir
  cadena := 'Prueba de escritura en fichero usando el paquete utl_file';
   
  -- Abro fichero para escritura  (Write)
  file := UTL_FILE.FOPEN('CURSOPLSQL','prueba.txt','W',256);
   
  -- Escribo en el fichero
  UTL_FILE.PUT(file,cadena);
   
  -- Cierro fichero
  UTL_FILE.FCLOSE(file);
   
  dbms_output.put_line('Escritura correcta');
 
END;
/

-- Ejecuci�n del Procedimiento ESCRIBIR_FILE
EXECUTE ESCRIBIR_FILE;
-- Despu�s de ejecutar esta instrucci�n se consultar� el directorio C:\CursoPL_INAP para comprobar que existe el fichero prueba.txt y que tiene contenido.

-- Creaci�n del procedimiento ANADIR_FILE
-- Este procedimiento a�ade una nueva l�nea al fichero prueba.txt creado anteriormente
CREATE OR REPLACE PROCEDURE anadir_file IS
  CADENA  VARCHAR2(32767);
  FILE    UTL_FILE.FILE_TYPE;

BEGIN
 
  -- En este ejemplo a�ado una cadena de caracteres al fichero prueba.txt
   
  -- Cadena a escribir
  cadena := 'Linea a�adida a un fichero usando el paquete utl_file';
   
  -- Abro fichero para a�adir (Append)
  file := UTL_FILE.FOPEN('CURSOPLSQL','prueba.txt','A',256);
   
  -- Escribo en el fichero
  UTL_FILE.PUT(file,cadena);
   
  -- Cierro fichero
  UTL_FILE.FCLOSE(file);
   
  dbms_output.put_line('Escritura correcta, informaci�n a�adida');
 
END;
/

-- Ejecuci�n del Procedimiento ANADIR_FILE
EXECUTE ANADIR_FILE;
-- Despu�s de ejecutar esta instrucci�n se consultar� el directorio C:\CursoPL_INAP para comprobar que se ha a�adido la nueva l�nea al fichero prueba.txt

-- Creaci�n del procedimiento LEER_FILE
-- Este procedimiento lee el contenido del fichero prueba.txt almacenado en el objeto directorio CURSOPLSQL correspondiente a la ruta f�sica C:\CursoPL_INAP
CREATE OR REPLACE PROCEDURE leer_file IS
  CADENA VARCHAR2(32767);
  Vfile UTL_FILE.FILE_TYPE;
 
BEGIN
  -- En este ejemplo leo una linea del fichero prueba.txt
   
  -- Abro fichero en lectura (Read)
  Vfile := UTL_FILE.FOPEN('CURSOPLSQL','prueba.txt','R',256);
   
  -- Leo del fichero
  UTL_FILE.GET_LINE(Vfile,cadena,32767);
  
  -- Muestro por partalla la linea
  dbms_output.put_line(cadena);
   
  -- Cierro fichero
  UTL_FILE.FCLOSE(Vfile);
   
END;
/

-- Ejecuci�n del procedimiento LEER_FILE activando previamente la salida por pantalla de resultados
SET SERVEROUTPUT ON;
EXECUTE LEER_FILE;


-- Creaci�n del procedimiento CAMBIO_NOMBRE_FILE
-- Este procedimiento renombra el archivo prueba.txt con el nombre que se indique por par�metro en la llamada al procedimiento.
CREATE OR REPLACE PROCEDURE cambio_nombre_file(p_nombre_nuevo IN VARCHAR2) IS
  CADENA VARCHAR2(32767);
  Vfile UTL_FILE.FILE_TYPE;
 
BEGIN
  -- En este ejemplo renombro el fichero prueba.txt
   
  -- Renombro el fichero
  UTL_FILE.FRENAME('CURSOPLSQL','prueba.txt','CURSOPLSQL',p_nombre_nuevo,TRUE);
   
  -- Muestro por partalla el resultado
  dbms_output.put_line('Renombrado el fichero correctamente');
 
END;
/

-- Ejecuci�n del procedimiento CAMBIO_NOMBRE_FILE
EXECUTE CAMBIO_NOMBRE_FILE('prueba_renombrado.txt');
-- Despu�s de ejecutarlo comprobaremos en la ruta C:\CursoPL_INAP que el fichero prueba.txt ahora se llama prueba_renombrado.txt

