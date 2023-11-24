#!/bin/bash

# Chemin vers le fichier de configuration AppArmor pour BIND
APPARMOR_CONF="/etc/apparmor.d/usr.sbin.named"

# Lignes à ajouter
LINE1="/etc/bind/zones/ r,"
LINE2="/etc/bind/zones/** rw,"

# Vérifie si les lignes existent déjà
if ! grep -q "$LINE1" "$APPARMOR_CONF"; then
    # Insère $LINE1 avant l'accolade fermante
    sed -i "/^}/i $LINE1" "$APPARMOR_CONF"
fi

if ! grep -q "$LINE2" "$APPARMOR_CONF"; then
    # Insère $LINE2 avant l'accolade fermante
    sed -i "/^}/i $LINE2" "$APPARMOR_CONF"
fi

# Redémarre AppArmor pour appliquer les modifications
systemctl restart apparmor
