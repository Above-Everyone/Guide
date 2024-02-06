"""
        YoMarket's Item Box Creator

    @title: Item Box Creator
    @description: Downloads an item image and create a new box to paste the
                  item image ontop of the new blank box image with item name
                  and price text
    @author: Jeffery/Billy
    @since: 2/3/24 
"""

import requests, pyautogui, os
from PIL import Image, ImageDraw, ImageOps, ImageFont

from yomarket import *

class ItemBoxCreator():
    ids:        list[str];
    results:    list[str];
    c_id:       str;
    price:      str;

    def __init__(self, item_ids: list[str]):
        self.ids = item_ids
        self.download_images()

    def download_images(self) -> None:
        for item_id in self.ids:
            if item_id == "": continue
            search_for_item = Items(item_id.split(":")[0]).searchItem(item_id, "5.5.5.5")
            if search_for_item.r_type == ResponseType.EXACT:
                self.c_id = item_id.split(":")[0]
                self.price = item_id.split(":")[1]
                self.item = search_for_item.results

                self.download(search_for_item.results.url)
            else:
                print(f"[ X ] Error, Unable to find item => {item_id}")
            
    def download(self, url) -> None:
        img_data = requests.get(url).content
        file = open(f"assets/generator/{self.c_id}.png", "wb")
        file.write(img_data)
        file.close()
        self.create_empty_box_n_add_item_image()

    def create_empty_box_n_add_item_image(self) -> None:
        columns, space, images =  [3, 20, [f"{self.c_id}.png"]]
        rows = len(images) // columns

        if len(images) % columns:
            rows += 1

        width_max = max([Image.open(f"assets/generator/{image}").width for image in images])
        height_max = max([Image.open(f"assets/generator/{image}").height for image in images])
        background_width = width_max*columns + (space*columns)-space
        background_height = height_max*rows + (space*rows)-space
        background_width -= int(background_width/2+width_max/2)
        background_height += 50

        background = Image.new('RGBA', (background_width, background_height), (255, 255, 255, 255))
        x = 10
        y = 10
        for i, image in enumerate(images):
            img = Image.open(f"assets/generator/{image}")
            x += 0
            y += 0
            img.resize((250, 250))
            x_offset = int((width_max-img.width)/2)*4
            y_offset = int((height_max-img.height)/2)
            background.paste(img, (x+x_offset, y+y_offset))
            x += width_max + space
            if (i+1) % columns == 0:
                y += height_max + space
                x = 0
        background.save(f'assets/generator/{self.c_id}.png')
        self.add_text(self.item.name, self.price)

    """
        Creating a plain white box to slap the item image with space for
        item name and WTB/FS price
    """
    def add_text(self, data: str, price: str) -> None:
        """ Open item image """
        img     = Image.open(f'assets/generator/{self.c_id}.png')
        img     = img.resize((260, 260)) # Resizing item image
        I1      = ImageDraw.Draw(img)
        W, H    = img.size

        """ 
            Formatting Strings with whitespaces on both sides to
            fill the string to fit the image width centered and
            setting a font with size
        """
        fixed_price = f"Price: {price}"
        centered_name   = data.center( int(int(img.width)/2 - int(img.width/3)) )
        centered_price  = fixed_price.center( int(int(img.width)/2 - int(img.width/3) + len(fixed_price)*3) )
        font_img = ImageFont.truetype('assets/generator/font.ttf', 20)
        price_size = ImageFont.truetype('assets/generator/font.ttf', 15)
        
        """
            Writing the item name and price onto the item image
        """
        I1.text((0, 
                int(img.height / 2 + img.height / 3 + 5)),
                centered_name, 
                fill=(0, 0, 0),
                font=font_img,
                align="center");
        
        I1.text((0, 
                int(img.height / 2 + img.height / 3 + 25)), 
                centered_price, 
                fill=(0, 0, 0),
                font=price_size ,
                align="center");

        """
            Adding the item image to the new blank black image
        """
        gg = Image.new("RGBA", (img.width+10, img.height+10), (0, 0, 0))
        gg.paste(img,(10//2, 10//2)) # Pasting Item Image 

        """ Save Item Image Box """
        gg.save(f"assets/generator/{self.c_id}.png")