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

	g.profile_c = s.profile.len

	println("Item database successfully loaded...!\nLoading profile database...!")

	for user in profile_dir 
	{
		if user.contains("example") { continue }
		g.profiles << profiles.new(os.read_file(user) or { "" })
	} 

	return g
}

pub fn (mut g Guide) add_new_profile(args ..string) bool
{
	mut c := profiles.create()
	if c.username == "" { return false }

	g.profiles << c
	return true
}

pub fn (mut g Guide) add_to_list(list_t List_T, data string) bool
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
	return line.replace("(", "").replace(")", "").replace("'", "").split(":")
}