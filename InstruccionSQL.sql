-- Instrucción SQL

-- Tabla almacenamiento

CREATE TABLE public.archivos (
	id serial4 NOT NULL,
	nombre_archivo varchar(255) NULL,
	extension_archivo varchar(20) NULL,
	ubicacion_archivo text NULL,
	tamano_archivo int8 NULL,
	fecha_creacion timestamp NULL,
	fecha_modificacion timestamp NULL,
	propietario varchar(100) NULL,
	paginas int4 NULL,
	creado_en timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT archivos_pkey PRIMARY KEY (id)
);

TRUNCATE TABLE archivos;

-- Tabla errores
CREATE TABLE errores_archivos (
    id SERIAL PRIMARY KEY,
    ruta_archivo TEXT,
    tipo_error TEXT,
    fecha_error TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE errores_archivos;

-- Consulta resultados

select count(id)
from archivos;

--- 18.239 archivos en 1 minuto 30 segundos.