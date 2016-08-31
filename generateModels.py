import os
import string

command = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/light{component}_{letter}.stl -D \"letter=\\\"{letter}\\\"\" -D \"component=\\\"{component}\\\"\" letterboxes.scad"

signs = string.ascii_uppercase + '1234567890' + '!@#$%*?-_.'

for component in ['box', 'letter']:
	for letter in signs:
	    print(command.format(letter=letter, component=component))
	    os.system(command.format(letter=letter, component=component))

print(os.listdir("./export"))
