# 🐋 Bitcoin Whale Monitor

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://semver.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/bash-%3E%3D4.0-orange)](https://www.gnu.org/software/bash/)

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

## Contribuir

Las contribuciones son bienvenidas. Por favor, considere:
1. Mantener el estilo de código existente
2. Documentar nuevas funcionalidades
3. Actualizar este README según corresponda

## Licencia

Este proyecto está licenciado bajo MIT License.

## ⚠️ Disclaimer

### Riesgos y Responsabilidad
Este software se proporciona "tal cual", sin garantía de ningún tipo, expresa o implícita. Al utilizar este software, usted acepta y reconoce que:

1. **Riesgo Financiero**: 
   - Las operaciones con criptomonedas conllevan un alto riesgo
   - Las señales generadas NO constituyen asesoramiento financiero
   - Las pérdidas pueden exceder la inversión inicial

2. **Uso del Software**:
   - El programa es una herramienta de monitoreo, NO un sistema de trading automático
   - Las señales requieren interpretación y análisis adicional
   - El rendimiento pasado no garantiza resultados futuros

3. **Precisión de Datos**:
   - La información puede no ser precisa o estar actualizada
   - Pueden existir retrasos en la obtención de datos
   - Las APIs externas pueden fallar o proporcionar datos incorrectos

4. **Aspectos Legales**:
   - El usuario es responsable de cumplir con las regulaciones locales
   - El uso del software puede estar restringido en algunas jurisdicciones
   - No nos hacemos responsables del uso indebido de la herramienta

5. **Privacidad y Seguridad**:
   - No almacenamos datos personales o financieros
   - El usuario es responsable de la seguridad de sus claves API
   - Recomendamos usar el software en un entorno seguro

### NO ASESORAMIENTO FINANCIERO
Este software es ÚNICAMENTE para fines informativos y educativos. No constituye asesoramiento financiero, de inversión o de trading. Consulte con un asesor financiero profesional antes de tomar decisiones de inversión.

---
*Al utilizar este software, usted acepta todos los términos y condiciones mencionados anteriormente.*
