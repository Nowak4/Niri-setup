#!/usr/bin/env bash

# ------------------------
# CONFIGURACIÓN
# ------------------------

# Directorios originales
DIRECTORIOS=(
  "$HOME/Documentos"
  "$HOME/Descargas"
)

# Comando del visor
VISOR="sioyek"
ARGS="--new-window"

# Colores extraídos de tu configuración
FZF_COLORS="bg:#101010,\
bg+:#101010,\
fg:#ffffff,\
fg+:#dfb797,\
hl:#fb4934,\
hl+:#fb4934,\
pointer:#d79921,\
info:#a89984,\
prompt:#fabd2f,\
header:#fabd2f"

# ------------------------
# LÓGICA DE BÚSQUEDA
# ------------------------

# Usamos 'fd -a' para rutas absolutas, crucial para que el visor encuentre el archivo
SELECCION=$(fd -a -t f -e pdf . "${DIRECTORIOS[@]}" | \
    fzf \
    --reverse \
    --border=none \
    --margin=5% \
    --prompt=" PDF > " \
    --color="$FZF_COLORS" \
    --delimiter / --with-nth -1 \
    --preview 'echo {}' --preview-window=up:1:noborder \
    --header="ESC para salir" \
    --bind 'esc:abort'
)

# ------------------------
# ABRIR EL ARCHIVO
# ------------------------

if [[ -n "$SELECCION" ]]; then
    # 1. nohup: Evita que el proceso muera si recibe señal de colgar (SIGHUP)
    # 2. >/dev/null 2>&1: Redirige toda salida a la nada (importante para soltar la terminal)
    # 3. &: Ejecuta en segundo plano
    nohup "$VISOR" $ARGS "$SELECCION" >/dev/null 2>&1 &
    
    # 4. disown: Elimina el trabajo de la tabla de procesos de la shell actual
    disown
    
    # 5. EL TRUCO: Esperar un momento para asegurar que el proceso se independice
    # antes de matar la terminal. 0.2 segundos es imperceptible para ti pero vital para el sistema.
    sleep 0.2
fi

exit 0
