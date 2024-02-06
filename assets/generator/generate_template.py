import os, sys

from box_creator        import *
from combine            import *

if not os.path.exists("assets/generator//template_data.txt"):
    print(f"[ X ] Error, Missing 'template_data.txt' to create templates!")

def fix_data_2_combine(data: list[str]) -> list[str]:
    new_arr = []

    for temp_item in data:
        new_arr.append(f"{temp_item.split(":")[0]}.png")

    return new_arr

template_items = open("assets/generator/template_data.txt", "r").read().split("\n")

template_data = template_items[0].strip().split(",")
username = template_items[1].strip()

fixed = fix_data_2_combine(template_data);
ItemBoxCreator(template_data);
Combine("Billy", fixed, columns = 3, spaces = 5)

os.remove("assets/generator/template_data.txt")
print("DONE")