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

		display_badges		bool = false
		display_worth		bool = false
		display_invo		bool = false
		display_fs			bool = false
		display_wtb			bool = false
		display_activity	bool = false

		invo 				[]items.Item
		fs_list				[]FS
		wtb_list			[]WTB
}

pub enum Settings_T
{
	null 				= 0x0001
	username 			= 0x0002
	password 			= 0x0003
	yoworld 			= 0x0004
	yoworld_id 			= 0x0005
	net_worth			= 0x0006
	discord 			= 0x0007
	discord_id 			= 0x0008
	facebook			= 0x0009
	facebook_id			= 0x0010

	display_badges		= 0x0011
	display_worth		= 0x0012
	display_invo		= 0x0013
	display_fs			= 0x0014
	display_wtb			= 0x0015
	display_activity	= 0x0016
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