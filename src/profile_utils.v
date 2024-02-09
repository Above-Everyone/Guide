module src

import os
import time

import src.db

pub fn (mut g Guide) find_profile(username string) db.Profile
{
	if username.len < 1 { return db.Profile{} }

	mut c := 0
	for mut user in g.profiles 
	{
		if user.username == username {
			user.idx = c
			return user 
		}
		c++
	}

	return db.Profile{}
}

pub fn (mut g Guide) count_admins() int
{
	mut c := 0
	for mut profile in g.profiles
	{
		if profile.is_manager()
		{ c++ }
	}

	return c
}

pub fn (mut g Guide) edit_profile_list(mut profile db.Profile, settings_t db.Settings_T, acti_t db.Activity_T, mut itm db.Item, args ...string) db.Profile
{
	for mut p in g.profiles {
		if p == profile {
			p.edit_list(settings_t, acti_t, mut itm, ...args)
			p.save_profile()
			return p
		}
	}

	return p
}

pub fn (mut g Guide) get_latest_fs_actions() []db.FS
{
	mut item_fs_count := 0
    mut items := []db.FS{}
	
	for profile in g.profiles
	{
		if profile.fs_list.len > 0 { 
			item_fs_count += profile.fs_list.len
			for fs_item in profile.fs_list { items << fs_item }
		}
	}
    return items
}

pub fn (mut g Guide) list_all_users() string 
{
	mut users_list := "[@OWNER]\n"

	/* Grabing Owners First */
	for usr_chk in g.profiles {
		if db.Badges.owner in usr_chk.badges {
			users_list += "${usr_chk.username}\n"
		}
	}

	users_list += "[@ADMINS]\n"

	/* Grabbing Admins */
	for p_chk in g.profiles {
		if db.Badges.admin in p_chk.badges {
			users_list += "${p_chk.username}\n"
		}
	}

	users_list += "[@USERS]\n"

	for user in g.profiles 
	{
		if db.Badges.owner !in user.badges && db.Badges.admin !in user.badges {
			users_list += "${user.username}\n"
		}
	}

	return users_list
}

pub fn (mut g Guide) generate_template(items string, username string) bool
{
	os.write_file("assets/generator/template_data.txt", "${items}\n${username}") or { return false }
	output := os.execute("start assets/generator/generate_template.py").output

	time.sleep(10*time.second)

	if(os.exists("template.png"))
	{
		os.mv("template.png", "assets/templates/${username}.png", os.MvParams{overwrite: true}) or { 0 }
		return true 
	}

	return false
}