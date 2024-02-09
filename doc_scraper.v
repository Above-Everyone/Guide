import net.http

import src
import src.db
import src.utils

fn main() 
{
	mut guide := src.build_guide()
	info := http.get_text("https://docs.google.com/spreadsheets/u/0/d/e/2PACX-1vQRR3iveCH4Y1pdxWCAzW7qchTlHYzvlNG6e6ZyMKn2vjodu8-uLSoAHSLMq1X3qA/pubhtml?fbclid=IwAR2rygpKEE2Qx2e8NCOVYHGzkqzJK6h1soUFm_6IwVdK6Tva1AMi6a1F3X0&pli=1")

	lines := info.split(">")

	mut td_count := 0
	mut r := []db.Item{}
	mut item := db.Item{}
	mut i_name := ""
	for i, line in lines
	{
		if i == lines.len-1 { break }
		fixed_line := remove_string(line.trim_space(), ['</div', '</tr', '</th'])

		/* Ignore 'Code', 'Name', 'Price', 'Date' */
		if is_str(fixed_line.replace("</td", ""), ['Code', 'Name', 'Price', 'Date', '</td']) { continue }

		/* Item Found */
		if fixed_line.ends_with("</td") {
			// println("${utils.signal_colored(true)} Searching Attempt 1/2 \"" + fixed_line.replace("</td", "") + '"')

			guide.query = fixed_line.replace("</td", "").trim_space()
			r = guide.find_by_name()
				
			if r.len == 1 && r[0].name != "" {
				println("${utils.signal_colored(true)} Item Found\n\t=>${r[0].item2str(' | ')}\n\t=>") 
				item = r[0]
			} else if ends_with_bulk(line.to_lower().replace("</td", ""), ['c', 'k', 'm', 'b']) {
				println("${utils.signal_colored(true)} Price Found\n\t=> " + lines[i].trim_space().replace("</td", ""))
				guide.change_price(mut item, lines[i].trim_space().replace("</td", ""), "5.5.5.5")
			}
			// println("${utils.signal_colored(true)} ${td_count} Found Possibly: " + fixed_line.replace("</td", ""))
		}
		// println(fixed_line)
	}
	guide.save_db()
}

fn ends_with_bulk(line string, arr []string) bool 
{
	for i in arr { if line.trim_space().ends_with("${i}") { return true } }
	return false
}

fn is_str(line string, arr []string) bool
{
	for i in arr { if line.trim_space() == "${i}" { return true } }
	return false
}

fn remove_string(line string, arr []string) string 
{
	mut new := line
	for i in arr { new = new.replace(i, "") }
	return new
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