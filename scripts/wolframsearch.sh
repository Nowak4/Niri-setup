#!/bin/bash

# 1. Abre Rofi y guarda lo que escribas en la variable QUERY
QUERY=$(rofi -dmenu -p "WolframAlpha 🔍" -theme ~/.config/rofi/browserwolfr.rasi)

# 2. Si la variable no está vacía, abre el navegador
if [ -n "$QUERY" ]; then
    # Codifica la URL (básico) y abre
	firefox "https://www.wolframalpha.com/input/?i=${QUERY}"
fi
