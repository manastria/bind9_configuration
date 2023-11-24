import re
import sys

def update_serial(zone_file_path):
    with open(zone_file_path, 'r') as file:
        zone_data = file.readlines()

    serial_regex = r'(\s*\d+\s*; Serial)'
    new_zone_data = []
    serial_updated = False

    for line in zone_data:
        if re.search(serial_regex, line) and not serial_updated:
            parts = re.split(r'(\s+)', line)
            serial = int(parts[0]) + 1
            parts[0] = str(serial)
            new_line = ''.join(parts)
            new_zone_data.append(new_line)
            serial_updated = True
        else:
            new_zone_data.append(line)

    if serial_updated:
        with open(zone_file_path, 'w') as file:
            file.writelines(new_zone_data)
        print(f"Serial number updated in {zone_file_path}")
    else:
        print("Serial number not found in the file.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python update_serial.py <zone_file_path>")
    else:
        update_serial(sys.argv[1])
