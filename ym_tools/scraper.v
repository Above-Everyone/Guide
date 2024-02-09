/*

	@title: Yoworld Item Scraper
	@description: Scrape all items using Yoworlddb.com's 'All items' page
	@author: Jeffery
	@since: 2/2/24
*/
import src
import src.db
import src.utils

import os
import net.http

pub struct Scraper
{
	pub mut:
		raw_items	string
		items		[]db.Item
		max_pages	int
		c_page		int
}

const (
	url = "https://yoworlddb.com/items/page/"
)

fn main() 
{
	mut s := start_scraper()
	s.scrape()
	// os.write_file("test.txt", "${s.items}".replace("['", "").replace("']", "").replace("', '", "\n")) or { println("Failed") 
	// 	return }
	s.merge_n_save()
}

/*
	Getting the page count to iterate through
*/
fn start_scraper() Scraper
{
	mut s := Scraper{}
	data := http.get_text(url)
	lines := data.split("\n")

	for line in lines 
	{
		if line.contains("<option value=")
		{
			args := line.trim_space().split(" ")

			if args.len > 1 {
				if args[1].starts_with("value=\"") { s.max_pages = args[1].replace("value=", "").replace("\"", "").int() }
			}
		}
	}
	
	println("${s.max_pages}")
	return s
}

/*
	Iterating through pages to scrape
*/
fn (mut s Scraper) scrape() 
{
	for page_num in 4355..s.max_pages+1
	{
		// println("${url}${page_num}")
		page_data := http.get_text("${url}${page_num}")
		s.c_page = page_num
		go s.scrape_page_data(page_data)
	}
}

/*
	Scraping the entire page for item information
*/
fn (mut s Scraper) scrape_page_data(content string) 
{
	lines := content.split("\n")

	mut new_item := db.Item{}
	for i, line in lines 
	{
		if line.trim_space().contains("<div data=\"") && line.trim_space().ends_with("\" class=\"item\">")
		{
			item_id := line.trim_space().replace("<div data=\"", "").replace("\" class=\"item\">", "").trim_space()
			new_item.id = item_id.int()
			new_item.url = "https://yw-web.yoworld.com/cdn/items/${item_id[0..2]}/${item_id[2..4]}/${item_id}/${item_id}_60_60.gif"
			// println("Item ID: " + line.trim_space().replace("<div data=\"", "").replace("\" class=\"item\">", "").trim_space()) // Debugging
		} else if line.trim_space().contains("<a class=\"item-name\" href=\"\">")
		{
			new_item.name = lines[i+1].trim_space().replace("<div data=\"", "").replace("</a>", "").trim_space()
			// println("Item Name: " + lines[i+1].trim_space().replace("<div data=\"", "").replace("</a>", "").trim_space()) // Debugging
		}
		
		if new_item.name != "" {
			s.raw_items += "${new_item.to_db()}\n"
			s.items << new_item
			println("${utils.signal_colored(true)} Page: ${s.c_page}/${s.max_pages}:${i} [${s.items.len}] | Item #${i} Added\n\t=> ${new_item.to_db()}")

			new_item = db.Item{}
		} else {
			// println("${utils.signal_colored(false)} Page: ${s.c_page}/${s.max_pages}:${i} [${s.items.len}] | Invalid Item\n\t=> ${new_item.to_db()}")
		}
	}
}

/*
	Merge into YoMarket's Database and Save
*/
fn (mut s Scraper) merge_n_save()
{
	mut guide := src.build_guide()

	for mut item in s.items
	{
		guide.query = "${item.name}"
		check := guide.find_by_name()
		if check.len == 0 {
			guide.items << item
		} else {
			println("${utils.signal_colored(false)} Page: ${s.c_page}/${s.max_pages}: [${s.items.len}] | Invalid Item\n\t=> ${item.to_db()}")
		}
	}

	guide.save_db()
}