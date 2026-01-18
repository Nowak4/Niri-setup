#!/bin/bash

# --- CONFIGURACIÓN ---
# Buscar el perfil de Firefox
PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -name "*.default-release" -print -quit)
PLACES_FILE="$PROFILE/places.sqlite"

# --- EXTRACCIÓN DE DATOS ---
# Crear copia temporal
TEMP_DB=$(mktemp)
cp "$PLACES_FILE" "$TEMP_DB"

# Extraer títulos y URLs en arrays
mapfile -t TITLES < <(sqlite3 "$TEMP_DB" "
SELECT bm.title FROM moz_bookmarks bm
JOIN moz_places p ON bm.fk = p.id
WHERE bm.type = 1 AND bm.title IS NOT NULL AND p.url LIKE 'http%'
ORDER BY bm.dateAdded DESC;")

mapfile -t URLS < <(sqlite3 "$TEMP_DB" "
SELECT p.url FROM moz_bookmarks bm
JOIN moz_places p ON bm.fk = p.id
WHERE bm.type = 1 AND bm.title IS NOT NULL AND p.url LIKE 'http%'
ORDER BY bm.dateAdded DESC;")

# Limpieza
rm "$TEMP_DB"

# --- INTERFAZ (ROFI) ---
selection=$(
  printf "%s\n" "${TITLES[@]}" |
  rofi -dmenu -p "" \
    -theme ~/.config/rofi/browser.rasi
)

[ -z "$selection" ] && exit 0

# --- LÓGICA DE SELECCIÓN ---
FINAL_URL=""

# 1. Comprobar si la selección coincide con un título de Marcador
for i in "${!TITLES[@]}"; do
    if [ "${TITLES[$i]}" = "$selection" ]; then
        FINAL_URL="${URLS[$i]}"
        break
    fi
done

# 2. Si no es marcador, comprobar si es una URL directa
# Regex: Si empieza por http/https O (tiene un punto y NO tiene espacios)
if [ -z "$FINAL_URL" ]; then
    if [[ "$selection" =~ ^(https?://) ]] || ([[ "$selection" =~ \. ]] && [[ ! "$selection" =~ [[:space:]] ]]); then
        FINAL_URL="$selection"
    fi
fi

# 3. Si no es URL, entonces es una búsqueda en Google
if [ -z "$FINAL_URL" ]; then
    encoded_query=$(echo "$selection" | sed 's/ /+/g')
    FINAL_URL="https://www.google.com/search?q=$encoded_query"
fi

# --- EJECUCIÓN ---
firefox "$FINAL_URL" &

# Esperar un momento a que la ventana se registre

# Focalizar Firefox en Niri
# (Usamos 'msg action' para asegurar compatibilidad, ajusta si tu versión de niri usa otra sintaxis)
