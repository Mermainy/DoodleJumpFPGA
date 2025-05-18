from PIL import Image


image = Image.open("Doodle80x80Green.png")
pixels = image.load()

output_file = open("output.sv", 'a', encoding="utf-8")

for y in range(80):
    for x in range(80):
        output_file.write(f"\tdoodle_texture[{y}][{x}] = "
                          f"{{4'b{bin(pixels[x, y][2] // 17)[2:]}, 4'b{bin(pixels[x, y][1] // 17)[2:]}, 4'b{bin(pixels[x, y][0] // 17)[2:]}}};\n")


