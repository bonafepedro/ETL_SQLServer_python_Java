#!/bin/bash

# 1. Registra el tiempo de inicio
start_time=$(date +%s)

# 2. Actualiza pip
python3 -m pip install --upgrade pip

# 3. Instala las dependencias desde requirements.txt
#pip install -r /Altamira/requirements.txt || {
    # Instala dependencias manualmente si el archivo requirements.txt no está presente
#    pip install pandas numpy pyodbc openpyxl pyarrow fastparquet
#}

pip install pandas pyarrow fastparquet

# 4. Eliminamos la carpeta TEMP_DATA si existe
if [ -d "/Altamira/TEMP_DATA" ]; then
    rm -r "/Altamira/TEMP_DATA"
fi

# 5. Ejecuta el script ETL_python.py
python3 /Altamira/ETL_python.py

# 6. Desactiva el entorno virtual cuando hayas terminado
#deactivate

# 7. Verifica y ejecuta los archivos .jar
for jar_file in "MML" "Productos" "Saldos"; do
    if [ -f "/Altamira/TEMP_DATA/${jar_file}.csv" ]; then
        java -jar "/Altamira/AA_Envio_Lineas/${jar_file}.jar"
    else
        echo "El archivo ${jar_file}.csv no existe en la carpeta TEMP_DATA. No se ejecutará el archivo ${jar_file}.jar"
    fi
done

# Registra el tiempo de finalización
end_time=$(date +%s)

# Calcula la diferencia de tiempo
elapsed_time=$((end_time - start_time))

# Imprime el tiempo transcurrido
echo "Tiempo total de ejecución: ${elapsed_time} segundos"