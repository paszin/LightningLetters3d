import os
import string

command = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/letterbox_{letter}.stl -D \"letter=\"{letter}\"\" letterboxes.scad"


for letter in string.ascii_uppercase:
    print(command.format(letter=letter))
    os.system(command.format(letter=letter))

    
print(os.listdir("./export"))
