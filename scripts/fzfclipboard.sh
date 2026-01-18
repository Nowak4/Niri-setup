#!/usr/bin/env bash

# ------------------------
# CONFIGURACIÓN
# ------------------------

# Colores extraídos de tu configuración original
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

# 1. cliphist list: Obtiene el historial (formato: ID <tab> Contenido truncado)
# 2. fzf:
#    --delimiter '\t': Separa por tabulaciones para distinguir ID del texto.
#    --with-nth 2.. : Muestra solo el texto en la lista (oculta el ID técnico).
#    --preview: Decodifica la entrada completa para ver el contenido real/largo.
SELECCION=$(cliphist list | \
    fzf \
    --reverse \
    --border=none \
    --margin=5% \
    --prompt=" Clip > " \
    --color="$FZF_COLORS" \
    --delimiter $'\t' --with-nth 2.. \
    --preview-window=up:3:noborder \
	--header="ENTER o CTRL-L copiar | CTRL-X borrar | ESC salir" \
    --bind 'esc:abort' \
    --bind 'ctrl-l:accept' \
	--bind 'ctrl-x:execute(echo {} | cliphist delete)+reload(cliphist list)'
)

# ------------------------
# ACCIÓN (COPIAR)
# ------------------------

if [[ -n "$SELECCION" ]]; then
    # Decodificamos la selección y la enviamos al portapapeles de Wayland
    echo "$SELECCION" | cliphist decode | wl-copy
    
    # Opcional: Notificación visual (requiere libnotify)
    # notify-send "Portapapeles" "Elemento copiado correctamente"
fi

kill $PPID
exit 0
