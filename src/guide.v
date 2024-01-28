module src

import os
import src.items
import src.profiles

pub struct Guide 
{
	pub mut:
		query 		string
		item_c		int
		raw_items	[]string
		items		[]items.Item

		profile_c	int
		profiles	[]profiles.Profile
}

pub enum ResultType
{
	_none					= 0
	_exact 					= 1
	_extra 					= 2
	_item_failed_to_update	= 3
	_item_updated			= 4
}

pub struct Response
{
	pub mut:
		r_type		ResultType
		results		[]items.Item
}

pub fn result_t(res_t ResultType) string
{
	match res_t
	{
		._exact {
			return "ResultType._exact"
		}
		._extra {
			return "ResultType._extra"
		}
		._item_failed_to_update {
			return "ResultType._item_failed_to_update"
		}
		._item_updated {
			return "ResultType._item_updated"
		} else {}
	}
	return ""
}


pub fn build_guide() Guide 
{
	mut g := Guide{}
	db := os.read_lines("db/items.txt") or { [] }
	profile_dir := os.ls("db/profiles/") or { [] }

	if db == [] ||  profile_dir == [] {
		println("[ X ] Error, Unable to load databases...!")
		return Guide{}
	}

	g.raw_items = db
	println("[ + ] Loading item database...!")

	mut item_c := 0
	for item in db
	{
		item_info := g.parse(item)

		/* 
		/ Detecting the following db format line
		/ ('item_name','item_id','item_url','item_price','item_update','is_tradable','is_giftable','in_store','store_price')
		*/

		if item_info.len >= 4 {
			mut new_itm := items.new(item_info)
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
		g.profiles << profiles.new(os.read_file("db/profiles/${user}") or { "" })
		c++
	} 

	println("[ + ] Profiles loaded...!")

	return g
}

pub fn (mut g Guide) save_db() 
{
	mut db := os.open_file("db/items.txt", "w") or { os.File{} }
	for line in g.raw_items
	{
		db.write("${line}\n".bytes()) or { 0 }
	}

	db.close()
}

pub fn (mut g Guide) add_to_db(mut item items.Item) bool 
{
	mut db := os.open_file("db/items.txt", "a") or { return false }
	db.write("${item.to_db()}\n".bytes()) or { return false }

	db.close()
	return true
}

pub fn (mut g Guide) add_new_profile(args ...string) bool
{
	mut c := profiles.create()
	if c.username == "" { return false }

	g.profiles << c
	return true
}

fn (mut g Guide) parse(line string) []string
{
	return line.replace("(", "").replace(")", "").replace("'", "").split(",")
}