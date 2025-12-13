#!/usr/bin/env bash

# ------------------------
# CONFIGURACIÓN
# ------------------------

DIRECTORIOS=(
  "$HOME/Documentos"
  "$HOME/Descargas"
)

CACHE="$HOME/.cache/rofipdf.list"
ROFI_CONFIG="$HOME/.config/rofi/configv.rasi"
VISOR="sioyek --new-window"

# ------------------------
# GENERAR / ACTUALIZAR CACHE
# ------------------------

# Si no existe o tiene más de 1 día, regenerar
if [[ ! -f "$CACHE" || $(find "$CACHE" -mtime +1 2>/dev/null) ]]; then
    # Usamos fd por velocidad extrema
    fd -t f -e pdf . "${DIRECTORIOS[@]}" > "$CACHE"
fi

# Cargar lista en array
mapfile -t ARCHIVOS < "$CACHE"

# Si no hay resultados
if [[ ${#ARCHIVOS[@]} -eq 0 ]]; then
    notify-send "Sin resultados" "No se encontraron archivos PDF."
    exit 1
fi

# ------------------------
# GENERAR ENTRADAS PARA ROFI
# ------------------------

# Creamos un mapa: "Nombre → Ruta"
declare -A MAPA
OPCIONES=()

for archivo in "${ARCHIVOS[@]}"; do
    nombre=$(basename "$archivo")
    entrada="$nombre → $archivo"
    OPCIONES+=("$entrada")
    MAPA["$entrada"]="$archivo"
done

# ------------------------
# MOSTRAR ROFI
# ------------------------

SELECCION=$(
    printf "%s\n" "${OPCIONES[@]}" |
    rofi -dmenu -i -p " PDF" -config "$ROFI_CONFIG"
)

# ------------------------
# ABRIR EL ARCHIVO
# ------------------------

if [[ -n "$SELECCION" ]]; then
    ruta="${MAPA["$SELECCION"]}"
    [[ -n "$ruta" ]] && $VISOR "$ruta" &
fi

