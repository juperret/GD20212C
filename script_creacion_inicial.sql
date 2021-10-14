/*******************
*** BASE DE DATOS **
********************/
USE GD2C2021
GO

/************************
*** CREACION DE SCHEMA **
*************************/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MONKEY')
	EXEC ('CREATE SCHEMA MONKEY')
GO

/************************
*** DROPEO DE OBJETOS ***
*************************/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Orden_Tarea') and type = 'U')
	DROP TABLE [MONKEY].Orden_Tarea
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Orden_Trabajo') and type = 'U')
	DROP TABLE [MONKEY].Orden_Trabajo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Estado_OT') and type = 'U')
	DROP TABLE [MONKEY].Estado_OT
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Tarea_Material') and type = 'U')
	DROP TABLE [MONKEY].Tarea_Material
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Tarea') and type = 'U')
	DROP TABLE [MONKEY].Tarea
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Tarea_Tipo') and type = 'U')
	DROP TABLE [MONKEY].Tarea_Tipo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Material') and type = 'U')
	DROP TABLE [MONKEY].Material
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Taller') and type = 'U')
	DROP TABLE [MONKEY].Taller
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Viaje') and type = 'U')
	DROP TABLE [MONKEY].Viaje
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Empleado') and type = 'U')
	DROP TABLE [MONKEY].Empleado
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Empleado_Tipo') and type = 'U')
	DROP TABLE [MONKEY].Empleado_Tipo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Camion') and type = 'U')
	DROP TABLE [MONKEY].Camion
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Camion_Modelo') and type = 'U')
	DROP TABLE [MONKEY].Camion_Modelo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Marca') and type = 'U')
	DROP TABLE [MONKEY].Marca
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Paquete_Tipo') and type = 'U')
	DROP TABLE [MONKEY].Paquete_tipo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[MONKEY].Recorrido') and type = 'U')
	DROP TABLE [MONKEY].Recorrido
GO

/************************
*** CRECION DE TABLAS ***
*************************/
CREATE TABLE [MONKEY].Recorrido (
	id				INT IDENTITY PRIMARY KEY,
	ciudad_origen	NVARCHAR(255)	NOT NULL,
	ciudad_destino	NVARCHAR(255)	NOT NULL,
	precio			DECIMAL(18,2)	NOT NULL,
	kms				INT		NOT NULL)

CREATE TABLE [MONKEY].Paquete_Tipo (		
	id				INT IDENTITY PRIMARY KEY,
	descripcion		NVARCHAR(255) NOT NULL,
	peso_max		DECIMAL(18,2) NOT NULL,
	alto_max		DECIMAL(18,2) NOT NULL,
	ancho_max		DECIMAL(18,2) NOT NULL,
	largo_max		DECIMAL(18,2) NOT NULL,
	precio			DECIMAL(18,2) NOT NULL	) 
									
CREATE TABLE [MONKEY].Marca (
	id				INT IDENTITY PRIMARY KEY,
	descripcion		NVARCHAR(255) NOT NULL	)

CREATE TABLE [MONKEY].Camion_Modelo (
	id					INT IDENTITY PRIMARY KEY,
	descripcion			NVARCHAR(255)	NOT NULL,
	capacidad_tanque	INT		NOT NULL,
	capacidad_carga		INT		NOT NULL,
	velocidad_max		INT		NOT NULL,
	marca_id			INT FOREIGN KEY REFERENCES [MONKEY].Marca(id) )

CREATE TABLE [MONKEY].Camion (
	id			INT IDENTITY PRIMARY KEY,
	nro_chasis	NVARCHAR(255)	NOT NULL,
	nro_motor	NVARCHAR(255)	NOT NULL,
	fecha_alta	Datetime2	NOT NULL,
	patente		NVARCHAR(255)	NOT NULL,
	modelo_id	INT FOREIGN KEY REFERENCES [MONKEY].Camion_Modelo(id) )

CREATE TABLE [MONKEY].Empleado_Tipo (
	id					INT IDENTITY PRIMARY KEY,
	tipo_descripcion	NVARCHAR(255) NOT NULL	)

CREATE TABLE [MONKEY].Empleado (
	legajo				INT IDENTITY PRIMARY KEY,
	nombre				NVARCHAR(255)	NOT NULL,
	apellido			NVARCHAR(255)	NOT NULL,	
	dni					DECIMAL(18)	NOT NULL,
	direccion			NVARCHAR(255)	NOT NULL,	
	telefono			INT		NOT NULL,
	mail				NVARCHAR(255)	NOT NULL,	
	fecha_nacimiento	DATETIME2	NOT NULL,	
	costo_hora			DECIMAL(18,2)	NOT NULL,
	tipo_id				INT FOREIGN KEY REFERENCES [MONKEY].Empleado_Tipo(id)	)

CREATE TABLE [MONKEY].Viaje (
	id						INT IDENTITY PRIMARY KEY,
	fecha_inicio			DATETIME2	NOT NULL,	
	fecha_fin				DATETIME2	NOT NULL,	
	combustible_consumido	INT		NOT NULL,	
	precio_recorrido_his	DECIMAL(18,2)	NOT NULL,
	chofer_legajo			INT FOREIGN KEY REFERENCES [MONKEY].Empleado(legajo),	
	recorrido_codigo		INT FOREIGN KEY REFERENCES [MONKEY].Recorrido(id),	
	camion_codigo			INT FOREIGN KEY REFERENCES [MONKEY].Camion(id)	)

CREATE TABLE [MONKEY].Taller (
	id			INT IDENTITY PRIMARY KEY,
	nombre		NVARCHAR(255)	NOT NULL,
	ciudad		NVARCHAR(255)	NOT NULL,
	mail		NVARCHAR(255)	NOT NULL,
	telefono	DECIMAL(18)		NOT NULL,	
	direccion	NVARCHAR(255)	NOT NULL	)

CREATE TABLE [MONKEY].Material (
	id			INT IDENTITY PRIMARY KEY,
	descripcion	NVARCHAR(255)	NOT NULL	)

CREATE TABLE [MONKEY].Tarea_Tipo (
	id			INT IDENTITY PRIMARY KEY,
	descripcion	NVARCHAR(255)	NOT NULL	)

CREATE TABLE [MONKEY].Tarea (
	id				INT IDENTITY PRIMARY KEY,
	descripcion		NVARCHAR(255)	NOT NULL,
	tiempo_estimado	INT		NOT NULL,
	tipo_id			INT FOREIGN KEY REFERENCES [MONKEY].Tarea_Tipo(id)	)

CREATE TABLE [MONKEY].Tarea_Material (
	id					INT IDENTITY PRIMARY KEY,
	material_cantidad	INT NOT NULL,
	material_id			INT FOREIGN KEY REFERENCES [MONKEY].Material(id),
	tarea_id			INT FOREIGN KEY REFERENCES [MONKEY].Tarea(id)	)

CREATE TABLE [MONKEY].Estado_OT (
	id			INT IDENTITY PRIMARY KEY,
	descripcion	NVARCHAR(255)	NOT NULL	)

CREATE TABLE [MONKEY].Orden_Trabajo (
	id			INT IDENTITY PRIMARY KEY,
	fecha		DATETIME2 NOT NULL,
	camion_id	INT FOREIGN KEY REFERENCES [MONKEY].Camion(id),
	taller_id	INT FOREIGN KEY REFERENCES [MONKEY].Taller(id),
	estado_id	INT FOREIGN KEY REFERENCES [MONKEY].Estado_OT(id)	)

CREATE TABLE [MONKEY].Orden_Tarea (
	id					INT IDENTITY PRIMARY KEY,
	fecha_planificada	DATETIME2 NOT NULL,
	fecha_ini_real		DATETIME2 NOT NULL,
	fecha_fin_real		DATETIME2 NOT NULL,
	orden_id			INT FOREIGN KEY REFERENCES [MONKEY].Orden_Trabajo(id),
	tarea_id			INT FOREIGN KEY REFERENCES [MONKEY].Tarea(id),
	mecanico_legajo		INT FOREIGN KEY REFERENCES [MONKEY].Empleado(legajo)	)

GO				-- hago la creacion de todas las tablas en un bloque, crea todo o nada

