--  trigger   tr_departamento
create or replace noneditionable trigger tr_departamento
before delete or insert or update of codigo ON departamento
For each row
declare
i number;
begin

-- tabla histo_cambios_departamento
create table histo_cambios_departamento
                   ( diayhora date,
                     texto varchar2(500),
constraint pk_histo_cambios_departamento primary key(diayhora));
/

-- insertar en tabla departamento
if inserting then insert into histo_cambios_departamento values(sysdate,'Se ha insertado una fila con datos: '||to_char(:new.codigo)||'-'||:new.nombre);
elsif deleting then
                   select count(*) into i
                   from departamento_empleado
                   where dept_codigo = :old.codigo; 

if i > 0 then insert into histo_cambios_departamento -- comprobamos el departamento para hacer el borrado
                   values (sysdate,'Se ha intentado borrar el departamento: '||to_char(:old.codigo));

else insert into histo_cambios_departamento values (sysdate,'Se ha borrado el departamento: '||to_char(:old.codigo));
end if;
else
                   select count(*) into i
                   from departamento_empleado
                   where dept_codigo = :old.codigo; 

if i > 0 then --la tabla departamento debe actualizarse
                   update departamento_empleado
                   set dept_codigo = :new.codigo
                   where dept_codigo = :old.codigo;
end if;
--ultimo caso, si existen datos o no, se introducirá registro en la tabla HISTO_CAMBIOS_DEPARTAMENTO
       insert into histo_cambios_departamento values (sysdate,'Se ha actualizado el departamento '||to_char(:old.codigo)||' al valor '||to_char(:new.codigo));
end if;
end;/