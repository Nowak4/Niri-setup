#!/usr/bin/env bash

# Rutas a buscar
DIRECTORIOS=(
  "$HOME/Documentos"
  "$HOME/Descargas"
)

# Buscar PDFs y cargar en array
mapfile -t ARCHIVOS < <(find "${DIRECTORIOS[@]}" -type f -iname "*.pdf" ! -iname "._*" 2>/dev/null)

# Asegúrate de que se encontraron archivos
if [ ${#ARCHIVOS[@]} -eq 0 ]; then
  notify-send "Sin resultados" "No se encontraron archivos PDF."
  exit 1
fi

# Crear entradas con nombre → ruta
OPCIONES=()
declare -A MAPA

for archivo in "${ARCHIVOS[@]}"; do
  nombre=$(basename "$archivo")
  entrada="$(printf "%-1s → %s" "$nombre" "$archivo")"
  OPCIONES+=("$entrada")
  MAPA["$entrada"]="$archivo"
done

# Mostrar en rofi
SELECCION=$(printf "%s\n" "${OPCIONES[@]}" | rofi -dmenu -i -p " " -config /home/tanvir/.config/rofi/configv.rasi)

# Si se seleccionó una opción válida
if [ -n "$SELECCION" ]; then
  ruta_elegida="${MAPA["$SELECCION"]}"
  [ -n "$ruta_elegida" ] && sioyek --new-window "$ruta_elegida" &
fi
