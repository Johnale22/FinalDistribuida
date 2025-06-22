# Usa una imagen base de Python
FROM python:3.8-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos necesarios
COPY . .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto en el que Flask estará escuchando
EXPOSE 5001

# Comando para ejecutar el servicio Flask
CMD ["python", "user_management.py"]
