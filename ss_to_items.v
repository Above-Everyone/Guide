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
		if line.trim_space().len < 2 || line.trim_space() == "" { continue }
		fixed_name := line.replace("<", "").replace(">", "").replace("_", "").replace("@", "").replace("/", "").replace("~", "").replace("-", "").replace("(", "").replace(")", "")

		// mut r := guide.search(fixed_name, false)

		guide.query = fixed_name
		mut r := guide.find_by_name()

		// println("${i} | ${fixed_name}${template_data[i+1]}")
		if (r.len == 0 || r.len > 1) && (i != template_data.len || i != template_data.len-1) {
			// r = guide.search("${fixed_name} ${template_data[i+1]}", false)
			guide.query = "${fixed_name} ${template_data[i+1]}"
			r = guide.find_by_name()
		}

		if r.len == 1 {
			println("${utils.signal_colored(true)} Item Found! => ${r[0].to_db()}")
			price := os.input("New Price: ")
			if price == "" { continue }
			new_price := guide.change_price(mut r[0], price, "5.5.5.5")
		}

		// if is_price_validate(fixed_name) or { false } {
		// 	println("${utils.signal_colored(true)} Price Found! => ${line}")
		// }
	}

	guide.save_db()
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