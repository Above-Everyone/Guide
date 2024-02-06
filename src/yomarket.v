module src

import os
import src.db

pub struct Guide 
{
	pub mut:
		query 		string
		item_c		int
		raw_items	[]string
		items		[]db.Item

		profile_c	int
		profiles	[]db.Profile
}

pub fn build_guide() Guide 
{
	mut g := Guide{}
	db_v := os.read_lines("assets/db/items.txt") or { [] }
	profile_dir := os.ls("assets/db/profiles/") or { [] }

	if db_v == [] ||  profile_dir == [] {
		println("[ X ] Error, Unable to load databases...!")
		return Guide{}
	}

	g.raw_items = db_v
	println("[ + ] Loading item database...!")

	mut item_c := 0
	for item in db_v
	{
		item_info := g.parse(item)

		/* 
		/ Detecting the following db format line
		/ ('item_name','item_id','item_url','item_price','item_update','is_tradable','is_giftable','in_store','store_price')
		*/

		if item_info.len >= 4 {
			mut new_itm := db.new_item(item_info)
			new_itm.idx = item_c
			g.items << new_itm
			item_c++
		}
	}

	g.item_c = item_c
	g.profile_c = g.profiles.len

	println("[ + ] Item database successfully loaded...!\n[ + ] Loading profile database...!")

	mut c := 0
	for user in profile_dir 
	{
		if user.contains("example") { continue }
		g.profiles << db.new_profile(os.read_file("assets/db/profiles/${user}") or { "" })
		c++
	} 

	println("[ + ] Profiles loaded...!")

	return g
}

pub fn (mut g Guide) save_db() 
{
	mut db_v := os.open_file("assets/db/items.txt", "w") or { os.File{} }
	for mut item in g.items
	{
		db_v.write("${item.to_db()}\n".bytes()) or { 0 }
	}

	db_v.close()
}

pub fn (mut g Guide) add_to_db(mut item db.Item) bool 
{
	mut db_v := os.open_file("assets/db/items.txt", "a") or { return false }
	db_v.write("${item.to_db()}\n".bytes()) or { return false }

	db_v.close()
	return true
}

pub fn (mut g Guide) add_new_profile(args ...string) bool
{
	mut c := db.create()
	if c.username == "" { return false }

	g.profiles << c
	return true
}

fn (mut g Guide) parse(line string) []string
{
	return line.replace("(", "").replace(")", "").replace("'", "").split(",")
}