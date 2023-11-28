#!/bin/bash

# Chemin vers le fichier de configuration principal de BIND et le fichier de log
NAMED_CONF="/etc/bind/named.conf"
NAMED_CONF_LOG="/etc/bind/named.conf.log"

# Vérifier si le fichier named.conf.log existe et le créer le cas échéant
if [ ! -f "$NAMED_CONF_LOG" ]; then
    cat > "$NAMED_CONF_LOG" <<- EOF
    logging {
        channel default_debug {
            file "/var/log/named/named.run";
            severity dynamic;
        };
        channel queries_log {
            file "/var/log/named/queries.log" versions 3 size 100m;
            severity info;
            print-time yes;
        };
        channel dnssec_log {
            file "/var/log/named/dnssec.log" versions 3 size 100m;
            severity debug;
            print-time yes;
        };
        channel sync_log {
            file "/var/log/named/sync.log" versions 3 size 100m;
            severity info;
            print-time yes;
        };
        category default { default_debug; };
        category queries { queries_log; };
        category dnssec { dnssec_log; };
        category xfer-in { sync_log; };
        category xfer-out { sync_log; };
        category notify { sync_log; };
    };
    EOF
fi

# Vérifier si named.conf contient déjà une référence au fichier de log
if ! grep -q 'include "/etc/bind/named.conf.log";' "$NAMED_CONF"; then
    echo 'include "/etc/bind/named.conf.log";' >> "$NAMED_CONF"
fi
