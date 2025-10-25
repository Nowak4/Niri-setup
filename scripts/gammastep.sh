#!/bin/bash

# Comando para iniciar gammastep (ajústalo si usas ubicación u opciones)
START_CMD="gammastep -PO 5000 &"

# Verificar si gammastep ya está corriendo
if pgrep -x "gammastep" >/dev/null; then
  # Si está corriendo, lo matamos
  killall gammastep 2>/dev/null
  echo "🌞 Filtro nocturno desactivado"
else
  # Si no está corriendo, lo iniciamos
  eval $START_CMD
  echo "🔆 Filtro nocturno activado"
fi
