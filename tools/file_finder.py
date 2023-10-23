# modules
import os

# morslonga copy directory
content = os.getenv("userprofile") + "\\Documents\\Teardown\\mods\\Mors Longa Copy"

# clean cmd and set title
os.system("title MorsWare Tools - File Finder")
os.system("cls")

# search term and file extension
search_term = input("Enter a search term : ")
file_extension = input("Enter file extension : ")
search_inside_files = input("Do you want to search inside the files too? (y, n) : ") == "y"

# start searching for file
print()
if search_term != "" and file_extension != "":
    for root, directories, files in os.walk(content):
        for file in files:
            if file.endswith(file_extension):
                file_path = os.path.join(root, file)
                
                if search_term in file:
                    print(file_path)
                    
                if search_inside_files:
                    with open(file_path, "rb") as file_handle:
                        file_content = file_handle.read()
                        file_handle.close()
                
                    if search_term.encode("utf-8") in file_content:
                        print(file_path)
else:
    print("Invalid search term or file extension.")

# exit
print("\nPress enter to exit...")
input()
