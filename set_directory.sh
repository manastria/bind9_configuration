#!/bin/bash

# Vérifiez si le script est exécuté avec des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root"
   exit 1
fi

# Créez et configurez le répertoire pour les clés
KEYS_DIR="/etc/bind/keys"
mkdir -p "$KEYS_DIR" && cd "$KEYS_DIR"
if [ $? -ne 0 ]; then
    echo "La création ou le changement de répertoire vers $KEYS_DIR a échoué"
    exit 1
fi
chown bind:bind /etc/bind/keys/K*.key /etc/bind/keys/K*.private 2>/dev/null
chmod 400 /etc/bind/keys/K*.private 2>/dev/null
chmod 440 /etc/bind/keys/K*.key 2>/dev/null
chown bind:bind "$KEYS_DIR"
chmod 550 "$KEYS_DIR"

# Créez et configurez le répertoire pour les journaux
mkdir -p /var/log/named/
chown bind:bind /var/log/named/

# Permissions des fichiers de zone

find "/etc/bind/zones" -type f -exec chmod 640 {} \; -type d -exec chmod 750 {} \; -exec chown bind:bind {} \;

# Fichier de configuration
chown bind:bind /etc/bind/named.conf*
chmod 640 /etc/bind/named.conf*
