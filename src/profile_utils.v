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