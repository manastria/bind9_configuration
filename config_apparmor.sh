#!/bin/bash

# Chemin vers le fichier de configuration AppArmor pour BIND
APPARMOR_CONF="/etc/apparmor.d/usr.sbin.named"

# Fonction pour ajouter une ligne dans le fichier AppArmor si elle n'existe pas déjà
ajouter_permission() {
    local line=$1
    if ! grep -q "$line" "$APPARMOR_CONF"; then
        sed -i "/^}/i $line" "$APPARMOR_CONF"
    fi
}

# Ajout des permissions pour les zones
ajouter_permission "/etc/bind/zones/ r,"
ajouter_permission "/etc/bind/zones/** rw,"

# Ajout de la permission pour les fichiers de logs
ajouter_permission "/var/log/named/ rw,"
ajouter_permission "/var/log/named/** rw,"

# Redémarre AppArmor pour appliquer les modifications
systemctl restart apparmor
