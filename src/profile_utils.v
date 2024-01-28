module src

import src.profiles

pub fn (mut g Guide) find_profile(username string) profiles.Profile
{
	if username.len < 1 { return profiles.Profile{} }
	for user in g.profiles 
	{
		if user.username == username { return user }
	}

	return profiles.Profile{}
}