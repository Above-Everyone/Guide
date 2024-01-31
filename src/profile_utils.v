module src

import src.db

pub fn (mut g Guide) find_profile(username string) db.Profile
{
	if username.len < 1 { return db.Profile{} }
	for user in g.profiles 
	{
		if user.username == username { return user }
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
		}
	}
	return true
}