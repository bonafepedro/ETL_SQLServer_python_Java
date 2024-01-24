# Automatización Migración Altamira a T3

El proyecto consiste en automatizar el proceso de ingesta a la base de datos SUDP en SQL Server propia de la migración del sistema Altamira a T3. Para ello realizamos procesos de extracción transformación y carga conocidos como ETL desde un filesystem de entrada la carpeta DATA, hasta el destino final que es la base de datos.
El proyecto toma la carpeta DATA como imputs por lo que deben dejarse recurrentemente allí los archivos a ser ingestados. Naturalmente para la realizar el proceso y poder establecer la conexión a la base de datos en el servidor remoto es necesario encontrarse conectado a F5.

## Ambiente de ejecución

Todo el proceso corre en un ambiente de Docker, por lo que es necesario tener instalado Docker en la computadora en que se vaya a ejecutar. Puede descargarse desde el siguiente link:

[Página Oficial Docker](https://www.docker.com/products/docker-desktop/)

En computadoras Windows es solamente ejecutar el instalador, para ello es necesario tener habilitada la virtualización en BIOS. Luego es necesario abrir Docker Desktop antes de correr el container. 

### Primera vez que ejecutamos el proyecto.

Una vez instalado nos situamos en una terminal dentro del proyecto y ejecutamos:

 `docker build -t altamira_envio_lineas .` es muy importante el . final

Esto creará la imagen del contenedor. 

Luego:

 `docker run -it -v <PATH_CARPETA_DATA>:/Altamira/DATA altamira_envio_lineas`

reemplazando <PATH_CARPETA_DATA> por el path absoluto a la carpeta DATA en nuestro proyecto local. Esto creará un volumen compartido con el container para acceder a los archivos necesarios para la ingesta. De esta manera cada vez que se modifique algún archivo en la carpeta DATA local se modificará en el container. 

### Actualización diaria

Una vez que ya hayamos ejecutado el proyecto por primera vez no necesitamos crear la imagen del contenedor nuevamente, solamente necesitamos actualizar los archivos en la carpeta DATA local (es muy importante respetar el nombre como se detalla más abajo) y ejecutar:
 
 `docker run -it -v <PATH_CARPETA_DATA>:/Altamira/DATA altamira_envio_lineas`

## Descripción del proyecto.

El programa principal con nombre ejecutable.sh ejecuta la secuencia de scripts validando condiciones para avanzar:
* Previo a la ejecución elimina la carpeta Altamira/TEMP_DATA a fin de asegurarnos de siempre tomar el último registro. 
* En primer lugar el script ETL_python.py toma la información de la carpeta DATA selecciona y filtra los campos correspondientes acorde a los requerimientos de la base y los guarda en la carpeta TEMP_DATA (Al no existir al ejecutarse por primera vez la crea). Genera archivos .csv uno por cada archivo de origen. El script toma los archivos de la carpeta de origen por la forma en que comienza (validando ARG_UDO, MML y TAR_PROD) por lo que si no queremos actualizar los datos de una tabla en particular, simplemente lo eliminamos de la carpeta DATA o bien le modificamos el nombre agregándole un __ al comienzo. Esto hará que no reconozca el nombre, lo saltee en su lectura y no lo guarde en la carpeta TEMP_DATA.

* Luego los script en Java .jar, ubicados en la carpeta Altamira/AA_Envio_Lineas uno por cada tabla. Los mismos realizan la lectura del csv correspondiente ubicado en la carpeta Altamira/TEMP_DATA, establecen la conexión a la base de datos, eliminan los datos existentes en la tabla correspondiente e ingestan los datos del .csv tomando batch de a 100.000 registros. El Ejecutable valida la existencia del archivo .csv correspondiente en la carpeta Altamira/TEMP_DATA y si existe procede a la ejecución del .jar correspondiente. Si no existe el .csv imprime por pantalla que no existe el archivo y continúa con el siguiente. 


Para ejecución con ambiente linux ejecutar:
 *  ejecutable.sh
 *  creador_metadatos.sh
Para ejecución con ambiente Windows desde una terminal ejecutar:
 *  ejecutable.ps1
 *  creador_metadatos.ps1

Para ejecución con ambiente windows y directamente haciendo doble click a la aplicación en el directorio:
 * Ejecutable.exe
 * CreadorMetadatos.exe


Estructura del proyecto:

```
Migracion_Altamira/
    ├── Altamira/
|       ├── DATA/
|           ├── ARG_UDO_restodelnombre.txt
|           ├── MML_restodelnombre.csv
|           └── TAR_PROD_restodelnombre.csv
|       ├── TEMP_DATA/      #Esta capeta no existe se crea con la ejecución del programa
|       └── AA_Envio_Lineas/
|           ├── MML.jar
|           ├── Productos.jar
|           └── Saldos.jar
|       ├── ETL_python.py
|       ├── ejecutable.sh
|       ├── requirements.txt
|       ├── _Lineas_AA_Importacion_Definiciones.txt
|       └── java.security #Configura el entorno de seguridad de Java para permitir el protocolo TSL necesario.
|   ├── Dockerfile
|   ├── .gitignore
|   └── readme.md

```

Saludos: 

*Pedro Bonafé*
