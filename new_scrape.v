import net.http

import src
import src.items

struct Scraper
{
	pub mut:
		max_pages 		int
		current_page	int

		raw_items		[]string
		items			[]items.Item
}

const (
	page_url = "https://yoworlddb.com/items/page/"
)

fn main() 
{
	mut scraper := build_scraper()
	scraper.start_scraping()

	mut guide := src.build_guide()
	guide.items = scraper.items
	guide.save_db()
}

fn build_scraper() Scraper 
{
	check_main_page := http.get_text("${page_url}")
	lines := check_main_page.split("\n")

	mut latest_line := 0
	for line in lines 
	{
		if line.trim_space().starts_with("<option value=\"") && line.trim_space().contains(" >") 
		{
			line_args := line.trim_space().split(" ")

			if line_args.len < 1 { continue }
			if line_args[1].starts_with("value=\"") && line_args[1].ends_with("\"") {
				latest_line = line_args[1].replace("value=", "").replace("\"", "").int()
			}
		}
	}

	if latest_line > 0 {
		return Scraper{ max_pages: latest_line }
	}

	return Scraper{}
}

fn (mut s Scraper) start_scraping() 
{
	for i in 0..(s.max_pages) 
	{
		s.current_page = i
		content := http.get_text("${page_url}${i}")
		s.scrape_page(content, i)
	}
}

fn (mut s Scraper) scrape_page(content string, page_c int)
{
	page_lines := content.split("\n")

	mut page_line_c := 0
	mut item_c := 0
	for line in page_lines 
	{
		if line.trim_space().starts_with("<div data=\"") && line.trim_space().ends_with("class=\"item\">")
		{
			item_url := "https://yw-web.yoworld.com/cdn/items/" + page_lines[page_line_c+1].trim_space().replace("<a class=\"item-image\" href=\"\" data=\"", "").replace("\"></a>", "")
			item_name := page_lines[page_line_c+3].trim_space().replace("</a>", "").replace("~", "").trim_space()
			item_id := page_lines[page_line_c+1].trim_space().replace("<a class=\"item-image\" href=\"\" data=\"", "").replace("\"></a>", "").split("/")[3].replace("_60_60.gif", "")
			println("Page: ${page_c} => Item [${item_c}] Info: ${item_name} | ${item_id} | ${item_url}")
			mut new_itm := items.new([item_name, item_id, item_url, "", ""])
			new_itm.idx = item_c
			s.items << new_itm
			item_c++
		}
		page_line_c++
	}
}