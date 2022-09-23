#!/usr/bin/ksh

# Se invoca al fichero de entorno de la instalación de Oracle en la máquina Unix
. /ruta1/instalaoracle/envfile11

# Se define la conexión a la base de datos
conexion=cursoinap/cursoinap@xe

# Se define un fichero log para enviar los resultados de la ejecución.
ficherolog=/ruta2/logs/RESULTADO_EJECUCION.log

# Se define una variable con contenido de tipo texto
usuario=ANTOLIN

# Se obtiene en una variable de Unix, el resultado de ejecutar una función de SQL
# En este caso se obtiene la fecha del sistema de la b.d. en formato 4 digitos año y 2 mes
fechabd=`sqlplus -s $conexion <<!
WHENEVER SQLERROR EXIT FAILURE
set serveroutput on
set feedback off
set head off
SELECT TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMM')) FROM DUAL;
exit;
!`

#

# Se inicializa el fichero log
echo " " >$ficherolog

# Se imprime un texto en el log con el resultado de la variable anterior
echo "`date +'%d-%m-%Y %H:%M:%S'`: La fecha de la base de datos es: " $conexion >>$ficherolog

# Se ejecuta un paquete de la base de datos definiendo una variable global sobre la que se 
# cargará el resultado de la ejecución del mismo y luego se propagará a la shell de Unix.
# El paquete invocado se llama PAQUETE_PRUEBAS
# El procedimiento dentro del paquete al que se invoca se llama EJECUTA_LISTADO y recibe 2 parámetros
# el primero es de tipo numérico y se le pasa la variable de unix FECHABD y el segundo es de tipo texto
# y se le pasa la variable USUARIO
(
sqlplus -s /nolog <<!
WHENEVER SQLERROR EXIT FAILURE
CONNECT $conexion
SET LINESIZE 70
SET LONG 500
SET SERVEROUTPUT ON
VAR Cod_Ejecucion     NUMBER
DECLARE 
  V_Cod_Ejecucion     NUMBER(2);
BEGIN
  PAQUETE_PRUEBAS.EJECUTA_LISTADO($fechabd,'$usuario');
  :Cod_Ejecucion := V_Cod_Ejecucion;
  
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  
  CASE V_Cod_Ejecucion 
		WHEN 0 THEN NULL;
		ELSE DBMS_OUTPUT.PUT_LINE('Se ha producido un ERROR NO IDENTIFICADO con codigo '||TO_CHAR(V_Cod_Ejecucion)||' en la ejecución del Report Server.');		
  END CASE;
  
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  
END;
/

EXIT :Cod_Ejecucion
!
) >> $ficherolog 2>&1
salidaplus=$?

# Una vez capturado el resultado de la ejecución del paquete en la variable SALIDAPLUS en Unix se evalúa su contenido
if [ $salidaplus -eq 0 ] ; then
   echo "`date +'%d-%m-%Y %H:%M:%S'`: Finalizado llama a WebService satisfactoriamente" >>$ficherolog10
else
   echo "`date +'%d-%m-%Y %H:%M:%S'`: ERROR en llamada a WebService" >>$ficherolog10
fi

echo "`date +'%d-%m-%Y %H:%M:%S'`: Fin de la ejecución de la shell." >>$ficherolog

# Se añaden líneas en blanco al log
printf "\n\n" >>$ficherolog

# Se envía el resultado de la variable salidaplus al exterior (llamada a la shell de unix)
exit $salidaplus

