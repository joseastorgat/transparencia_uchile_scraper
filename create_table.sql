create database transparencia_uchile;


CREATE TABLE Unidad (
	codigo smallint primary key,
	nombre varchar(255),
	sigla varchar(20)
);


CREATE TABLE Personas (
	apellido_paterno varchar (255),
	apellido_materno varchar (255),
	nombres varchar (255),
	primary key(nombres, apellido_paterno, apellido_materno)
);

CREATE TABLE Sueldo (
	anho smallint,
	mes varchar(10),
	contrato varchar(255),
	estamento varchar(255),
	apellido_paterno varchar(255),
	apellido_materno varchar(255),
	nombres varchar(255),
	grado smallint,
	calificacion_profesional_formacion varchar(255),
	cargo_o_funcion varchar(255),
	A_asignaciones_especiales int,
	B_remuneracion_bruta int, 
	C_horas_extras_diurnas int,
	D_horas_extras_nocturnas int,
	fecha_inicio varchar(255),
	fecha_termino varchar(255),
	codigo_unidad  smallint,
	-- primary key(nombres, apellido_paterno, apellido_materno, anho, mes, contrato, grado, cargo_o_funcion),
	foreign key(nombres, apellido_paterno, apellido_materno) references Personas(nombres, apellido_paterno, apellido_materno),
	foreign key(codigo_unidad) references Unidad(codigo)
);



CREATE TABLE Honorarios (
	contrato varchar(20),
	anho smallint,
	mes varchar(10),
	apellido_paterno varchar(255),
	apellido_materno varchar(255),
	nombres varchar(255),
	descripcion_funcion varchar(3000),
	calificacion_profesional_formacion varchar(255),
	honorario_total_bruto int,
	pago_mensual varchar(2),
	n_cuotas smallint,
	fecha_inicio varchar(255),
	fecha_termino varchar(255),
	codigo_unidad  smallint -- ,
	-- primary key(nombres, apellido_paterno, apellido_materno, anho, mes, descripcion_funcion, fecha_inicio, fecha_termino)
);


copy Unidad FROM '/transparencia/datos_limpios/unidad.tsv' DELIMITER E'\t';
copy Personas FROM '/transparencia/datos_limpios/personal.tsv' DELIMITER E'\t';
copy Sueldo FROM '/transparencia/datos_limpios/sueldos.tsv' DELIMITER E'\t';
copy Honorarios FROM '/transparencia/datos_limpios/honorarios.tsv' DELIMITER E'\t';
