import vweb

import os
import time
import rand

import src
import src.str_utils

pub struct API 
{
	vweb.Context
	pub mut:
		guide shared src.Guide 
}

pub const (
	admins = 4
	website_backend = "195.133.52.252"
	website_backend_ipv6 = "2607:5300:201:3100::8510"
)

fn main() {
	shared gd := src.build_guide()
	vweb.run(&API{guide: gd}, 80)
}

@['/index']
pub fn (mut api API) index() vweb.Result 
{
	api.text("Welcome To Guide API v1.00 Written In V, By JaCKeR1x")
	return $vweb.html()
}

@['/statistics']
pub fn (mut api API) stats() vweb.Result
{
	// $ip = $_SERVER["HTTP_CF_CONNECTING_IP"];
	ip := api.form['HTTP_CF_CONNECTING_IP'] or { api.ip() }
	t_ip := api.query['HTTP_CF_CONNECTING_IP'] or { api.ip() }
	if ip != website_backend && ip != website_backend_ipv6 {
		println("${ip} ${api.query} ${api.form} ${api.header} ")
		return api.text("This endpoint is for YoMarket WebSite Only!")
	}
	mut item_c := 0
	lock api.guide {
		item_c = api.guide.item_c
	}

	search_count := src.read_log_db_count(src.Log_T._search)
	change_count := src.read_log_db_count(src.Log_T._change)

	return api.text("${item_c},${search_count},${change_count}")
}

@['/search']
pub fn (mut api API) search() vweb.Result
{
	query 		:= api.query['q'] or { "" }
	agent 		:= api.query['agent'] or { "NONE" }
	user_ip 	:= api.query['ip'] or { api.ip() }

	if query == "" { return api.text("[ X ] Error, You must enter an Item name or ID") }

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	/* Selecting 15 random items to display */
	mut random_items := ""
	if query == "randomized" {

		for _ in 0..15 {
			num := rand.int_in_range(0, gd.items.len) or { 0 }
			random_items += gd.items[num].item2api() + "\n"
		}

		return api.text("${random_items}")
	}

	mut check_item := gd.search(query, false)
	println("[ + ] New Search Log => ${query} ${user_ip}\nUser-Agent => ${agent}")

	/* Blocking Invalid User Searches */
	if user_ip != website_backend && user_ip != website_backend_ipv6 {
		println("${user_ip}")
		src.new_log(src.App_T._site, src.Log_T._search, user_ip, query, src.result_t(check_item.r_type), "${check_item.results.len}")
	}

	/* Search Check */
	if check_item.r_type == ._none {
		println("[ X ] Error, No item was found for ${query}")
		return api.text("[ X ] Error, No items found!")
	} else if check_item.r_type == ._exact {
		check_item.results[0].ywinfo_price_logs()
		return api.text("${check_item.results[0].item2api()}\n${check_item.results[0].ywinfo_prices_2str()}")
	}

	/* Gathering all found items */
	mut api_items := ""
	for mut item in check_item.results
	{
		api_items += "${item.item2api()}\n"
	}

	return api.text("${api_items}")
}

@['/change']
pub fn (mut api API) change_price() vweb.Result
{
	item_id 	:= api.query['id'] or { "" }
	new_price 	:= api.query['price'] or { "" }
	user_ip 	:= api.query['ip'] or { api.ip() }
	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	gd.query = item_id
	mut item := gd.find_by_id()
	
	/* Validating Managers */
	if !src.is_manager(user_ip) {
		gd.add_suggestion(mut item, new_price)
		println("[ + ] ${current_time} | An unknown user tried change an item price => \n(${user_ip},${item_id},${new_price})...!")
		return api.text("[ X ] Error, You are not a price manager to use this. The price has been sent to admins to investigate....")
	}

	mut check := gd.change_price(mut item, new_price, user_ip)

	if !check {
		println("[ X ] Error, failed to change price on ${item.id} ${new_price}...!")
		return api.text("[ X ] Error, failed to change price on ${item.id} ${new_price}...!")
	}

	return api.text("[ + ] ${item.name}'s price has been successfully updated to ${item.price}...!\n${item.item2api()}")
}

@['/price_logs']
pub fn (mut api API) price_logs() vweb.Result
{
	ip := api.query['ip'] or { api.ip() }
	if ip != website_backend && ip != website_backend_ipv6 {
		return api.text("This endpoint is for YoMarket WebSite Only!")
	}
	
	changes 	:= os.read_lines("logs/changes.log") or { [] }
	total 		:= changes.len
	mut last 	:= changes.clone()
	
	if total > 30 {
		last_t := changes.len-30
		last = changes.clone()[last_t..total]
	}

	return api.text("${last}".replace("['", "").replace("']", "").replace("', '", "\n"))
}

@['/all_suggestion']
pub fn (mut api API) all_suggestion() vweb.Result 
{
	ip := api.query['ip'] or { api.ip() }
	if ip != website_backend && ip != website_backend_ipv6 {
		return api.text("This endpoint is for YoMarket WebSite Only!")
	}
	
	return api.text(os.read_file(src.suggestion_filepath) or { "" })
}

@['/save']
pub fn (mut api API) save_end() vweb.Result 
{
	lock api.guide { api.guide.save_db() }

	return api.text("Database saved!")
}

/*
	Login Auth Endpoint Below
*/
@['/auth']
pub fn (mut api API) auth() vweb.Result
{
	
	username 	:= api.query['username'] or { "" }
	password 	:= api.query['password'] or { "" }

	ip := api.query['ip'] or { api.ip() }
	if ip != website_backend && ip != website_backend_ipv6 {
		return api.text("This endpoint is for YoMarket WebSite Only!")
	}

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	mut user := gd.find_profile(username)

	/* Validating User */
	if user.username == username && user.password == password 
	{
		// Log action
		return api.text("${user.to_auth_str()}")
	}

	// Log action
	return api.text("[ X ] Error, Invalid information provided!")
}

@['/profile']
pub fn (mut api API) profile() vweb.Result
{
	// ip := api.query['ip'] or { api.ip() }
	// if ip != website_backend && ip != website_backend_ipv6 {
	// 	return api.text("This endpoint is for YoMarket WebSite Only!")
	// }

	username 	:= api.query['username'] or { "" }

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	mut user := gd.find_profile(username)

	return api.text(user.to_api())
}