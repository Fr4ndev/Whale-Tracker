#!/bin/bash

# Colors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Configuración de umbrales para detectar ballenas (en BTC)
WHALE_THRESHOLD=100  # Transacciones mayores a 100 BTC se consideran de ballenas
EXTREME_MOVEMENT=1000  # Movimientos extremos mayores a 1000 BTC

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n${redColour}[!] Saliendo...\n${endColour}"
    cleanup
    tput cnorm; exit 1
}

function cleanup() {
    rm *.tmp whales.log signals.log 2>/dev/null
}

function checkDependencies(){
    dependencies=(html2text bc curl jq)
    
    for program in "${dependencies[@]}"; do
        if ! command -v "$program" &> /dev/null; then
            echo -e "${redColour}[X] $program no está instalado${endColour}"
            echo -e "${yellowColour}[i] Instalando $program...${endColour}"
            sudo apt install "$program" -y &> /dev/null
        fi
    done
}

function getMarketData() {
    # Obtener precio actual de BTC
    local price=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd" | jq '.bitcoin.usd')
    echo $price > price.tmp
}

function analyzeWhaleMovement() {
    local amount=$1
    local threshold=$WHALE_THRESHOLD
    local price=$(cat price.tmp)
    
    if (( $(echo "$amount > $threshold" | bc -l) )); then
        local usd_value=$(echo "$amount * $price" | bc -l)
        echo -e "${yellowColour}[!] Movimiento de ballena detectado${endColour}"
        echo -e "Cantidad: $amount BTC ($usd_value USD)"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Whale movement: $amount BTC ($usd_value USD)" >> whales.log
        
        analyzeSignal $amount
    fi
}

function analyzeSignal() {
    local amount=$1
    local timestamp=$(date '+%s')
    
    # Análisis básico de señales
    if (( $(echo "$amount > $EXTREME_MOVEMENT" | bc -l) )); then
        echo -e "${redColour}[!] Movimiento extremo detectado - Posible señal de venta${endColour}"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - SELL signal: Extreme movement $amount BTC" >> signals.log
    else
        # Analizar patrón de acumulación
        local recent_movements=$(tail -n 10 whales.log 2>/dev/null | grep -c "Whale movement")
        if [ $recent_movements -gt 5 ]; then
            echo -e "${greenColour}[+] Patrón de acumulación detectado - Posible señal de compra${endColour}"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - BUY signal: Accumulation pattern detected" >> signals.log
        fi
    fi
}

function monitorWhales() {
    local interval=${1:-300}  # Default 5 minutos
    
    echo -e "${blueColour}[*] Iniciando monitoreo de ballenas...${endColour}"
    echo -e "${yellowColour}[i] Intervalo de monitoreo: $interval segundos${endColour}"
    
    while true; do
        getMarketData
        
        # Monitorear transacciones no confirmadas grandes
        curl -s "https://blockchain.info/unconfirmed-transactions?format=json" | \
        jq -r '.txs[] | select(.out[].value > 10000000000) | .out[].value/100000000' | \
        while read amount; do
            analyzeWhaleMovement $amount
        done
        
        sleep $interval
    done
}

function showStats() {
    echo -e "\n${purpleColour}=== Estadísticas de Movimientos de Ballenas ===${endColour}"
    echo -e "${blueColour}Últimos movimientos detectados:${endColour}"
    tail -n 5 whales.log 2>/dev/null || echo "No hay movimientos registrados"
    
    echo -e "\n${blueColour}Últimas señales generadas:${endColour}"
    tail -n 5 signals.log 2>/dev/null || echo "No hay señales registradas"
}

# Main
checkDependencies

# Mostrar menú
echo -e "\n${yellowColour}[1]${endColour} Monitorear movimientos de ballenas"
echo -e "${yellowColour}[2]${endColour} Mostrar estadísticas"
echo -e "${yellowColour}[3]${endColour} Salir\n"

read -p "Seleccione una opción: " option

case $option in
    1)
        read -p "Intervalo de monitoreo en segundos (default 300): " interval
        interval=${interval:-300}
        monitorWhales $interval
        ;;
    2)
        showStats
        ;;
    3)
        cleanup
        exit 0
        ;;
    *)
        echo -e "${redColour}[!] Opción inválida${endColour}"
        ;;
esac
