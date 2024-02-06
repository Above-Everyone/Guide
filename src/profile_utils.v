module src

import os

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

pub fn (mut g Guide) edit_profile_list(mut profile db.Profile, settings_t db.Settings_T, acti_t db.Activity_T, mut itm db.Item, args ...string) bool
{
	for mut p in g.profiles {
		if p == profile {
			p.edit_list(settings_t, acti_t, mut itm, ...args)
			p.save_profile()
			return true
		}
	}

	return false
}

pub fn (mut g Guide) get_latest_actions() 
{

}

pub fn (mut g Guide) generate_template(items string, username string) bool
{
	os.write_file("assets/generator/template_data.txt", "${items}\n${username}") or { return false }
	output := os.execute("start assets/generator/generate_template.py").output

	println(output)

	if(os.exists("template.png"))
	{
		os.mv("template.png", "assets/templates/${username}.png", os.MvParams{overwrite: true}) or { 0 }
		return true 
	}

	return false
}