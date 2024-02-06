import requests, os

from PIL import Image, ImageDraw, ImageOps, ImageFont

class Combine():
    username:   str;
    imgs:       str;
    cols:       int;
    spaces:     int;

    def __init__(self, username: str, images: list[str], columns: int = 3, spaces: int = 5):
        self.username = username

        if username == "": 
            self.username = "billy"

        self.imgs = images
        self.cols = columns
        self.spaces = spaces

        self.combine_images()
        self.add_text()
        self.clean_up()

    def combine_images(self):
        print(self.imgs)
        rows = len(self.imgs) // self.cols
        if len(self.imgs) % self.cols:
            rows += 1
        width_max = max([Image.open(f"assets/generator/{image}").width for image in self.imgs])
        height_max = max([Image.open(f"assets/generator/{image}").height for image in self.imgs])
        background_width = width_max*self.cols + (self.spaces*self.cols)-self.spaces
        background_height = height_max*rows + (self.spaces*rows)-self.spaces
        print(f"{background_height}")
        background = Image.new('RGBA', (background_width, background_height+30), (255, 255, 255, 255))
        x = 0
        y = 0
        for i, image in enumerate(self.imgs):
            img = Image.open(f"assets/generator/{image}")
            img.resize((200, 200))
            x_offset = int((width_max-img.width)/2)*4
            y_offset = int((height_max-img.height)/2)
            background.paste(img, (x+x_offset, y+y_offset))
            x += width_max + self.spaces
            if (i+1) % self.cols == 0:
                y += height_max + self.spaces
                x = 0
        background.save('assets/generator/image.png')
    
    def add_text(self):
        img = Image.open('assets/generator/image.png')
        I1 = ImageDraw.Draw(img)
        
        label   = f"Created With YoMarket.Info // Created By YoMarket.info/@{self.username}"
        data    = label.center( int(int(img.width)/2 - int(img.width/3)))
        gg = Image.new("RGBA", (img.width+10, img.height+10), (255, 255, 255))
        gg.paste(img,(10//2, 10//2))
        
        b = ImageDraw.Draw(gg)
        font_img = ImageFont.truetype('assets/generator/font.ttf', 20)

        b.text((0, 
                 int(img.height-15)), 
                 data, 
                 fill=(255, 0, 0), 
                 font=font_img )

        gg.save("template.png")

    def clean_up(self) -> None:
        os.remove("assets/generator/image.png")
        for iid in self.imgs: 
            os.remove(f"assets/generator/{iid}")