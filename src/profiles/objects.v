module profiles

import src.items

pub struct Profile 
{
	pub mut:
		username			string
		password			string

		yoworld				string
		yoworld_id			int
		net_worth 			string
		badges 				[]Badges

		discord				string
		discord_id			i64

		facebook			string
		facebook_id			string

		display_badges		bool
		display_worth		bool
		display_invo		bool
		display_fs			bool
		display_wtb			bool
		display_activity	bool

		activites 			[]Activity
		invo 				[]items.Item
		fs_list				[]FS
		wtb_list			[]WTB
}

pub enum Settings_T
{
	null 				= 0x00001
	username 			= 0x00002
	password 			= 0x00003
	yoworld 			= 0x00004
	yoworld_id 			= 0x00005
	net_worth			= 0x00006
	discord 			= 0x00007
	discord_id 			= 0x00008
	facebook			= 0x00009
	facebook_id			= 0x00010

	display_badges		= 0x00011
	display_worth		= 0x00012
	display_invo		= 0x00013
	display_fs			= 0x00014
	display_wtb			= 0x00015
	display_activity	= 0x00016

	add_activity		= 0x00017

	add_to_invo			= 0x00018
	add_to_fs			= 0x00019
	add_to_wtb			= 0x00020
	rm_from_fs			= 0x00021
	rm_from_fs			= 0x00022
	rm_from_wtb			= 0x00023
}

pub struct FS 
{
	pub mut:
		posted_timestamp	string
		fs_price			string
		item				items.Item
}

pub struct WTB 
{
	pub mut:
		posted_timestamp	string
		wtb_price			string
		item				items.Item
}

pub enum List_T
{
	null 		= 0x00101
	add_fs 		= 0x00102
	rm_fs 		= 0x00103

	add_wtb 	= 0x00104
	rm_wtb		= 0x00105
}

pub enum Badges 
{
	null = 0x00201
	verified = 0x00202
	trusted = 0x00203
	reputation = 0x00204

	// crew
	ae = 0x00205
	pnkm = 0x00206
	nmdz = 0x00207
}

pub enum Activity_T 
{
	null 			= 0x690000
	item_sold 		= 0x690001
	item_bought		= 0x690002
	item_viewed		= 0x690003
	price_change	= 0x690004
}

pub struct Activity 
{
	pub mut:
		act_t 		Activity_T
		item		items.Item
		price		string
		timestamp 	string
}

pub fn new_activity(actt Activity_T, itm items.Item, p string, t string) Activity
{
	return Activity{act_t: actt, item: itm, price: p, timestamp: t}
}

pub fn activityt2str(act_t Activity_T) string 
{
	match act_t
	{
		.item_sold {
			"item_sold"
		}
		.item_bought {
			"item_bought"
		}
		.item_viewed {
			"item_viewed"
		}
		.price_change {
			"price_change"
		} else {}
	}
	return ""
}

pub fn (mut a Activity) activity2str() string
{
	return "('${a.act_t}','${a.item.item2profile()}','${a.price}','${a.timestamp}')"
}