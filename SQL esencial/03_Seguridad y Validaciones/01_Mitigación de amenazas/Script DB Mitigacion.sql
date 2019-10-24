use master
go
if(DB_ID('Mitigacion')is not null)
drop DataBase Mitigacion
create DataBase Mitigacion
go

use Mitigacion
go

create table Alumno
(IdAlumno int identity(10,1) primary key,
Dni char(8) not null,
Apellidos varchar(30) not null,
Nombres varchar(30) not null,
Sexo char(1) check(Sexo in('M','F')) not null,
FechaNac date not null,
Direccion varchar(50) not null
)
go

insert Alumno values('12345678','Rodriguez Ancajima','Pncho','M','23/05/1998','Av. Los Incas - La Victoria')
insert Alumno values('87654321','Silva Ramos','Ana Esther','F','21/09/1994','Urb. Los Ficus - Pimentel')
go

select * from Alumno
go
--CREAR PROCEDIMIENTOS ALMACENADOS QUE PERMITAN REALIZAR UN LISTADO DE ALUMNOS, CON SU RESPECTIVA EDAD
Create Proc ListarALumnos
as begin
	select *,Edad=DATEDIFF(yy,FechaNac,GETDATE()) from Alumno
   end
go

--CREAR UN SP QUE PERMITA REGISTRAR ALUMNOS
Create Proc RegistrarAlumnos
@Dni char(8),
@Apellidos varchar(30),
@Nombres varchar(30),
@Sexo char(1),
@FechaNac date,
@Direccion varchar(50),
@Mensaje varchar(100) out
as begin
	if(exists(select * from Alumno where Dni=@Dni))
	set @Mensaje='Alumnos ya está Registrado.'
	else begin
	 insert Alumno values(@Dni,@Apellidos,@Nombres,@Sexo,@FechaNac,@Direccion)
	 set @Mensaje='Registrado Correctamente.'
	 end
   end
go
declare @Mensaje varchar(100)
exec RegistrarAlumnos '98576584','Cornejo Silva','Raymunda','F','04/08/1996','Calle Manual María Izaga N° 463 - Chiclayo',@Mensaje out
select @Mensaje
go

--CREAR UN SP QUE PERMITA ACTUALIZAR
Create Proc ActualizarDatos
@Dni char(8),
@Apellidos varchar(30),
@Nombres varchar(30),
@Sexo char(1),
@FechaNac date,
@Direccion varchar(50),
@Mensaje varchar(100) out
as begin
	if(not exists(select * from Alumno where Dni=@Dni))
	set @Mensaje='El DNI del Alumno no existe'
	else begin
	 update Alumno set Apellidos=@Apellidos, Nombres=@Nombres,Sexo=@Sexo,FechaNac=@FechaNac,Direccion=@Direccion where Dni=@Dni
	 set @Mensaje='Datos Acitualizados Correctamente.'
     end
  end
go


--CREAR UN SP QUE PERMITA ELIMINAR ALUMNOS
Create Proc EliminarAlumnos
@Dni char(8),
@Mensaje varchar(100) out
as begin
	if(not exists(select * from Alumno where Dni=@Dni))
	set @Mensaje='Dni del Alumno no se Encuentra Disponible, o no Existe.'
	else begin
	 delete from Alumno where Dni=@Dni
	 set @Mensaje='Registro Eliminado Satisfactoriamente.'
	 end
  end
go


--CREAR UN SP QUE PERMITA BUSCAR ALUMNOS
Create Proc BuscarAlumnos
@Dni char(8)
as begin
 select * from Alumno where Dni=@Dni
 end
go