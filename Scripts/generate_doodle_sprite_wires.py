import os

from PIL import Image


image_path = "Doodle80x80GreenLeft.png"
entity_name = "doodle_left"

image = Image.open(image_path)
pixels = image.load()

try:
    os.unlink("output_color.sv")
    os.unlink("output_transparency.sv")
except FileNotFoundError:
    pass

output_file_color = open("output_color.sv", 'a', encoding="utf-8")
output_file_transparency = open("output_transparency.sv", 'a', encoding="utf-8")

for y in range(image.height):
    for x in range(image.width):
        output_file_color.write(f"\t{entity_name}_texture[{y}][{x}] = "
                          f"{{4'b{bin(pixels[x, y][2] // 17)[2:]}, "
                                f"4'b{bin(pixels[x, y][1] // 17)[2:]}, "
                                f"4'b{bin(pixels[x, y][0] // 17)[2:]}}};")
for y in range(image.height):
    for x in range(image.width):
        output_file_transparency.write(f"\t{entity_name}_transparency[{y}][{x}] = {int(not bool(pixels[x, y][3]))};")


