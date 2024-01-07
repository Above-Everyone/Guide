module profiles

import src.items
import crypto.bcrypt

pub struct Profile 
{
	pub mut:
		username			string
		password			string

		yoworld				string
		yoworld_id			int
		net_worth 			string

		discord				string
		discord_id			i64

		facebook			string
		facebook_id			string

		display_badges		string
		display_worth		string
		display_invo		string
		display_fs			string
		display_wtb			string
		display_activity	string

		invo 				[]items.Item
		fs_list				[]FS
		wtb_list			[]WTB
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