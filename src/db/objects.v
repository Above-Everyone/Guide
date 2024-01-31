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

pub enum Badges 
{
	null = 0x00201
	verified = 0x00202
	trusted = 0x00203
	reputation = 0x00204

	admin = 0x00205
	owner = 0x00206

	// crew
	ae = 0x00207
	pnkm = 0x00208
	nmdz = 0x00209
}

pub enum Activity_T 
{
	null 			= 0x690000
	item_sold 		= 0x690001
	item_bought		= 0x690002
	item_viewed		= 0x690003
	price_change	= 0x690004
	logged_in 		= 0x690005
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