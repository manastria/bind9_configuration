#!/bin/bash

# Vérifie si le script est exécuté avec 'source' ou '.'
if [[ "$(basename -- "$0")" == "bash" ]] || [[ "$(basename -- "$0")" == "-bash" ]]; then
    # Alias pour utiliser l'éditeur défini dans la variable EDITOR
    alias editnamed.local='$EDITOR /etc/bind/named.conf.local'
    alias editnamed.options='$EDITOR /etc/bind/named.conf.options'

    # Alias pour changer l'éditeur avec nano comme valeur par défaut
    alias changeeditor='_change_editor() { new_editor=${1:-nano}; export EDITOR=$new_editor; }; _change_editor'

    # Définit l'éditeur par défaut à nano si EDITOR n'est pas défini
    if [ -z "$EDITOR" ]; then
        export EDITOR=nano
    fi

    echo "Les alias ont été définis."
else
    echo -e "\033[31mVeuillez exécuter ce script avec 'source' ou '.'\033[0m"
fi
