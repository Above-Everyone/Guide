import vweb

import os
import time
import rand

import src
import src.items
import src.utils
import src.profiles

pub struct API 
{
	vweb.Context
	pub mut:
		guide shared src.Guide 
}

pub const (
	admins = 4
)

fn main() {
	shared gd := src.build_guide()
	vweb.run(&API{guide: gd}, 80)
}

['/index']
pub fn (mut api API) index() vweb.Result 
{
	api.text("Welcome To Guide API v1.00 Written In V, By JaCKeR1x")
	return $vweb.html()
}

['/statistics']
pub fn (mut api API) stats() vweb.Result
{
	mut item_c := 0
	mut t := 0
	lock api.guide {
		item_c = api.guide.item_c
	}

	search_count := utils.read_log_db_count(utils.Log_T._search)
	change_count := utils.read_log_db_count(utils.Log_T._change)

	return api.text("${item_c},${search_count},${change_count}")
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

	mut check_item := src.Response{} 
	lock api.guide {

		if query == "randomized" {
			mut random_items := ""
			mut item_c := 0
			for mut i in api.guide.items {
				if item_c == 15 { break }
				num := rand.int_in_range(0, api.guide.items.len) or { 0 }
				random_items += api.guide.items[num].item2api() + "\n"
				item_c++
			}
			return api.text("${random_items}")
		}

		check_item = api.guide.search(query, false)
	}

	println("[ + ] New Search Log => ${query} ${user_ip}\nUser-Agent => ${agent}")
	if user_ip != "167.114.155.204" {
		utils.new_log(utils.App_T._site, utils.Log_T._search, user_ip, query, src.result_t(check_item.r_type), "${check_item.results.len}")
	}

	if check_item.results.len == 0 {
		println("[ X ] Error, No item was found for ${query}")
		return api.text("[ X ] Error, No items found!")
	}

	if check_item.results.len == 1 {
		return api.text("${check_item.results[0].item2api()}")
	}

	mut api_items := ""

	for mut item in check_item.results
	{
		api_items += "${item.item2api()}\n"
	}

	return api.text("${api_items}")
}

['/change']
pub fn (mut api API) change_price() vweb.Result
{
	item_id := api.query['id'] or { "" }
	new_price := api.query['price'] or { "" }
	approved := api.query['status'] or { "" }
	mut user_ip := api.query['ip'] or { "" }

	if user_ip == "" {
		user_ip = api.ip()
	}

	
    mut item := items.Item{}
	mut check := false
	lock api.guide {
		api.guide.query = item_id
		item = api.guide.find_by_id()
		check = api.guide.change_price(mut item, new_price, user_ip)
	}

	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")
	if !utils.is_manager(user_ip) {
		lock api.guide {
			api.guide.add_suggestion(mut item, new_price)
		}
		println("[ + ] ${current_time} | An unknown user tried change an item price => \n(${user_ip},${item_id},${new_price})...!")
		return api.text("[ X ] Error, You are not a price manager to use this. The price has been sent to admins to investigate....")
	}

	if !check {
		return api.text("[ X ] Error, Unable to change price for ${item.name}....!")
	}

	return api.text("[ + ] ${item.name}'s price has been successfully updated to ${item.price}...!\n${item.item2api()}")
}

['/price_logs']
pub fn (mut api API) price_logs() vweb.Result
{
	changes := os.read_lines("logs/changes.log") or { [] }
	total := changes.len
	mut last := changes.clone()
	if total > 30 {
		last_t := changes.len-30
		last = changes[last_t..total]
	}
	return api.text("${last}".replace("['", "").replace("']", "").replace("', '", "\n"))
}

['/auth']
pub fn (mut api API) auth() vweb.Result
{
	username := api.query['username'] or { "" }
	password := api.query['password'] or { "" }
	user_ip := api.query['user_ip'] or { "" }

	mut user := profiles.Profile{}
	lock api.guide {
		user = api.guide.find_profile(username)
	}

	if user.username == username && user.password == password 
	{
		return api.text("${user.profile2api()}")
	}

	return api.text("[ X ] Error, Invalid information provided!")
}

['/all_suggestion']
pub fn (mut api API) all_suggestion() vweb.Result 
{
	return api.text(os.read_file(utils.suggestion_filepath) or { "" })
}

['/save']
pub fn (mut api API) save_end() vweb.Result 
{
	lock api.guide {
		api.guide.save_db()
	}

	return api.text("Database saved!")
}