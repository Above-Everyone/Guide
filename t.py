"""
    Yoworld Player ID Validator

    Page status code returns 200 on a valid player ID & 404 on a invalid player ID
"""
import requests

r = requests.get("https://yw-web.yoworld.com/user/images/yo_outfits/000/187/753/187753659/12261591.png")

print(f"{r.status_code}")