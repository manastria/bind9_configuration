#!/usr/bin/env python3

import re
import sys
from datetime import datetime

def update_serial(zone_file_path):
    with open(zone_file_path, 'r') as file:
        zone_data = file.readlines()

    today = datetime.now().strftime("%Y%m%d")
    serial_regex = r'(\d{8})(\d{2})\s*;\s*Serial'
    new_zone_data = []
    serial_updated = False
    old_serial = None
    new_serial = None

    for line in zone_data:
        match = re.search(serial_regex, line)
        if match and not serial_updated:
            current_date, sequence = match.groups()
            old_serial = f"{current_date}{sequence}"
            if current_date == today:
                sequence = str(int(sequence) + 1).zfill(2)
            else:
                sequence = "00"
            new_serial = f"{today}{sequence}"
            new_line = re.sub(serial_regex, new_serial + r" ; Serial", line)
            new_zone_data.append(new_line)
            serial_updated = True
        else:
            new_zone_data.append(line)

    if serial_updated:
        with open(zone_file_path, 'w') as file:
            file.writelines(new_zone_data)
        print(f"Serial number updated in {zone_file_path}")
        print(f"Old Serial: {old_serial}")
        print(f"New Serial: {new_serial}")
    else:
        print("Serial number not found in the file.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python update_serial.py <zone_file_path>")
    else:
        update_serial(sys.argv[1])
