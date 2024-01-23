module profiles

import src.items
import src.utils
// import crypto.bcrypt

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

	p.invo = []items.Item{}
	p.fs_list = []FS{}
	p.wtb_list = []WTB{}

	return p
}

pub fn new(p_content string) Profile
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
			utils.match_starts_with(line, "username:") {
				if line_arg.len > 0 { p.username = line_arg[1].trim_space() }
			}
			utils.match_starts_with(line, "password:") {
				if line_arg.len > 0 { p.password = line_arg[1].trim_space() }
			}
			utils.match_starts_with(line, "yoworld:") {
				if line_arg.len > 0 { p.yoworld = line_arg[1].trim_space() }
			}
			utils.match_starts_with(line, "yoworldID:") {
				if line_arg.len > 0 { p.yoworld_id = line_arg[1].trim_space().int() }
			}
			utils.match_starts_with(line, "netWorth:") {
				if line_arg.len > 0 { p.net_worth = line_arg[1].trim_space() }
			}
			utils.match_starts_with(line, "discord:") {
				if line_arg.len > 0 { p.discord = line_arg[1].trim_space() }
			}
			utils.match_starts_with(line, "discordID:") {
				if line_arg.len > 0 { p.discord_id = line_arg[1].trim_space().i64() }
			}
			utils.match_starts_with(line, "facebook:") {
				if line_arg.len > 0 { p.facebook = line_arg[1].trim_space() }
			}
			utils.match_starts_with(line, "faceookID:") {
				if line_arg.len > 0 { p.facebook_id = line_arg[1].trim_space() }
			}
			utils.match_starts_with(line, "[@INVENTORY]") {
				p.invo = p.parse_invo(p_content, line_c)
			}
			utils.match_starts_with(line, "[@FS]") {
				p.fs_list = p.parse_fs(p_content, line_c)
			}
			utils.match_starts_with(line, "[@WTB]") {
				p.wtb_list = p.parse_wtb(p_content, line_c)
			} else {}
		}
		line_c++
	}

	return p
}

pub fn (mut p Profile) edit(setting_t Settings_T, new_data string) bool
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
		}
		.display_badges, .display_worth, .display_invo, .display_fs, .display_wtb, .display_activity {
			if new_data == "1" || new_data == "true" {
				p.display_badges = true
			}
		} else {}
	}

	return true
}

pub fn (mut p Profile) parse_invo(content string, line_n int) []items.Item
{
	
	mut new := []items.Item{}
	mut lines := content.split("\n")
	for i in line_n+1..(lines.len)
	{
		if lines[i].trim_space() == "}" { break }
		if lines[i].trim_space() == "" { continue }
		if lines[i].contains("{") == false { 
			new << items.new(lines[i].split(","))
		}
	}

	return new
}

pub fn (mut p Profile) parse_fs(content string, line_n int) []FS
{
	mut new := []FS{}
	mut lines := content.split("\n")
	
	for i in line_n+1..(lines.len)
	{
		if lines[i].trim_space() == "}" { break }
		if lines[i].trim_space() == "" { continue }
		if lines[i].contains("{") == false { 
			fs_item_info := lines[i].split(",")

			mut new_wtb := FS{}
			new_wtb.item = items.new(fs_item_info[0..(fs_item_info.len-3)])
			new_wtb.fs_price = fs_item_info[fs_item_info.len-2]
			new_wtb.posted_timestamp = fs_item_info[fs_item_info.len-1]

			new << new_wtb
		}
	}

	return new
}

pub fn (mut p Profile) parse_wtb(content string, line_n int) []WTB 
{
	mut new := []WTB{}
	mut lines := content.split("\n")

	for i in line_n+1..(lines.len)
	{
		if lines[i].trim_space() == "}" { break }
		if lines[i].trim_space() == "" { continue }
		if lines[i].contains("{") == false { 
			wtb_item_info := lines[i].split(",")

			mut new_wtb := WTB{}
			new_wtb.item = items.new(wtb_item_info[0..(wtb_item_info.len-3)])
			new_wtb.wtb_price = wtb_item_info[wtb_item_info.len-2]
			new_wtb.posted_timestamp = wtb_item_info[wtb_item_info.len-1]

			new << new_wtb
		}
	}

	return new
}

pub fn (mut p Profile) profile2str() string
{
	return "[@PROFILE] => ${p.username}
              PW => ${p.password}
              Yoworld => ${p.yoworld}
              Yoworld ID => ${p.yoworld_id}
              Net Worth => ${p.net_worth}
              Discord => ${p.discord}
              Discord ID => ${p.discord_id}
              Facebook => ${p.facebook}
              Facebook ID => ${p.facebook_id}

          [ @DIPLAY_SETTINGS ]
   Badges => ${p.display_badges} | Worth => ${p.display_worth} | INVO => ${p.display_invo} | FS => ${p.display_fs} | WTB => ${p.display_wtb} | Activity => ${p.display_activity}"
}

pub fn (mut p Profile) profile2api() string
{
	acct_info := "[${p.username},${p.password},${p.yoworld},${p.yoworld_id},${p.net_worth},${p.discord},${p.discord_id},${p.facebook},${p.facebook_id}]"
	acct_settings := "[${p.display_badges},${p.display_worth},${p.display_invo},${p.display_fs},${p.display_wtb},${p.display_activity}]"

	mut invo := ""

	for mut invo_item in p.invo 
	{
		invo += "${invo_item.item2api()}\n"
	}

	mut fs_list := ""

	for mut fs_item in p.fs_list 
	{
		fs_list += "${fs_item.item.item2api()},${fs_item.fs_price},${fs_item.posted_timestamp}\n"
	}

	mut wtb_list := ""

	for mut wtb_item in p.wtb_list 
	{
		wtb_list += "${wtb_item.item.item2api()},${wtb_item.wtb_price},${wtb_item.posted_timestamp}\n"
	}

	return "${acct_info}\n${acct_settings}\n[@INVENTORY]${invo}\n[@FS]${fs_list}\n[@WTB]${wtb_list}"
}