module db

import time
import src.str_utils

pub struct Profile 
{
	pub mut:
		username			string
		password			string

		yoworld				string
		yoworld_id			int
		net_worth 			string
		raw_badges			[]string
		badges 				[]Badges

		discord				string
		discord_id			i64

		facebook			string
		facebook_id			string

		display_info		bool
		display_badges		bool
		display_worth		bool
		display_invo		bool
		display_fs			bool
		display_wtb			bool
		display_activity	bool

		activites 			[]Activity
		invo 				[]Item
		fs_list				[]FS
		wtb_list			[]WTB
}

/*
	[@DOC]

	Create a new Profile with 
*/
pub fn create(args ...string) Profile
{
	if args.len != 14 { return Profile{} }

	mut p := Profile{}
	mut set_info := [p.username, p.password, p.yoworld, "${p.yoworld_id}",
				p.net_worth, p.discord, "${p.discord_id}", p.facebook, p.facebook_id]

	mut c := 0
	for mut arg in set_info
	{
		arg = args[c]
		c++
	}

	p.invo = []Item{}
	p.fs_list = []FS{}
	p.wtb_list = []WTB{}

	return p
}

pub fn new_profile(p_content string) Profile
{
	if p_content.len < 1 { return Profile{} }

	// TO-DO: Syntax Checker Function Call Here 

	mut p := Profile{}
	lines := p_content.split("\n")
	
	mut line_c := 0 
	for line in lines 
	{
		line_arg := line.trim_space().split(":")
		match line 
		{
			str_utils.match_starts_with(line, "username:") {
				if line_arg.len > 0 { p.username = line_arg[1].trim_space() }
			}
			str_utils.match_starts_with(line, "password:") {
				if line_arg.len > 0 { p.password = line_arg[1].trim_space() }
			}
			str_utils.match_starts_with(line, "yoworld:") {
				if line_arg.len > 0 { p.yoworld = line_arg[1].trim_space() }
			}
			str_utils.match_starts_with(line, "yoworldID:") {
				if line_arg.len > 0 { p.yoworld_id = line_arg[1].trim_space().int() }
			}
			str_utils.match_starts_with(line, "netWorth:") {
				if line_arg.len > 0 { p.net_worth = line_arg[1].trim_space() }
			}
			str_utils.match_starts_with(line, "discord:") {
				if line_arg.len > 0 { p.discord = line_arg[1].trim_space() }
			}
			str_utils.match_starts_with(line, "discordID:") {
				if line_arg.len > 0 { p.discord_id = line_arg[1].trim_space().i64() }
			}
			str_utils.match_starts_with(line, "facebook:") {
				if line_arg.len > 0 { p.facebook = line_arg[1].trim_space() }
			}
			str_utils.match_starts_with(line, "facebookID:") {
				if line_arg.len > 0 { p.facebook_id = line_arg[1].trim_space() }
			}
			str_utils.match_starts_with(line, "display_info:") {
				p.display_info = line_arg[1].trim_space().bool()
			}
			str_utils.match_starts_with(line, "Badges: ") {
				p.badges = p.parse_badges(line)
			}
			str_utils.match_starts_with(line, "[@ACTIVITIES]") {
				p.activites = p.parse_activities(p_content, line_c)
			}
			str_utils.match_starts_with(line, "[@INVENTORY]") {
				p.invo = p.parse_invo(p_content, line_c)
			}
			str_utils.match_starts_with(line, "[@FS]") {
				p.fs_list = p.parse_fs(p_content, line_c)
			}
			str_utils.match_starts_with(line, "[@WTB]") {
				p.wtb_list = p.parse_wtb(p_content, line_c)
			} else {}
		}
		line_c++
	}

	return p
}

/*
	pub fn (mut p Profile) edit_settings(setting_t Settings_T, new_data string) bool

	Description:
		Edit a Profile's Settings
*/
pub fn (mut p Profile) edit_settings(setting_t Settings_T, new_data string) bool
{
	if new_data.len < 1 { return false }
	match setting_t
	{
		.username {
			p.username = new_data
		}
		.password {
			// Add encryption here
			p.password = new_data
		}
		.yoworld {
			p.yoworld = new_data
		}
		.yoworld_id {
			p.yoworld_id = new_data.int()
		}
		.net_worth {
			p.net_worth = new_data
		}
		.discord {
			p.discord = new_data
		}
		.discord_id {
			p.discord_id = new_data.i64()
		}
		.facebook {
			p.facebook = new_data
		}
		.facebook_id {
			p.facebook_id = new_data
		} else {}
	}

	return true
}

/*
	pub fn (mut p Profile) edit_list(settings_t Settings_T, 
									acti_t Activity_T, 
									mut itm Item, 
									args ...string) bool

	Description:
		Edit a profile list type ( Add/Remove INVO/FS/WTB )
*/
pub fn (mut p Profile) edit_list(settings_t Settings_T, acti_t Activity_T, mut itm Item, args ...string) bool
{
	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")
	match settings_t 
	{
		.add_to_invo {
			p.invo << itm
			p.activites << new_activity(acti_t, mut itm, "", current_time, p.activites.len+1, args[0])
		}
		.add_to_fs {
			p.fs_list << FS{ posted_timestamp: current_time, fs_price: args[0], item: itm }
			p.activites << new_activity(acti_t, mut itm, args[0], current_time, p.activites.len+1, args[1], args[2])
		}
		.add_to_wtb {
			p.wtb_list << WTB{ posted_timestamp: current_time, wtb_price: args[0], item: itm }
			p.activites << new_activity(acti_t, mut itm, args[0], current_time, p.activites.len+1, args[1], args[2])
		}
		.rm_from_invo {
			mut c := 0
			for mut invo_item in p.invo 
			{
				if invo_item.id == itm.id {
					p.invo.delete(c)
				}
				c++
			}
			p.activites << new_activity(acti_t, mut itm, args[0], current_time, p.activites.len+1, args[1], args[2])
		}
		.rm_from_fs {
			mut fs_c := 0
			for mut fs_item in p.fs_list 
			{
				if fs_item.item.id == itm.id {
					p.fs_list.delete(fs_c)
				}
				fs_c++
			}
			p.activites << new_activity(acti_t, mut itm, args[0], current_time, p.activites.len+1, args[1], args[2])
		}
		.rm_from_wtb {
			mut wtb_c := 0
			for mut wtb_item in p.wtb_list 
			{
				if wtb_item.item.id == itm.id {
					p.wtb_list.delete(wtb_c)
				}
				wtb_c++
			}
			p.activites << new_activity(acti_t, mut itm, args[0], current_time, p.activites.len+1, args[1], args[2])
		} else { return false }
	}
	return false
}

pub fn (mut p Profile) is_manager() bool
{
	if Badges.admin in p.badges { return true }
	else if Badges.owner in p.badges { return true }

	return false
}

pub fn (mut p Profile) parse_badges(line string) []Badges
{
	p.raw_badges = line.replace("Badges:", "").trim_space().split(",")
	mut badges_obj := []Badges{}

	for badge in p.raw_badges
	{
		match badge {
			"admin" {
				badges_obj << Badges.admin
				break
			}
			"owner" {
				badges_obj << Badges.owner
			}
			"trusted" {
				badges_obj << Badges.trusted
			} else {}
		}
	}

	if badges_obj.len == 0 {
		return [Badges.null]
	}

	return badges_obj
}

/*
	pub fn (mut p Profile) parse_activities(content string, line_n int) []Activity

	Description:
		Parsing all activities within a Profile's DB File
*/
pub fn (mut p Profile) parse_activities(content string, line_n int) []Activity
{
	
	mut new := []Activity{}
	mut lines := content.split("\n")
	for i in line_n+1..(lines.len)
	{
		if lines[i].trim_space() == "}" || lines[i].trim_space() == "" || lines[i].contains("}") { break }
		if lines[i].contains("{") == false { 
			activity_info := lines[i].split(",")
			mut n_itm := Item{}
			if activity_info.len > 6 { n_itm = new_item(activity_info[2..7]) }

			match activity_info[1].trim_space()
			{
				"SOLD" {
					mut n := new_activity(Activity_T.item_sold, mut n_itm, activity_info[7], activity_info[activity_info.len-1], new.len+1, activity_info[activity_info.len-2], activity_info[activity_info.len-1])
					new << n
				}
				"BOUGHT" {
					mut n := new_activity(Activity_T.item_bought, mut n_itm, activity_info[7], activity_info[activity_info.len-1], new.len+1, activity_info[activity_info.len-2], activity_info[activity_info.len-1])
					new << n
				}
				"VIEWED" {
					mut n := new_activity(Activity_T.item_viewed, mut n_itm, "", activity_info[activity_info.len-1], new.len+1)
					new << n
				}
				"CHANGED" {
					mut n := new_activity(Activity_T.price_change, mut n_itm, activity_info[7], activity_info[activity_info.len-1], new.len+1)
					new << n
				}
				"LOGGED_IN" {
					mut n := new_activity(Activity_T.logged_in, mut n_itm, "", activity_info[activity_info.len-1], new.len+1)
					new << n
				}
				"FS_POSTED" {
					mut n := new_activity(Activity_T.fs_posted, mut n_itm, activity_info[7], activity_info[activity_info.len-1], new.len+1, activity_info[activity_info.len-2], activity_info[activity_info.len-1])
					new << n
				}
				"WTB_POSTED" {
					mut n := new_activity(Activity_T.wtb_posted, mut n_itm, activity_info[7], activity_info[activity_info.len-1], new.len+1, activity_info[activity_info.len-2], activity_info[activity_info.len-1])
					new << n
				} else {}
			}
		}
	}

	return new
}

/*
	pub fn (mut p Profile) parse_invo(content string, line_n int) []Item

	Description:
		Parsing all inventory within a Profile's DB File
*/
pub fn (mut p Profile) parse_invo(content string, line_n int) []Item
{
	
	mut new := []Item{}
	mut lines := content.split("\n")
	for i in line_n+1..(lines.len)
	{
		if lines[i].trim_space() == "}" { break }
		if lines[i].trim_space() == "" { continue }
		if lines[i].contains("{") == false { 
			new << new_item(lines[i].split(","))
		}
	}

	return new
}

/*
	pub fn (mut p Profile) parse_fs(content string, line_n int) []FS

	Description:
		Parsing all FS within a Profile's DB File
*/
pub fn (mut p Profile) parse_fs(content string, line_n int) []FS
{
	mut new := []FS{}
	mut lines := content.split("\n")
	
	for i in line_n+1..(lines.len)
	{
		if lines[i].trim_space() == "}" || lines[i].trim_space() == "" { break }
		if lines[i].contains("{") == false { 
			fs_item_info := lines[i].split(",")
			if fs_item_info.len < 2 { continue }

			mut new_fs := FS{	item: new_item(fs_item_info[0..5]),
								fs_price: fs_item_info[fs_item_info.len-4],
								posted_timestamp: fs_item_info[fs_item_info.len-1],
								buyer_confirmation: fs_item_info[fs_item_info.len-2],
								seller_confirmation: fs_item_info[fs_item_info.len-3]
			}
			if fs_item_info[fs_item_info.len-2] != "false" && fs_item_info[fs_item_info.len-3] != "false" {
				new_fs.confirmed_transaction = true
			}
			new << new_fs
		}
	}

	return new
}

/*
	pub fn (mut p Profile) parse_wtb(content string, line_n int) []WTB 

	Description:
		Parsing all WTB within a Profile's DB File
*/
pub fn (mut p Profile) parse_wtb(content string, line_n int) []WTB 
{
	mut new := []WTB{}
	mut lines := content.split("\n")

	for i in line_n+1..(lines.len)
	{
		if lines[i].trim_space() == "}" || lines[i].trim_space() == "" { break }
		if lines[i].contains("{") == false { 
			wtb_item_info := lines[i].split(",")

			mut new_wtb := WTB{	item: new_item(wtb_item_info[0..5]),
								wtb_price: wtb_item_info[wtb_item_info.len-2],
								posted_timestamp: wtb_item_info[wtb_item_info.len-1],
								buyer_confirmation: wtb_item_info[wtb_item_info.len-2],
								seller_confirmation: wtb_item_info[wtb_item_info.len-3]
			}
			if wtb_item_info[wtb_item_info.len-2] != "false" && wtb_item_info[wtb_item_info.len-3] != "false" {
				new_wtb.confirmed_transaction = true
			}
			new << new_wtb
		}
	}

	return new
}

pub fn (mut p Profile) list_to_str() string
{
	mut data := "[@ACTIVITIES]\n"

	for mut activity in p.activites 
	{
		data += "${activity.activity2str()}\n".replace("'", "").replace("(", "").replace(")", "").replace("[", "").replace("]", "")
	}

	data += "[@INVENTORY]\n"

	for mut invo_item in p.invo 
	{
		data += "${invo_item.item2api()}\n".replace("'", "").replace("(", "").replace(")", "").replace("[", "").replace("]", "")
	}

	data += "[@FS]\n"

	for mut fs_item in p.fs_list 
	{
		data += "${fs_item.item.item2api()},${fs_item.fs_price},${fs_item.seller_confirmation},${fs_item.buyer_confirmation},${fs_item.posted_timestamp}\n".replace("'", "").replace("(", "").replace(")", "").replace("[", "").replace("]", "")
	}

	data += "[@WTB]\n"

	for mut wtb_item in p.wtb_list 
	{
		data += "${wtb_item.item.item2api()},${wtb_item.wtb_price},${wtb_item.seller_confirmation},${wtb_item.buyer_confirmation},${wtb_item.posted_timestamp}\n".replace("'", "").replace("(", "").replace(")", "").replace("[", "").replace("]", "")
	}

	return data
}

pub fn (mut p Profile) to_str() string
{
	mut data := "[@PROFILE] => ${p.username}
              PW => ${p.password}
              Yoworld => ${p.yoworld}
              Yoworld ID => ${p.yoworld_id}
              Net Worth => ${p.net_worth}
              Discord => ${p.discord}
              Discord ID => ${p.discord_id}
              Facebook => ${p.facebook}
              Facebook ID => ${p.facebook_id}

          [ @DIPLAY_SETTINGS ]
   Info => ${p.display_info} | Badges => ${p.display_badges} | Worth => ${p.display_worth} | INVO => ${p.display_invo} | FS => ${p.display_fs} | WTB => ${p.display_wtb} | Activity => ${p.display_activity}\n"

   data += p.list_to_str()

	return data
}

pub fn (mut p Profile) to_api() string 
{
	acct_info := "[${p.username},none,${p.yoworld},${p.yoworld_id},${p.net_worth},${p.discord},${p.discord_id},${p.facebook},${p.facebook_id}]"
	acct_settings := "[${p.display_info},${p.display_badges},${p.display_worth},${p.display_invo},${p.display_fs},${p.display_wtb},${p.display_activity}]"

	mut activities := p.list_to_str()

	return "${acct_info}\n${acct_settings}\n${p.raw_badges}\n${activities}".replace("(", "").replace(")", "").replace("[", "").replace("]", "").replace("'", "")
}

pub fn (mut p Profile) to_auth_str() string
{
	acct_info := "[${p.username},${p.password},${p.yoworld},${p.yoworld_id},${p.net_worth},${p.discord},${p.discord_id},${p.facebook},${p.facebook_id}]"
	acct_settings := "[${p.display_info},${p.display_badges},${p.display_worth},${p.display_invo},${p.display_fs},${p.display_wtb},${p.display_activity}]"

	mut activities := p.list_to_str()

	return "${acct_info}\n${acct_settings}\n${p.raw_badges}\n${activities}".replace("(", "").replace(")", "").replace("[", "").replace("]", "").replace("'", "")
}