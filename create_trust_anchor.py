import sys

def read_key_file_and_create_trust_anchor(file_path):
    try:
        with open(file_path, 'r') as file:
            for line in file:
                if "IN DNSKEY" in line:
                    parts = line.split()
                    if len(parts) >= 7 and parts[3] == "257":
                        domain_name = parts[0]
                        flag = parts[3]
                        algo = parts[4]
                        key_length = parts[5]
                        public_key = " ".join(parts[6:])  # Joindre toutes les parties de la clé publique
                        print(f'trust-anchors {{"{domain_name}" initial-key {flag} {algo} {key_length} "{public_key}";}};')
                        return
                    else:
                        print("La clé n'est pas une KSK (flag différent de 257) ou format non valide.")
            print("Aucune clé DNSKEY trouvée dans le fichier.")
    except FileNotFoundError:
        print("Fichier non trouvé.")
    except Exception as e:
        print(f"Erreur lors de la lecture du fichier : {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python create_trust_anchor.py <chemin_du_fichier_key>")
    else:
        file_path = sys.argv[1]
        read_key_file_and_create_trust_anchor(file_path)
