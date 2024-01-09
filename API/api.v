import vweb

import src

pub struct API 
{
	vweb.Context
}

fn main() {
	vweb.run(&API{}, 80)
}

['/index']
pub fn (mut api API) index() vweb.Result 
{
	api.text("Welcome To Guide API v1.00 Written In V, By JaCKeR1x")
	return $vweb.html()
}

['/search']
pub fn (mut api API) search() vweb.Result
{
	query := api.query['q'] or { "" }
	user_ip := api.ip() 

	if query == "" {
		return api.text("[ X ] Error, You must enter an Item name or ID")
	}

	mut guide := src.build_guide()
	mut check_item := guide.find_by_name(query)

	if check_item.len == 0 {
		return api.text("[ X ] Error, No items found!")
	}

	return api.text("${check_item}")
}

['/auth']
pub fn (mut api API) auth() vweb.Result
{
	username := api.query['username'] or { "" }
	password := api.query['password'] or { "" }

	mut guide := src.build_guide()
	mut user := guide.find_profile(username)

	if user.username == username && user.password == password 
	{
		api.text("${user.profile2api()}")
	}

	return $vweb.html()
}