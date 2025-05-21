import os
from pathlib import Path

from PIL import Image


PROJECT_DIR = Path('./')  # .resolve()
SPRITES_DIR = PROJECT_DIR / 'Sprites'
TEXTURES_DIR = PROJECT_DIR / 'Design' / 'textures'

QUARTUS_PROJECT_FILE = next(PROJECT_DIR.glob('*.qpf'), None)
QUARTUS_SETTINGS_FILE = next(PROJECT_DIR.glob('*.qsf'), None)


assert QUARTUS_PROJECT_FILE is not None, f'Quartus project file not found in "{PROJECT_DIR}"'
assert QUARTUS_SETTINGS_FILE is not None, f'Quartus settings file not found in "{PROJECT_DIR}"'
TEXTURES_DIR.mkdir(parents=True, exist_ok=True)


def main():
    for image_path in SPRITES_DIR.glob('*.png'):
        image_name_raw = image_path.stem
        image_name_components = image_name_raw.split(' ')

        # if len(image_name_components) != 4:
        #     log.warning(f'Wrong image naming convention detected "{image_path}". Skipping...')
        #     continue

        entity_name = f'{image_name_components[0]}_{image_name_components[-1]}'
        entity_name_rgb = f'{entity_name}_rgb'
        entity_name_alpha = f'{entity_name}_alpha'
        macro_name = f'INITIAL_{entity_name.upper()}'
        image_expected_width, image_expected_height = map(
            int, image_name_components[1].split('x'))

        image = Image.open(image_path)
        pixels = image.load()
        assert image_expected_height == image.height
        assert image_expected_width == image.width

        target_path = TEXTURES_DIR / f'{entity_name}.sv'

        template_banner = (
            f'// Module definition:\n'
            f'// logic [{image.height-1}:0][{image.width-1}:0][2:0][3:0] {entity_name_rgb};\n'
            f'// logic [{image.height-1}:0][{image.width-1}:0][2:0][3:0] {entity_name_alpha};'
        )
        template_header = (
            f'`ifndef {macro_name}\n\n{template_banner}\n\n'
            f'`define {macro_name} \\\nalways_comb begin \\'
        )
        template_footer = f'end\n\n`endif // {macro_name}\n'

        # Construct template
        file_lines = []
        file_lines.append(template_header)
        for y in range(image.height):
            for x in range(image.width):
                file_lines.append(
                    f"\t{entity_name_rgb}[{y}][{x}] = "
                    f"{{4'b{bin(pixels[x, y][2] // 17)[2:]}, "
                    f"4'b{bin(pixels[x, y][1] // 17)[2:]}, "
                    f"4'b{bin(pixels[x, y][0] // 17)[2:]}}}; \\"
                )
        
        for y in range(image.height):
            for x in range(image.width):
                file_lines.append(
                    f"\t{entity_name_alpha}[{y}][{x}] "
                    f"= 1'b{int(not bool(pixels[x, y][3]))}; \\"
                )
        file_lines.append(template_footer)

        # Render filled template to the SystemVerilog file
        target_path.write_text('\n'.join(file_lines))

        update_quartus_settings_file(target_path)


def update_quartus_settings_file(generated_filepath: Path):
    qsf_content = QUARTUS_SETTINGS_FILE.read_text()

    if generated_filepath.name not in qsf_content:
        qsf_content += f'\nset_global_assignment -name SYSTEMVERILOG_FILE {generated_filepath.as_posix()}\n'
        QUARTUS_SETTINGS_FILE.write_text(qsf_content)
        print(f'File {generated_filepath} appended to the Quartus Settings file.')
        print(f'Please, manually edit {QUARTUS_SETTINGS_FILE} and move included file BEFORE file with macro usage.')
        print('Order of "set_global_assigment" file names in settings REALLY MATTERS!')


if __name__ == '__main__':
    main()
