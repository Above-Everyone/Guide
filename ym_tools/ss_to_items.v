/*
	@title: Invo/Template Screen Shot To Items
	@author: Jeffery/Billy
	@since: 2/5/24
*/
import os

import src
import src.db
import src.utils

fn main() 
{
	mut guide := src.build_guide()
	template_data := os.read_lines("data.txt") or { [] }
	items_updated := []db.Item{}

	mut items_updated_c := 0

	for i, line in template_data
	{
		/* Skip Lines Not Needed Or Empty Lines */
		if line.trim_space().len < 2 || line.trim_space() == "" { continue }

		/* Removing Junk Characters and Splitting Lines for junk removal */
		fixed_name := line.replace("<", "").replace(">", "").replace("_", "").replace("@", "").replace("/", "").replace("~", "").replace("-", "").replace("(", "").replace(")", "")
		line_info := line.split(" ")

		/* Check for item with current line data */
		print("${utils.signal_colored(false)} [${i}/${template_data.len}] Searching Attempt 1/3")
		guide.query = fixed_name // Setting the search query
		mut r := guide.find_by_name() // Looking through items to match

		/* 
			Sometimes the end of item name end up in the next line so 
		   putting them together for more checking 
		   */
		if (r.len == 0 || r.len > 1) && i != template_data.len-1 {
			print(", Attempt 2/3")
			guide.query = "${fixed_name} ${template_data[i+1]}"
			r = guide.find_by_name()

			/* Rechecking removing the Price from the end of line to recheck */
			if (r.len == 0 || r.len > 1) && i != template_data.len-1 {
			print(", Attempt 3/3")
				if line_info.len > 1 {
					guide.query = "${fixed_name}".replace(" ${line_info[line_info.len-1]}", "")
					r = guide.find_by_name()
				}
			}
		}

		/* 
			Checking to see if the item is found
			
			If found, Ask user for new price to set or skips if no price was provided 
			
			OR 

			If a price is found, It will ask you if you want to set the price or set a 
			different price!
		*/
		if r.len == 1 && r[0].is_item_valid() {
			print("\n${utils.signal_colored(true)} [${i}/${template_data.len}] Item Found!\n\t=> \x1b[33m${r[0].item2str(' | ')}\x1b[37m")

			/* A price was found, ask user if they want to set the price on the item */
			if is_price_validate(line_info[line_info.len-1]) {
				new_price := guide.change_price(mut r[0], line_info[line_info.len-1], "5.5.5.5")
				println("\n\t=> A price for the item was found for the item... Setting price => ${line_info[line_info.len-1]}")
				items_updated_c++
				continue
			}

			/* Asking user for price to set on the current item */
			price := os.input("\n\t=> New Price for \x1b[33m${r[0].name}\x1b[37m: ")
			if price != "" {
				new_price := guide.change_price(mut r[0], price, "5.5.5.5")
				items_updated_c++
				continue
			}
		}
		//'Valentines Gift Basket HH ME2019
		println("\n${utils.signal_colored(false)} Failed to find Item. Moving on...!")
	}
	
	println("${utils.signal_colored(true)} ${items_updated_c} Items has been completely updated. Saving db.....!")
	guide.save_db()
	println("${utils.signal_colored(true)} Saved...!")
}

fn is_price_validate(price string) bool
{
	coin_value_type := ['c', 'k', 'm', 'b']
	price_coin_type := price.trim_space()[price.len-1].ascii_str()


	mut actual_value := price.replace(price_coin_type, "")

	if price_coin_type !in coin_value_type {
		return false
	}

	if price.contains(".") {
		actual_value = actual_value.split(".")[0]
	}

	if price.contains("-") {
		actual_value = actual_value.split("-")[1]
	}

	if actual_value.int() > 0 {
		return true
	}

	return false
}