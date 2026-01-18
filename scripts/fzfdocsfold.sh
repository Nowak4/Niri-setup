#!/usr/bin/env bash

# ------------------------
# CONFIGURACIÓN
# ------------------------

# Lista de carpetas "Raíz" que quieres elegir primero
DIRECTORIOS=(
  "$HOME/Documentos"
  "$HOME/Descargas"
  "/home/tanvir/Documentos/examenes/"      # Ejemplo extra
)

# Comando del visor
VISOR="sioyek"
ARGS="--new-window"
ARCHIVO_MEMORIA="$HOME/.cache/fzfdocs_last_path" # Archivo donde guardamos la posición

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

mkdir -p "$(dirname "$ARCHIVO_MEMORIA")"

# ------------------------
# BUCLE PRINCIPAL
# ------------------------

while true; do

    # --- FASE 1: DETERMINAR PUNTO DE PARTIDA ---
    
    if [[ -f "$ARCHIVO_MEMORIA" ]]; then
        START_DIR=$(cat "$ARCHIVO_MEMORIA")
        if [[ ! -d "$START_DIR" ]]; then
            rm "$ARCHIVO_MEMORIA"
            unset START_DIR
        fi
    fi

    if [[ -z "$START_DIR" ]]; then
        RAIZ=$(printf "%s\n" "${DIRECTORIOS[@]}" | \
            fzf \
            --reverse \
            --border=none \
            --margin=5% \
            --prompt="📂 Inicio > " \
            --color="$FZF_COLORS" \
            --header="Selecciona categoría"
        )
        
        # Si RAIZ está vacío (ESC), salimos
        [[ -z "$RAIZ" ]] && exit 0
        cd "$RAIZ" || exit 1
    else
        cd "$START_DIR" || exit 1
    fi

    # --- FASE 2: NAVEGACIÓN ---

    while true; do
        pwd > "$ARCHIVO_MEMORIA"

        LISTA=$(
            echo ".."
            fd --max-depth 1 -t d --color=never -x echo "{}/"
            fd --max-depth 1 -t f -e pdf --color=never
        )

        # Usamos --expect=ctrl-r
        # Esto hará que fzf devuelva 2 líneas:
        # Línea 1: La tecla pulsada (ej: ctrl-r o vacía si fue Enter)
        # Línea 2: La selección
        SALIDA_FZF=$(echo "$LISTA" | \
            fzf \
            --reverse \
            --border=none \
            --margin=5% \
            --prompt="📂 $(basename "$PWD") > " \
            --color="$FZF_COLORS" \
            --header="ENTER: Entrar | CTRL+R: Ir al Inicio | ESC: Salir" \
            --preview 'echo {}' --preview-window=up:1:noborder \
            --expect=ctrl-r
        )

        # Capturamos el código de salida. Si es 130, es que pulsó ESC sin seleccionar nada.
        if [[ $? -ne 0 ]]; then
            exit 0
        fi

        # Separamos la salida en Tecla y Selección
        TECLA=$(head -n1 <<< "$SALIDA_FZF")
        SELECCION=$(tail -n +2 <<< "$SALIDA_FZF")

        # 1. Lógica del botón RESET
        if [[ "$TECLA" == "ctrl-r" ]]; then
            rm "$ARCHIVO_MEMORIA"
            unset START_DIR
            break # Rompe el bucle interior, vuelve al menú de categorías
        fi

        # 2. Si no hay selección (pero no fue ESC), continuamos
        if [[ -z "$SELECCION" ]]; then
            continue
        fi

        # 3. Navegación
        if [[ "$SELECCION" == ".." ]]; then
            cd ..
            continue
        fi

        if [[ "$SELECCION" == */ ]]; then
            cd "${SELECCION%/}"
            continue
        fi

        # 4. Archivo encontrado
        ARCHIVO_FINAL="$PWD/$SELECCION"
        break 2
    done
done

# ------------------------
# ABRIR EL ARCHIVO
# ------------------------

if [[ -f "$ARCHIVO_FINAL" ]]; then
    nohup "$VISOR" $ARGS "$ARCHIVO_FINAL" >/dev/null 2>&1 &
    disown
    sleep 0.2
fi

exit 0
