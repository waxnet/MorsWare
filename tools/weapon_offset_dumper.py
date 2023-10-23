# modules
import os

# morslonga copy directory and data container
content = os.getenv("userprofile") + "\\Documents\\Teardown\\mods\\Mors Longa Copy\\script"
data = {}

# clean cmd and set title
os.system("title MorsWare Tools - Weapon Offset Dumper")
os.system("cls")

# parse data from files
print("Parsing data...")
for file in os.listdir(content):
    if file.endswith(".lua"):
        script_path = os.path.join(content, file)
        
        with open(script_path, "rb") as script:
            script_lines = script.readlines()
            script.close()
        
        data_key = ""
        for line in script_lines:
            if b"RegisterTool" in line and data_key == "":
                data_parts = line.split(b"\"")
                
                if len(data_parts) >= 4:
                    data_key = line.split(b"\"")[3].decode()
        
            if (
                b"gunpos" in line and
                b"TransformToParentPoint" in line and
                b"Vec" in line and
                not b"barrelx" in line and
                data_key != ""
            ):
                data[data_key] = line.split(b"Vec")[1].decode()
                break

# dump data
print("Dumping data...")
with open("offsets.lua", "w+") as dump:
    parsed_data = str(data).replace("'(", "{").replace("))\\r\\n'", "}").replace("':", "\"] =").replace("'", "[\"")

    dump.write(f"offsets = {parsed_data}")
    dump.close()

# exit
print("\nPress enter to exit...")
input()
