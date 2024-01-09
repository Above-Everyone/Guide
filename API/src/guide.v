module src

import os
import src.items
import src.profiles

pub struct Guide 
{
	pub mut:
		item_c		int
		items		[]items.Item

		profile_c	int
		profiles	[]profiles.Profile
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

	println("[ + ] Loading item database...!")

	for item in db
	{
		item_info := g.parse(item)

		/* 
		/ Detecting the following db format line
		/ ('item_name','item_id','item_url','item_price','item_update','is_tradable','is_giftable','in_store','store_price')
		*/

		if item_info.len >= 4 {
			g.items << items.new(item_info)
		}
	}

	g.profile_c = g.profiles.len

	println("Item database successfully loaded...!\nLoading profile database...!")

	mut c := 0
	for user in profile_dir 
	{
		if user.contains("example") { continue }
		g.profiles << profiles.new(os.read_file("db/profiles/${user}") or { "" })
		c++
	} 

	return g
}

pub fn (mut g Guide) find_profile(username string) profiles.Profile
{
	if username.len < 1 { return profiles.Profile{} }
	for user in g.profiles 
	{
		if user.username == username { return user }
	}

	return profiles.Profile{}
}

pub fn (mut g Guide) find_by_name(query string) []items.Item
{
	mut found := []items.Item{}

	for mut item in g.items 
	{
		if item.name == query { return [item] }

		if item.name.to_lower().contains(query) {
			found << item
		}
	}

	return found
}

pub fn (mut g Guide) advanced_match_name(item_name string, query string) bool 
{
	words_in_item_name := item_name.to_lower().split(" ")
	words_in_search_name := query.to_lower().split(" ")

	for word in words_in_item_name
	{
		for search_word in words_in_search_name
		{
			if word.contains(search_word) || word.starts_with(search_word) || word.ends_with(search_word) { return true }
		}
	}

	return false
}

pub fn (mut g Guide) find_by_id(query string) items.Item
{
	for item in g.items
	{
		if "${item.id}" == "${query}" { return item }
	}

	return items.Item{}
}

pub fn (mut g Guide) add_new_profile(args ...string) bool
{
	mut c := profiles.create()
	if c.username == "" { return false }

	g.profiles << c
	return true
}

pub fn (mut g Guide) add_to_list(list_t profiles.List_T, data string) bool
{
	match list_t
	{
		.add_fs {

		}
		.rm_fs {

		}
		.add_wtb {

		}
		.rm_wtb {

		} else {}
	}

	return true
}

fn (mut g Guide) parse(line string) []string
{
	return line.replace("(", "").replace(")", "").replace("'", "").split(",")
}