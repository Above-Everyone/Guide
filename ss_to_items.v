import os

import src
import src.db
import src.utils

fn main() 
{
	mut guide := src.build_guide()
	template_data := os.read_lines("data.txt") or { [] }

	for i, line in template_data
	{
		/* Skip Lines Not Needed Or Empty Lines */
		if line.trim_space().len < 2 || line.trim_space() == "" { continue }

		/* Removing Junk Characters and Splitting Lines for junk removal */
		fixed_name := line.replace("<", "").replace(">", "").replace("_", "").replace("@", "").replace("/", "").replace("~", "").replace("-", "").replace("(", "").replace(")", "")
		line_info := line.split(" ")

		/* Check for item with current line data */
		guide.query = fixed_name // Setting the search query
		mut r := guide.find_by_name() // Looking through items to match

		/* Sometimes the end of item name end up in the next line so 
		   putting them together for more checking */
		if (r.len == 0 || r.len > 1) && i != template_data.len-1 {
			guide.query = "${fixed_name} ${template_data[i+1]}"
			r = guide.find_by_name()

			/* Rechecking removing the Price from the end of line to recheck */
			if r.len == 0 || r.len > 1 {
				if line_info.len > 1 {
					guide.query = "${fixed_name}".replace(" ${line_info[line_info.len-1]}", "")
					r = guide.find_by_name()
				}
			}
		}

		/* Item found, Ask user for new price to set or skips if no price was provided */
		if r.len == 1 && r[0].is_item_valid() {
			println("${utils.signal_colored(true)} Item Found! => ${r[0].to_db()}")
			price := os.input("New Price: ")
			if price != "" {
				new_price := guide.change_price(mut r[0], price, "5.5.5.5")
			}
		}
	}
	
	println("${utils.signal_colored(true)} Item found were all completely updated. Saving db.....!")
	guide.save_db()
	println("${utils.signal_colored(true)} Saved...!")
}

fn is_price_validate(price string) !bool
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