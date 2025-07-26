# 🐋 Bitcoin Whale Monitor


## Descripción Técnica

Sistema automatizado de monitorización y análisis de movimientos de "ballenas" en la red Bitcoin, diseñado para detectar y analizar transacciones de gran volumen en tiempo real. Implementa análisis heurístico para la generación de señales de trading basadas en patrones de acumulación y distribución.

## Características Principales

- Monitorización en tiempo real de transacciones no confirmadas
- Detección automática de movimientos superiores a 100 BTC
- Análisis de patrones de acumulación
- Generación de señales de trading basadas en movimientos extremos
- Sistema de logging detallado para análisis posterior
- Interfaz de línea de comandos con opciones de monitoreo y estadísticas

## Dependencias

El sistema requiere las siguientes dependencias:
- `curl`: Peticiones HTTP a APIs
- `jq`: Procesamiento de JSON
- `bc`: Cálculos matemáticos de precisión
- `html2text`: Procesamiento de contenido HTML

## Configuración

### Parámetros Principales
```bash
WHALE_THRESHOLD=100     # Umbral mínimo para considerar movimiento de ballena (BTC)
EXTREME_MOVEMENT=1000   # Umbral para movimientos extremos (BTC)
```

### APIs Utilizadas
- Coingecko API: Obtención de precios en tiempo real
- Blockchain.info API: Monitorización de mempool

## Uso

### Iniciar Monitorización
```bash
./whale_monitor.sh
# Seleccionar opción 1
# Introducir intervalo de monitorización (default: 300 segundos)
```

### Visualizar Estadísticas
```bash
./whale_monitor.sh
# Seleccionar opción 2
```

## Estructura de Logs

### whales.log
Registro de movimientos de ballenas con el siguiente formato:
```
YYYY-MM-DD HH:MM:SS - Whale movement: XXX BTC (XXX USD)
```

### signals.log
Registro de señales generadas:
```
YYYY-MM-DD HH:MM:SS - [BUY/SELL] signal: [Reason]
```

## Señales Generadas

El sistema genera dos tipos de señales:
1. **Señales de Venta**: Activadas por movimientos extremos superiores a 1000 BTC
2. **Señales de Compra**: Generadas al detectar patrones de acumulación (>5 movimientos en las últimas 10 transacciones)

## Manejo de Errores

- Control de interrupciones mediante trap (SIGINT)
- Limpieza automática de archivos temporales
- Verificación y instalación automática de dependencias
- Validación de entradas de usuario

## Limitaciones Conocidas

- La precisión depende de la latencia de las APIs externas
- Posibles falsos positivos en la detección de patrones de acumulación
- El sistema no considera la fragmentación de transacciones

## Seguridad

El script implementa:
- Sanitización de inputs
- Manejo seguro de archivos temporales
- Cleanup automático al finalizar
