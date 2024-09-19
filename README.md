# 📄 PDF Metadata Extractor and File Processor

## 🛠️ Objetivo del Proyecto

Este proyecto tiene como objetivo **extraer metadatos** de archivos y PDFs en un repositorio especificado, almacenando la información relevante (nombre del archivo, extensión, ubicación, tamaño, fecha de creación, modificación, número de páginas en PDFs, etc.) en una base de datos **PostgreSQL**. 

Además, el programa utiliza **8 hilos** para procesar los archivos de forma paralela, mejorando el rendimiento y reduciendo los tiempos de extracción.

Se realiza un **manejo de errores robusto**, registrando los archivos que no pudieron procesarse debido a errores, como problemas con metadatos corruptos o archivos temporales.

## Estructutra del proyecto

```bash
/
├── README.md                # Este archivo
├── extractor.py             # Código principal del extractor
├── requirements.txt         # Librerías necesarias
└── sql/
    ├── create_tables.sql    # SQL para crear las tablas necesarias en PostgreSQL
    └── alter_tables.sql     # SQL para alterar tablas (extensiones, etc.)
```
## 🚀 Características principales

- **Extracción de metadatos** de archivos:
  - Nombre del archivo
  - Extensión del archivo
  - Ubicación del archivo
  - Tamaño del archivo
  - Fecha de creación y modificación
  - Número de páginas (solo en archivos PDF)
  
- **Ignorar archivos temporales** o irrelevantes como:
  - `Thumbs.db`, `Desktop.ini`, `.DS_Store`
  - Archivos `.tmp`, `.bak`, `.log`, etc.
  
- **Paralelización** mediante **8 hilos** para procesar múltiples carpetas de archivos simultáneamente, mejorando considerablemente el tiempo de extracción.
  
- **Registro de errores** en la base de datos cuando:
  - No se pueden leer archivos PDF debido a problemas de metadatos o corrupción.
  - Ocurre un error durante la inserción de los datos en la base de datos.
  
---

## 📂 Estructura del Proyecto


---

## 📝 Funciones del Programa

### 1. `conectar_base_datos()`
   - Establece la conexión a la base de datos PostgreSQL.
   - Maneja los errores si la conexión no puede establecerse.

### 2. `obtener_paginas_pdf(conn, ruta_archivo)`
   - Extrae el número de páginas de un archivo PDF.
   - Ignora errores de metadatos (por ejemplo, "Multiple definitions in dictionary") y sigue extrayendo el número de páginas.
   - Registra errores relacionados con los PDFs que no pueden procesarse.

### 3. `es_archivo_restringido(archivo)`
   - Verifica si el archivo debe ser omitido, ya sea porque es un archivo temporal (por ejemplo, `.tmp`, `Thumbs.db`) o está en la lista de archivos restringidos.

### 4. `registrar_error(conn, ruta_archivo, tipo_error)`
   - Inserta el error en una tabla de errores en la base de datos. Esto asegura que todos los archivos que no pudieron procesarse correctamente sean registrados.

### 5. `procesar_directorio(conn, ruta)`
   - Procesa los archivos dentro de un directorio especificado.
   - Extrae la información de los archivos (nombre, extensión, tamaño, fechas, número de páginas).
   - Inserta los datos en la base de datos en lotes (batch).
   - Maneja y registra cualquier error durante el procesamiento.

### 6. `insertar_batch(conn, batch)`
   - Inserta un lote de archivos en la base de datos.
   - Si la inserción falla, se registran los archivos problemáticos en la tabla de errores.

### 7. `procesar_con_hilos(carpeta_base)`
   - Procesa múltiples carpetas en paralelo usando 8 hilos.
   - Esta función lanza **8 hilos** usando **ThreadPoolExecutor** para mejorar la eficiencia y reducir el tiempo de extracción.

---

## 🔧 Importancia del procesamiento con 8 hilos

El uso de **8 hilos** para procesar archivos en paralelo mejora significativamente el tiempo de procesamiento. Sin paralelización, la extracción de metadatos de una gran cantidad de archivos, especialmente en repositorios de gran tamaño, puede ser extremadamente lenta debido a la naturaleza secuencial del procesamiento.

Con **8 hilos**, el programa puede procesar varias carpetas y archivos de manera simultánea, lo que:
- **Reduce el tiempo total de procesamiento**.
- **Optimiza el uso del CPU**, al aprovechar mejor los recursos del sistema.
- **Mejora la escalabilidad**, permitiendo que grandes repositorios de archivos se procesen de manera eficiente.

### Ejemplo de comparación:
- **Procesamiento sin hilos**: Extraer metadatos de 10,000 archivos puede tomar horas debido a la naturaleza secuencial.
- **Procesamiento con 8 hilos**: Procesar la misma cantidad de archivos puede reducir el tiempo de extracción en más del 50%, dependiendo de los recursos del sistema.

---

## 🔌 Requisitos

Para ejecutar el programa, asegúrate de tener instaladas las siguientes librerías:

```bash
pip install -r requirements.txt
```
- **PyPDF2: Para extraer información de los archivos PDF.
- **psycopg2: Para interactuar con la base de datos PostgreSQL.


## 🗂️ Esquema de Base de Datos

El proyecto utiliza dos tablas principales para almacenar la información extraída y los errores que puedan ocurrir durante el procesamiento:

### 1. Tabla `archivos`
Esta tabla almacena los metadatos extraídos de los archivos procesados, como el nombre del archivo, extensión, ruta, fechas de creación y modificación, entre otros.

```bash
CREATE TABLE archivos (
    id SERIAL PRIMARY KEY,
    nombre_archivo VARCHAR(255),
    extension_archivo VARCHAR(20),
    ubicacion_archivo TEXT,
    tamano_archivo BIGINT,
    fecha_creacion TIMESTAMP,
    fecha_modificacion TIMESTAMP,
    paginas INT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Tabla `errores_archivos`
Esta tabla almacena los errores que ocurren durante el procesamiento de los archivos, como problemas al leer los archivos PDF, errores de inserción, o archivos que no pueden ser procesados por otras razones.

```bash
CREATE TABLE errores_archivos (
    id SERIAL PRIMARY KEY,
    ruta_archivo TEXT,
    tipo_error TEXT,
    fecha_error TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

> **Nota:** El esquema de las tablas puede ser modificado o ajustado según tus necesidades. Los scripts SQL para crear estas tablas deben ser insertados manualmente en la carpeta `sql`.

---

## 🖥️ Ejecución del Programa

### Requisitos
Asegúrate de tener las siguientes dependencias instaladas antes de ejecutar el programa:

- **Python 3.x**
- **PostgreSQL** (instalado y configurado)
- Librerías necesarias (indicadas en el archivo `requirements.txt`):

```bash
pip install -r requirements.txt
```

---

Este es el contenido para el archivo **`README.md`**. Puedes copiarlo y pegarlo en el archivo que desees crear en tu repositorio de **GitHub**. Asegúrate de personalizar la sección de **Contacto** y el enlace de **Licencia**, si es necesario.

¡Espero que te sea útil! 😊



