----codigo de cabecera
create or replace package DEVUELVEREGISTRO is type tabla_registros is table of PLANTILLA % rowtype index by binary_integer;

                   function  devolvertabla(codigo in number) return tabla_registros;
                   procedure procedimiento_hospital(codigo in number);

END DEVUELVEREGISTRO;--- fin de cabecera DEVUELVEREGISTRO

/

-- codigo Correspodiente al CUERPO del paquete DEVUELVEREGISTRO
create OR replace PACKAGE BODY DEVUELVEREGISTRO is function devolvertabla(codigo in number) return tabla_registros is cursor cursor_plantilla is
                   SELECT A.* 
                   FROM
                       PLANTILLA A,
                       PLANTILLA_SALA S
                   WHERE S.SALA_HOSP_CODIGO = 3 --código del hospital
                   AND A.NIF = S.PLAN_NIF;
mostrar_datos tabla_registros;



begin open cursor_plantilla;
                   loop fetch cursor_plantilla into mostrar_datos(cursor_plantilla % rowcount);
                   exit when cursor_plantilla % notfound;
                   end loop;
close cursor_plantilla;

return mostrar_datos;
END devolvertabla;


procedure procedimiento_hospital(codigo in number) is variable_datos tabla_registros;
                   begin 
                   variable_datos := devolvertabla(codigo);
                   for i in variable_datos.first..variable_datos.last 
                   loop DBMS_OUTPUT.PUT_LINE(variable_datos(i).APELLIDOS || '-' || variable_datos(i).NOMBRE);
                   end loop;
end procedimiento_hospital;

end DEVUELVEREGISTRO;
/