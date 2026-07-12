# 🏦 Iris CF - Prueba Técnica: Analista de Datos Jr

Este repositorio contiene la solución a la prueba técnica para el área de datos de Iris cf. El objetivo es usar **PySpark** para limpiar, ordenar y juntar dos fuentes de datos financieras crudas en un único archivo CSV, el cual será el insumo para construir un tablero de control en **Power BI**.

---

## 📁 Estructura del Repositorio

A continuación se detalla la distribución de componentes del proyecto:

```text
iriscf-data-analyst-test/
├── dashboard/
│   └── iris_financial_dashboard.pbix <-- Tablero analítico de Power BI
├── data/
│   ├── raw/                    <-- Fuentes de datos crudas originales (CSV y JSON)
│   └── processed/              <-- Ubicación final del CSV unificado y limpio
├── notebooks/
│   └── exploration.ipynb       <-- Laboratorio de exploración, diagnóstico y hallazgos
├── .gitignore                  <-- Exclusiones de Git (entornos, archivos temporales)
├── README.md                   <-- Documentación del proyecto
├── requirements.txt            <-- Dependencias con versiones congeladas (pip freeze)
└── setup_env.sh                <-- Script para configurar el entorno automáticamente
```

## 🛠️ Herramientas Usadas

Para garantizar la replicabilidad del proyecto, se listan las herramientas usadas en su desarrollo:
* Sistema Operativo: Windows 11.
* Python: Versión 3.12.10.
* Java (OpenJDK): Versión 17.0.19.
* Hadoop Winutils (Solo es necesario en Windows): Archivos winutils.exe y hadoop.dll para Hadoop 3.3.6. Usados para simular el entorno de ejecución de Spark.


## 🚀 Configuración e Inicialización del Entorno

El repositorio incluye un script en Bash (`setup_env.sh`) que automatiza la preparación del entorno virtual. 

Para construir este proyecto, se instalaron inicialmente las librerías base (`pyspark`, `pandas` y `notebook`). Posteriormente, se utilizó el comando `pip freeze` para exportar el archivo `requirements.txt`, capturando así todo el árbol de dependencias con sus versiones exactas para garantizar que el entorno sea portable y replicable.

La inicialización del entorno se puede realizar abriendo la terminal de `Git Bash` en la raíz del proyecto y ejecutando el siguiente comando:

```bash
bash setup_env.sh
```

El script realiza las siguientes acciones de forma automática:
1. Elimina cualquier entorno `.venv` previo para evitar conflictos.
2. Crea un entorno virtual limpio.
3. Activa el entorno virtual en la sesión.
4. Instala y actualiza de forma segura el gestor de paquetes `pip`.
5. Instalar todas las dependencias exactas descritas en el archivo `requirements.txt`.

