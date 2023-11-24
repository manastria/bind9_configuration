#!/bin/bash

# Vérifiez si le script est exécuté avec des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root"
   exit 1
fi

# Vérifiez si un nom de domaine est passé en paramètre
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <nomdedomaine>"
    exit 1
fi

DOMAIN=$1

# Créez et configurez le répertoire pour le domaine
ZONE_DIR="/etc/bind/zones/$DOMAIN"
mkdir -p "$ZONE_DIR"
if [ $? -ne 0 ]; then
    echo "La création du répertoire $ZONE_DIR a échoué"
    exit 1
fi
chown bind:bind "$ZONE_DIR"
chmod 750 "$ZONE_DIR"

# Créez et configurez le répertoire pour les journaux
mkdir -p /var/log/named/
chown bind:bind /var/log/named/

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

echo "Configuration des répertoires et des permissions pour $DOMAIN terminée."
