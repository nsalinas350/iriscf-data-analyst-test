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

## Punto 1: Preparación de los datos

Se establece como objetivo la limpieza de las fuentes de datos `clientes.json` y `transacciones.csv` con el fin de consolidar un único archivo que sirva de insumo para el Dashboard.

### 🔍 Exploración y Diagnóstico de Fuentes

Tras realizar una inspección exhaustiva de las fuentes crudas, se identificó que ambos sistemas de origen entregan datos con un alto nivel de inconsistencia. A continuación, se detallan los hallazgos agrupados:

1. Diagnóstico de la Infraestructura y Formatos de Entrada
    *   **Clientes (`clientes.json`):** El archivo no se encuentra en el formato nativo por defecto de Apache Spark (*"JSON Lines"*), sino que está estructurado como un JSON tradicional multilínea, lo que requiere una lectura explícita mediante la opción `multiLine=True`. Adicionalmente, expone estructuras complejas con datos anidados en los atributos de `contacto` (struct) y `productos` (array).  
    *   **Transacciones (`transacciones.csv`):** Mediante una pre-lectura, se determinó que el delimitador de origen no es la coma tradicional, sino el punto y coma (`;`), requiriendo el ajuste del parámetro `sep=";"` en el motor de Spark.

2. Hallazgos en la Tabla de Apoyo: 👥 Clientes
    *   Manejo de Identidades (IDs y Documentos):
        *   Presencia de valores nulos o ausentes en la columna `numero_documento`.
        *   Coexistencia de registros duplicados que comparten el mismo `id_cliente` o `numero_documento`.
    *   Dispersión de Formatos en Campos de Texto y Fechas:
        *   **Variables Categóricas Caóticas:** Las columnas `activo`, `ciudad`, `segmento` y `tipo_documento` operan como variables categóricas pero carecen de una política de estandarización. Se evidencian problemas de capitalización (*"Premium"* vs *"premium"*), abreviaciones informales (*"b/quilla"* por *"Barranquilla"*), diferente indicador de documento (*"cc"* vs *"C.C."*) y respuestas heterogéneas para estados booleanos (*"true"*, *"false"*, *"SI"*, *"No"*, *"0"*, *"1"*).
        *   **Heterogeneidad de Escritura:** Los campos de `nombre`, `contacto.telefono` y `fecha_alta` vienen digitados bajo múltiples patrones (ej. teléfonos con indicativos, paréntesis o planos; fechas en formatos *"AAAA-MM-DD"*, *"DD/MM/AAAA"* o *"DD-mmm-AAAA"*; nombres totalmente en mayúsculas o minúsculas, con o sin tíldes).

3. Hallazgos en la Tabla Principal: 💸 Transacciones
    *   Integridad Referencial y Duplicidad:
        *   Se detectó la presencia de "Clientes Fantasma", es decir, transacciones asociadas a un `id_cliente` que no existe en la base de datos de clientes, lo que impediría un cruce.
        *   Se identificaron filas con `id_transaccion` repetidos, implicando registros duplicados en los movimientos financieros.
    *   Calidad de Datos Métricos y Categóricos:
        *   **Variables Categóricas Caóticas:** Al igual que en clientes, los campos categóricos de `tipo_producto`, `moneda`, `canal`, `estado` y `sucursal` registran múltiples cadenas para referirse al mismo concepto.
        *   **Heterogeneidad de Escritura:** Las variables `monto`, `tasa_interes`, `plazo_dias` y `fecha` presentan anomalías de formato (símbolos monetarios o de porcentaje, caracteres de texto, separadores de miles y fechas en formato distinto) que impiden su casting directo a tipos cuantitativos.


