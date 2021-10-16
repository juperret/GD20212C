/*******************
*** BASE DE DATOS **
********************/
USE GD2C2021;
GO

/************************
*** CREACION DE SCHEMA **
*************************/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MONKEY_D_BASE')
    EXEC ('CREATE SCHEMA MONKEY_D_BASE');
GO

/************************
*** DROPEO DE OBJETOS ***
*************************/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Orden_Tarea') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Orden_Tarea
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Orden_Trabajo') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Orden_Trabajo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Estado_OT') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Estado_OT
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Tarea_Material') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Tarea_Material
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Material') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Material
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Tarea') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Tarea
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Tarea_Tipo') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Tarea_Tipo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Taller') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Taller
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Viaje_Paquete') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Viaje_Paquete
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Paquete_Tipo') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Paquete_tipo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Viaje') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Viaje
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Empleado') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Empleado
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Empleado_Tipo') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Empleado_Tipo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Camion') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Camion
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Camion_Modelo') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Camion_Modelo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Marca') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Marca
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('MONKEY_D_BASE.Recorrido') and type = 'U')
	DROP TABLE MONKEY_D_BASE.Recorrido
GO

/************************
*** CRECION DE TABLAS ***
*************************/
CREATE TABLE MONKEY_D_BASE.Recorrido (
	id				INT IDENTITY PRIMARY KEY,
	ciudad_origen	NVARCHAR(255)	NOT NULL,
	ciudad_destino	NVARCHAR(255)	NOT NULL,
	precio			DECIMAL(18,2)	NOT NULL,
	kms				INT		NOT NULL)

CREATE TABLE MONKEY_D_BASE.Paquete_Tipo (		
	id				INT IDENTITY PRIMARY KEY,
	descripcion		NVARCHAR(255) NOT NULL,
	peso_max		DECIMAL(18,2) NOT NULL,
	alto_max		DECIMAL(18,2) NOT NULL,
	ancho_max		DECIMAL(18,2) NOT NULL,
	largo_max		DECIMAL(18,2) NOT NULL,
	precio			DECIMAL(18,2) NOT NULL	) 
									
CREATE TABLE MONKEY_D_BASE.Marca (
	id				INT IDENTITY PRIMARY KEY,
	descripcion		NVARCHAR(255) NOT NULL UNIQUE)

CREATE TABLE MONKEY_D_BASE.Camion_Modelo (
	id					INT IDENTITY PRIMARY KEY,
	descripcion			NVARCHAR(255)	NOT NULL,
	capacidad_tanque	INT		NOT NULL,
	capacidad_carga		INT		NOT NULL,
	velocidad_max		INT		NOT NULL,
	marca_id			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Marca(id) )

CREATE TABLE MONKEY_D_BASE.Camion (
	id			INT IDENTITY PRIMARY KEY,
	nro_chasis	NVARCHAR(255)	NOT NULL,
	nro_motor	NVARCHAR(255)	NOT NULL,
	fecha_alta	Datetime2	NOT NULL,
	patente		NVARCHAR(255)	NOT NULL,
	modelo_id	INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Camion_Modelo(id) )

CREATE TABLE MONKEY_D_BASE.Empleado_Tipo (
	id					INT IDENTITY PRIMARY KEY,
	tipo_descripcion	NVARCHAR(255) NOT NULL	)

CREATE TABLE MONKEY_D_BASE.Empleado (
	legajo				INT IDENTITY PRIMARY KEY,
	nombre				NVARCHAR(255)	NOT NULL,
	apellido			NVARCHAR(255)	NOT NULL,	
	dni					DECIMAL(18)	NOT NULL,
	direccion			NVARCHAR(255)	NOT NULL,	
	telefono			INT		NOT NULL,
	mail				NVARCHAR(255)	NOT NULL,	
	fecha_nacimiento	DATETIME2	NOT NULL,	
	costo_hora			DECIMAL(18,2)	NOT NULL,
	tipo_id				INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Empleado_Tipo(id)	)

CREATE TABLE MONKEY_D_BASE.Viaje (
	id						INT IDENTITY PRIMARY KEY,
	fecha_inicio			DATETIME2	NOT NULL,	
	fecha_fin				DATETIME2	NOT NULL,	
	combustible_consumido	INT		NOT NULL,	
	precio_recorrido_his	DECIMAL(18,2)	NOT NULL,
	chofer_legajo			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Empleado(legajo),	
	recorrido_codigo		INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Recorrido(id),	
	camion_codigo			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Camion(id)	)

CREATE TABLE MONKEY_D_BASE.Viaje_Paquete (
	id						INT IDENTITY PRIMARY KEY,
	paquete_cantidad		INT NOT NULL,
	paquete_precio_hist		DECIMAL(18,2) NOT NULL,
	tipo_id					INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Paquete_tipo(id),
	viaje_id				INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Viaje(id)
)

CREATE TABLE MONKEY_D_BASE.Taller (
	id			INT IDENTITY PRIMARY KEY,
	nombre		NVARCHAR(255)	NOT NULL,
	ciudad		NVARCHAR(255)	NOT NULL,
	mail		NVARCHAR(255)	NOT NULL,
	telefono	DECIMAL(18)		NOT NULL,	
	direccion	NVARCHAR(255)	NOT NULL	)

CREATE TABLE MONKEY_D_BASE.Material (
	id			INT IDENTITY PRIMARY KEY,
	codigo      NVARCHAR(100),
	descripcion	NVARCHAR(255)	NOT NULL,
	precio      DECIMAL(18,2) NOT NULL	)

CREATE TABLE MONKEY_D_BASE.Tarea_Tipo (
	id			INT IDENTITY PRIMARY KEY,
	descripcion	NVARCHAR(255)	NOT NULL	)

CREATE TABLE MONKEY_D_BASE.Tarea (
	id				INT IDENTITY PRIMARY KEY,
	descripcion		NVARCHAR(255)	NOT NULL,
	tiempo_estimado	INT		NOT NULL,
	tipo_id			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Tarea_Tipo(id)	)

CREATE TABLE MONKEY_D_BASE.Estado_OT (
	id			INT IDENTITY PRIMARY KEY,
	descripcion	NVARCHAR(255)	NOT NULL	)

CREATE TABLE MONKEY_D_BASE.Orden_Trabajo (
	id			INT IDENTITY PRIMARY KEY,
	fecha		DATETIME2 NOT NULL,
	camion_id	INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Camion(id),
	taller_id	INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Taller(id),
	estado_id	INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Estado_OT(id)	)

CREATE TABLE MONKEY_D_BASE.Orden_Tarea (
	id					INT IDENTITY PRIMARY KEY,
	fecha_planificada	DATETIME2 NOT NULL,
	fecha_ini_real		DATETIME2 NOT NULL,
	fecha_fin_real		DATETIME2 NOT NULL,
	orden_id			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Orden_Trabajo(id),
	tarea_id			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Tarea(id),
	mecanico_legajo		INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Empleado(legajo)	)

CREATE TABLE MONKEY_D_BASE.Tarea_Material (
	id					INT IDENTITY PRIMARY KEY,
	material_cantidad	INT NOT NULL,
	material_id			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Material(id),
	tarea_id			INT FOREIGN KEY REFERENCES MONKEY_D_BASE.Tarea(id)	)

GO				-- hago la creacion de todas las tablas en un bloque, crea todo o nada

--CARGA RECORRIDO
INSERT INTO MONKEY_D_BASE.Recorrido (ciudad_origen,ciudad_destino,precio,kms)
SELECT distinct m.RECORRIDO_CIUDAD_ORIGEN,m.RECORRIDO_CIUDAD_DESTINO,m.RECORRIDO_PRECIO,m.RECORRIDO_KM
FROM GD2C2021.gd_esquema.Maestra m
where m.RECORRIDO_CIUDAD_ORIGEN is not null;

--CARGA MARCA
INSERT INTO MONKEY_D_BASE.Marca (descripcion)
SELECT distinct m.MARCA_CAMION_MARCA
FROM gd_esquema.Maestra m
WHERE m.MARCA_CAMION_MARCA is not null;

--CARGA MODELO -- Existen descripciones de modelo iguales que tienen valores distintos
INSERT INTO MONKEY_D_BASE.Camion_Modelo (descripcion,capacidad_tanque,capacidad_carga,velocidad_max,marca_id)
SELECT distinct m.MODELO_CAMION, m.MODELO_CAPACIDAD_TANQUE,m.MODELO_CAPACIDAD_CARGA,m.MODELO_VELOCIDAD_MAX,mar.id
FROM gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Marca mar on m.MARCA_CAMION_MARCA = mar.descripcion;

--CARGA CAMION
INSERT INTO MONKEY_D_BASE.Camion (nro_chasis,nro_motor,fecha_alta,patente,modelo_id)
SELECT distinct m.CAMION_NRO_CHASIS,m.CAMION_NRO_MOTOR,m.CAMION_FECHA_ALTA,m.CAMION_PATENTE,cm.id
FROM gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Camion_Modelo cm on m.MODELO_CAMION = cm.descripcion
AND m.MODELO_CAPACIDAD_TANQUE = cm.capacidad_tanque AND m.MODELO_CAPACIDAD_CARGA = cm.capacidad_carga
AND m.MODELO_VELOCIDAD_MAX =cm.velocidad_max;

--CARGA PAQUETE TIPO
INSERT INTO MONKEY_D_BASE.Paquete_Tipo (descripcion,peso_max,alto_max,ancho_max,largo_max,precio)
SELECT distinct m.PAQUETE_DESCRIPCION,m.PAQUETE_PESO_MAX,m.PAQUETE_ALTO_MAX,m.PAQUETE_ANCHO_MAX,m.PAQUETE_LARGO_MAX,m.PAQUETE_PRECIO
FROM gd_esquema.Maestra m
WHERE m.PAQUETE_DESCRIPCION is not null;

--CARGA TIPO EMPLEADO
INSERT INTO MONKEY_D_BASE.Empleado_Tipo (tipo_descripcion)
VALUES ('CHOFER');

INSERT INTO MONKEY_D_BASE.Empleado_Tipo (tipo_descripcion)
VALUES ('MECANICO');

--CARGA EMPLEADO
SET IDENTITY_INSERT MONKEY_D_BASE.Empleado ON; -- Desactivo la propiedad de autoincremento

INSERT INTO MONKEY_D_BASE.Empleado (legajo,nombre,apellido,dni,direccion,telefono,mail,fecha_nacimiento,costo_hora,tipo_id)
SELECT distinct m.CHOFER_NRO_LEGAJO,m.CHOFER_NOMBRE,m.CHOFER_APELLIDO,m.CHOFER_DNI,m.CHOFER_DIRECCION,m.CHOFER_TELEFONO,m.CHOFER_MAIL,m.CHOFER_FECHA_NAC,m.CHOFER_COSTO_HORA, et.id
FROM gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Empleado_Tipo et ON et.tipo_descripcion = 'CHOFER'
WHERE m.CHOFER_NRO_LEGAJO is not null
ORDER BY 1 ASC;

INSERT INTO MONKEY_D_BASE.Empleado (legajo,nombre,apellido,dni,direccion,telefono,mail,fecha_nacimiento,costo_hora,tipo_id)
SELECT distinct m.MECANICO_NRO_LEGAJO,m.MECANICO_NOMBRE,m.MECANICO_APELLIDO,m.MECANICO_DNI,m.MECANICO_DIRECCION,m.MECANICO_TELEFONO,m.MECANICO_MAIL,m.MECANICO_FECHA_NAC,m.MECANICO_COSTO_HORA,et.id
FROM gd_esquema.Maestra m 
JOIN MONKEY_D_BASE.Empleado_Tipo et ON et.tipo_descripcion = 'MECANICO'
WHERE m.MECANICO_NRO_LEGAJO is not null
ORDER BY 1 ASC;

SET IDENTITY_INSERT MONKEY_D_BASE.Empleado OFF; --Activo la propiedad de autoincremento

--CARGA VIAJE
INSERT INTO MONKEY_D_BASE.Viaje (fecha_inicio,fecha_fin,combustible_consumido,recorrido_codigo,camion_codigo,chofer_legajo,precio_recorrido_his)
SELECT distinct
        m.VIAJE_FECHA_INICIO, 
        m.VIAJE_FECHA_FIN,
		m.VIAJE_CONSUMO_COMBUSTIBLE, 
		r.id recorrido,
        c.id camion,
        m.CHOFER_NRO_LEGAJO chofer,
		m.RECORRIDO_PRECIO precio_hist
FROM GD2C2021.gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Recorrido r ON r.ciudad_origen = m.RECORRIDO_CIUDAD_ORIGEN
AND r.ciudad_destino = m.RECORRIDO_CIUDAD_DESTINO
JOIN MONKEY_D_BASE.Camion c ON c.patente = m.CAMION_PATENTE
WHERE m.VIAJE_FECHA_INICIO is not null;

--CARGA VIAJE PAQUETE
INSERT INTO MONKEY_D_BASE.Viaje_Paquete (paquete_cantidad,paquete_precio_hist,tipo_id,viaje_id)
SELECT distinct m.PAQUETE_CANTIDAD,m.PAQUETE_PRECIO,pt.id,v.id
FROM gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Paquete_Tipo pt ON pt.descripcion = m.PAQUETE_DESCRIPCION
JOIN MONKEY_D_BASE.Viaje v ON v.fecha_inicio = m.VIAJE_FECHA_INICIO AND v.fecha_fin = m.VIAJE_FECHA_FIN AND v.combustible_consumido = m.VIAJE_CONSUMO_COMBUSTIBLE
AND v.precio_recorrido_his = m.RECORRIDO_PRECIO AND v.chofer_legajo = m.CHOFER_NRO_LEGAJO
JOIN MONKEY_D_BASE.Recorrido r ON r.ciudad_origen = m.RECORRIDO_CIUDAD_ORIGEN AND r.ciudad_destino = m.RECORRIDO_CIUDAD_DESTINO
JOIN MONKEY_D_BASE.Camion c ON c.patente = m.CAMION_PATENTE AND c.id = v.camion_codigo
WHERE m.VIAJE_FECHA_INICIO is not null; -- paquete_precio_hist representa lo que se cobro por tipo de paquete por unidad

--CARGA TALLER
INSERT INTO MONKEY_D_BASE.Taller (nombre,direccion,ciudad,mail,telefono)
SELECT distinct m.TALLER_NOMBRE,m.TALLER_DIRECCION,m.TALLER_CIUDAD,m.TALLER_MAIL,m.TALLER_TELEFONO  
FROM GD2C2021.gd_esquema.Maestra m
WHERE m.TALLER_MAIL is not null
Order by m.TALLER_NOMBRE asc;

--CARGA TIPO TAREA
INSERT INTO MONKEY_D_BASE.Tarea_Tipo (descripcion)
SELECT distinct m.TIPO_TAREA
FROM GD2C2021.gd_esquema.Maestra m
WHERE m.TIPO_TAREA is not null;

--CARGA TAREA
SET IDENTITY_INSERT MONKEY_D_BASE.tarea ON; -- Desactivo la propiedad de autoincremento

INSERT INTO MONKEY_D_BASE.Tarea (id,descripcion,tipo_id,tiempo_estimado)
SELECT distinct m.TAREA_CODIGO,m.TAREA_DESCRIPCION,tt.id,m.TAREA_TIEMPO_ESTIMADO 
--,m.TAREA_FECHA_FIN,m.TAREA_FECHA_INICIO,m.TAREA_FECHA_INICIO_PLANIFICADO
FROM GD2C2021.gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Tarea_Tipo tt ON tt.descripcion = m.TIPO_TAREA
WHERE m.TAREA_CODIGO is not null
ORDER BY m.TAREA_DESCRIPCION asc;

SET IDENTITY_INSERT MONKEY_D_BASE.Tarea OFF; -- Desactivo la propiedad de autoincremento

--CARGA MATERIAL
INSERT INTO MONKEY_D_BASE.Material (codigo,descripcion,precio)
SELECT distinct material_cod,
(CASE WHEN ISNUMERIC(right(material_descripcion,1)) = 1 THEN LEFT(m.MATERIAL_DESCRIPCION, LEN(m.material_descripcion) - 1) ELSE m.MATERIAL_DESCRIPCION END),
material_precio 
FROM gd_esquema.Maestra m 
WHERE material_cod is not null;

--CARGA TAREA MATERIAL
INSERT INTO MONKEY_D_BASE.Tarea_Material (tarea_id,material_id,material_cantidad)
SELECT distinct m.TAREA_CODIGO,mat.id,(CASE WHEN ISNUMERIC(right(m.MATERIAL_DESCRIPCION,1)) = 1 THEN right(m.material_descripcion,1) ELSE 1 END) 
FROM gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Material mat ON mat.codigo = m.MATERIAL_COD
WHERE m.MATERIAL_COD is not null AND m.TAREA_CODIGO is not null
ORDER BY 1 ASC;

--CARGA ESTADO OT
INSERT INTO MONKEY_D_BASE.Estado_OT (descripcion)
VALUES ('Iniciada'); --Creo otro estado de orden de trabajo de ejemplo

INSERT INTO MONKEY_D_BASE.Estado_OT (descripcion)
VALUES ('Pausada');

INSERT INTO MONKEY_D_BASE.Estado_OT (descripcion)
SELECT distinct m.ORDEN_TRABAJO_ESTADO
FROM gd_esquema.Maestra m
WHERE m.ORDEN_TRABAJO_ESTADO is not null;

--CARGA ORDEN DE TRABAJO
INSERT INTO MONKEY_D_BASE.Orden_Trabajo (fecha,estado_id,camion_id,taller_id)
SELECT distinct m.ORDEN_TRABAJO_FECHA,e.id,c.id, tal.id
FROM GD2C2021.gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Estado_OT e ON e.descripcion = m.ORDEN_TRABAJO_ESTADO 
JOIN MONKEY_D_BASE.Taller tal ON tal.mail = m.TALLER_MAIL AND tal.direccion = m.TALLER_DIRECCION
JOIN MONKEY_D_BASE.Camion c ON c.patente = m.CAMION_PATENTE
WHERE m.ORDEN_TRABAJO_FECHA is not null;

--CARGA ORDEN TAREA
INSERT INTO MONKEY_D_BASE.Orden_Tarea (fecha_planificada,fecha_ini_real,fecha_fin_real,orden_id,tarea_id,mecanico_legajo)
SELECT distinct m.TAREA_FECHA_INICIO_PLANIFICADO,m.TAREA_FECHA_INICIO,m.TAREA_FECHA_FIN,ot.id,t.id,e.legajo
FROM gd_esquema.Maestra m
JOIN MONKEY_D_BASE.Orden_Trabajo ot ON ot.fecha = m.ORDEN_TRABAJO_FECHA 
JOIN MONKEY_D_BASE.Taller tal ON ot.taller_id = tal.id AND tal.mail = m.TALLER_MAIL AND tal.direccion = m.TALLER_DIRECCION
JOIN MONKEY_D_BASE.Camion c ON ot.camion_id = c.id -- AND c.patente = m.CAMION_PATENTE
JOIN MONKEY_D_BASE.Tarea t ON t.descripcion = m.TAREA_DESCRIPCION
JOIN MONKEY_D_BASE.Empleado e ON e.legajo = m.MECANICO_NRO_LEGAJO;
