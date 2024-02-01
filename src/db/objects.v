module db

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
	rm_from_invo		= 0x00021
	rm_from_fs			= 0x00022
	rm_from_wtb			= 0x00023
}

pub enum List_T
{
	null 		= 0x00101
	add_fs 		= 0x00102
	rm_fs 		= 0x00103

	add_wtb 	= 0x00104
	rm_wtb		= 0x00105
}

pub struct YW_INFO_PRICES
{
	pub mut:
		price			string
		approve 		bool
		approved_by		string
		timestamp		string
}

pub struct Prices
{
    pub mut:
        username        string
        old_price       string
        old_update      string
        item            Item
}