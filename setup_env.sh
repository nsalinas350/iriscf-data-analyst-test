#!/bin/bash

# Ejecutar en el git bash con el comando:
# bash setup_env.sh


echo "🚀 Iniciando la configuración del entorno virtual..."

# 1. Eliminar entorno previo si existe para evitar conflictos
if [ -d ".venv" ]; then
    echo "🧹 Removiendo entorno virtual antiguo..."
    rm -rf .venv
fi

# 2. Crear el entorno virtual limpio
echo "📦 Creando entorno virtual .venv..."
python -m venv .venv --without-pip

# 3. Activar el entorno
echo "🔄 Activando el entorno..."
source .venv/Scripts/activate

# 4. Instalar y actualizar pip de forma segura
echo "🔝 Configurando e instalando la última versión de PIP..."
python -m ensurepip --upgrade
python -m pip install --upgrade pip

# 5. Instalar las dependencias del proyecto
echo "📥 Instalandos las librerías desde requirements.txt..."
pip install -r requirements.txt

echo "✅ ¡Entorno configurado correctamente!"