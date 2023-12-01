#!/bin/bash

# Fonction pour afficher la documentation
show_documentation() {
    echo "Documentation :"
    echo "  - editnamed.local : Éditer /etc/bind/named.conf.local avec l'éditeur défini."
    echo "  - editnamed.options : Éditer /etc/bind/named.conf.options avec l'éditeur défini."
    echo "  - changeeditor : Changer l'éditeur (nano par défaut). Usage: changeeditor [nom de l'éditeur]"
}

# Helper function
# src : https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
is_sourced() {
    if [ -n "$ZSH_VERSION" ]; then 
        case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
    else  # Add additional POSIX-compatible shell names here, if needed.
        case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
    fi
    return 1  # NOT sourced.
}

# Sample call.
is_sourced && sourced=1 || sourced=0

# Vérifie si le script est exécuté avec 'source' ou '.'
# Dans ce cas, le PID du shell (bash ou zsh) sera égal au PPID du script
if [ $sourced -eq 1 ]; then
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
    show_documentation
else
    echo -e "\033[31mVeuillez exécuter ce script avec 'source' ou '.'\033[0m"
fi
