FROM openjdk:11-jre-slim

ENV JAVA_SECURITY /usr/local/openjdk-11/conf/security
#COPY java.security $JAVA_SECURITY/java.security


# Instala Python y Virtualenv
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install virtualenv

# Establece el directorio de trabajo en /Altamira
WORKDIR /Altamira

# Copia todo el contenido de la carpeta Altamira al contenedor
COPY Altamira /Altamira

RUN cp -f java.security $JAVA_SECURITY/java.security
# Define el comando por defecto al ejecutar el contenedor
#CMD ["sh", "ejecutable.sh"]
