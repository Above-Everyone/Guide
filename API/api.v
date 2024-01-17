import vweb

import time

import src
import src.utils

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
	agent := api.query['agent'] or { "NONE" }
	mut user_ip := api.query['ip'] or { "" }

	if user_ip == "" {
		user_ip = api.ip()
	}

	if query == "" {
		return api.text("[ X ] Error, You must enter an Item name or ID")
	}

	mut guide := src.build_guide()
	mut check_item := guide.search(query, false)

	println("[ + ] New Search Log => ${query} ${user_ip}\nUser-Agent => ${agent}")

	if check_item.results.len == 0 {
		println("[ X ] Error, No item was found for ${query}")
		return api.text("[ X ] Error, No items found!")
	}

	if check_item.results.len == 1 {
		return api.text("${check_item.results[0].item2api()}")
	}

	mut items := ""

	for mut item in check_item.results
	{
		items += "${item.item2api()}\n"
	}

	return api.text("${items}")
}

['/change']
pub fn (mut api API) change_price() vweb.Result
{
	item_id := api.query['id'] or { "" }
	new_price := api.query['price'] or { "" }
	mut user_ip := api.query['ip'] or { "" }

	if user_ip == "" {
		user_ip = api.ip()
	}

	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")
	if !utils.is_manager(user_ip) {
		println("[ + ] ${current_time} | An unknown user tried change an item price => \n(${user_ip},${item_id},${new_price})...!")
		return api.text("[ X ] Error, You are not a price manager to use this!")
	}

	
	mut guide := src.build_guide()

	guide.query = item_id
    mut item := guide.find_by_id()

    mut check := guide.change_price(mut item, new_price)

	if !check {
		return api.text("[ X ] Error, Unable to change price for ${item.name}...!")
	}

	return api.text("[ + ] ${item.name}'s price has been successfully updated to ${item.price}...!")
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