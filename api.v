import vweb

import os
import time
import rand

import src
import src.db
import src.utils

pub struct API 
{
	vweb.Context
	pub mut:
		guide shared src.Guide 
}

pub const (
	admins = 4
	website_backend = "167.114.155.204"
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

	search_count := src.read_log_db_count(src.Log_T._search)
	change_count := src.read_log_db_count(src.Log_T._change)
	
	mut item_c := 0
	mut users := 0
	lock api.guide {
		item_c = api.guide.item_c
		users = api.guide.profiles.len
	}

	return api.text("${item_c},${search_count},${change_count},${users}")
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
	println("${utils.signal_colored(true)} New search | Item Search\n\t=> ${query} | ${check_item.r_type} | ${check_item.results.len}\n\tIP: ${user_ip}\n\tAgent: ${agent}")

	/* Blocking Invalid User Searches */
	if user_ip != website_backend && user_ip != website_backend_ipv6 {
		src.new_log(src.App_T._site, src.Log_T._search, user_ip, query, src.result_t(check_item.r_type), "${check_item.results.len}")
	}

	/* Search Check */
	if check_item.r_type == ._none {
		println("${utils.signal_colored(false)} No items found | Item Search\n\t=> ${query} | ${check_item.r_type} | ${check_item.results.len}\n\tIP: ${user_ip}\n\tAgent: ${agent}")
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
	item_id 		:= api.query['id'] or { "" }
	new_price 		:= api.query['price'] or { "" }
	user 			:= api.query['user'] or { api.ip() }
	ip 				:= api.query['ip'] or { api.ip() }
	current_time 	:= "${time.now()}".replace("-", "/").replace(" ", "-")
	mut gd 			:= src.Guide{}

	lock api.guide { gd = api.guide }
	gd.query = item_id
	mut item := gd.find_by_id()
	
	mut profile := gd.find_profile(user)
	if !profile.is_manager()
	{
		src.new_log(src.App_T._site, src.Log_T._suggestion, ip, "${item.id}", item.price, new_price)
		println("${utils.signal_colored(true)} Admin Fail | Item Price Change\n\t=> ${item_id} | ${new_price} | ${user}\n\tIP: ${ip}")
		return api.text("[ X ] Error, You aren't a manager to change price. Price has been suggested to admins to investigate....")
	}

	mut check := gd.change_price(mut item, new_price, ip)

	if !check {
		println("${utils.signal_colored(true)} Failed Price Change | Item Price Change\n\t=> ${item_id} | ${new_price} | ${user}\n\tIP: ${ip}")
		return api.text("[ X ] Error, failed to change price on ${item.id} ${new_price}...!")
	}

	println("${utils.signal_colored(true)} Changed Price | Item Price Change\n\t=> ${item_id} | ${new_price} | ${user}\n\tIP: ${ip}")
	return api.text("[ + ] ${item.name}'s price has been successfully updated to ${item.price}...!\n${item.item2api()}")
}

@['/template']
pub fn (mut api API) template_creator() vweb.Result
{
	items 		:= api.query['items'] or { "" }
	username 	:= api.query['username'] or { "" }
	ip 			:= api.query['ip'] or { "" }

	if items == "" || username == "" {
		println("${utils.signal_colored(false)} No info provided | Template Creator\n\t=> ${items} | ${username}\n\t${ip}")
		return api.text("[ X ] Invalid info provided....!")
	}

	mut check := false
	lock api.guide
	{ check = api.guide.generate_template(items, username) }

	if check  {
		println("${utils.signal_colored(true)} Template Created | Template Creator\n\t=> ${items} | ${username}\n\t${ip}")
		return api.text("[ + ] Template created....!")
	}

	println("${utils.signal_colored(false)} Invalid operation | Template Creator\n\t=> ${items} | ${username}\n\t${ip}")
	return api.text("Invalid operation!")
}

@['/get_template']
pub fn (mut api API) get_template() vweb.Result
{
	template_name := api.query['name'] or { "" }

	if !os.exists("assets/templates/${template_name}.png") {
		return api.text("[ X ] Error, No template found!")
	}
	
	return api.file("template.png")
}

@['/price_logs']
pub fn (mut api API) price_logs() vweb.Result
{
	ip := api.query['ip'] or { api.ip() }
	
	changes 	:= os.read_lines("assets/logs/changes.log") or { [] }
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
	
	return api.text(os.read_file(src.suggestion_filepath) or { "" })
}

@['/save']
pub fn (mut api API) save_end() vweb.Result 
{
	lock api.guide { api.guide.save_db() }

	println("${utils.signal_colored(true)} Database has been saved....!")
	return api.text("Database saved!")
}

/*
	View Profile Using Username Endpoint
*/
@['/profile']
pub fn (mut api API) profile() vweb.Result
{
	// ip := api.query['ip'] or { api.ip() }
	// if ip != website_backend && ip != website_backend_ipv6 {
	// 	return api.text("This endpoint is for YoMarket WebSite Only!")
	// }

	username 	:= api.query['username'] or { "" }
	ip 			:= api.query['ip'] or { "" }

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	mut user := gd.find_profile(username)

	if user.username == "" {
		println("${utils.signal_colored(false)} Invalid username | Profile View\n\t=> ${username}\n\tIP: ${ip}")
		return api.text("[ X ] Error, Invalid information provided....!")
	}

	println("${utils.signal_colored(true)} Viewed | Profile View\n\t=> ${username}\n\tIP: ${ip}")
	return api.text(user.to_api())
}

/*
	Login Auth Endpoint Below
*/
@['/profile/auth']
pub fn (mut api API) auth() vweb.Result
{
	
	username 	:= api.query['username'] or { "" }
	password 	:= api.query['password'] or { "" }

	ip := api.query['ip'] or { api.ip() }

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	if username == "" || password == "" { 
		return api.text("[ X ] Error, Missing GET parameters")
	}

	mut user := gd.find_profile(username)

	/* Validating User */
	if user.username == username && user.password == password 
	{
		println("${utils.signal_colored(true)} Logged In | Profile Auth\n\t=> ${username}\n\tIP: ${ip}")
		lock api.guide {
			current_time := "${time.now()}".replace("-", "/").replace(" ", "-")
			mut g := db.Item{}
			api.guide.profiles[user.idx].activites << db.new_activity(db.Activity_T.logged_in, mut g, "", current_time, user.activites.len)
		}
		return api.text("${user.to_auth_str()}")
	}

	
	println("${utils.signal_colored(false)} Invalid info | Profile Auth\n\t=> ${username} | ${password}\n\tIP: ${ip}")
	return api.text("[ X ] Error, Invalid information provided!")
}

@['/profile/create']
pub fn (mut api API) profile_creation() vweb.Result
{
	username 		:= api.query['username'] or { "" }
	password 		:= api.query['password'] or { "" }
	yoworld_id		:= api.query['id'] or { "" }
	extra_info 		:= api.query['extra'] or { "" }
	ip 				:= api.query['ip'] or { api.ip() }
	mut gd 			:= src.Guide{}

	lock api.guide { gd = api.guide }

	if username == "" || password == "" || yoworld_id == "" {
		return api.text("[ X ] Error, Missing GET parameters")
	}

	mut profile_check := gd.find_profile(username)
	if profile_check.username != "" {
		println("${utils.signal_colored(false)} Invalid user creation attempt\n\t=> ${username} | ${password} | ${yoworld_id} | ${extra_info}\n\tIP: ${ip}")
		return api.text("[ X ] Error, Cannot create account with username ${username}! Username is already taken...!")
	}

	profile_info 	:= extra_info.split(",")
	mut profile 	:= db.create_profile(username, password, ip, yoworld_id, ...profile_info)
	if profile.username == username {
		lock api.guide { api.guide.profiles << profile }
		println("${utils.signal_colored(true)} Account created\n\t=> ${username} | ${yoworld_id} | ${extra_info}\n\tIP: ${ip}")
		return api.text("[ + ] Account created....!${profile.to_api()}")
	}

	println("${utils.signal_colored(false)} Invalid info | Profile creation attemp\n\t=> ${username} | ${yoworld_id} | ${extra_info}\n\tIP: ${ip}")
	return api.text("[ X ] Invalid operation")
}

/*
	mut user := gd.find_profile(username)
    gd.edit_profile_list(mut user, db.Settings_T.add_to_fs, db.Activity_T.fs_posted, mut gd.search("26295", false).results[0], "550m", "false", "false")
*/
@['/profile/edit/add']
pub fn (mut api API) edit_add_list() vweb.Result
{
	username 	:= api.query['username'] or { "" }
	password 	:= api.query['password'] or { "" }
	item_id		:= api.query['id'] or { "" }
	price 		:= api.query['price'] or { "" }
	list 		:= api.query['list'] or { "" }
	ip 			:= api.query['ip'] or { "" }

	if username == "" || password == "" || item_id == "" || list == "" {
		return api.text("[ X ] Error, Missing parameters....!")
	}

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	mut profile := gd.find_profile(username)
	mut edit_check := false

	if !(profile.username == username && profile.password == password)
	{
		println("${utils.signal_colored(false)} Invalid info | Profile list edit attempt\n\t=> ${username} | ${password} | ${item_id} | ${price} | ${list}\n\tIP: ${ip}")
		return api.text("[ X ] Error, Invalid information provided....!")
	}

	mut item_check := mut gd.search(item_id, false)
	mut fs_item := item_check.results[0]
	
	if item_check.r_type != ._exact {
		println("${utils.signal_colored(false)} Invalid item ID | Profile list edit attempt\n\t=> ${username} | ${password} | ${item_id} | ${price} | ${list}\n\tIP: ${ip}")
		return api.text("[ X ] Invalid item ID....!")
	}

	match list 
	{
		"fs" {
    		edit_check = gd.edit_profile_list(mut profile, db.Settings_T.add_to_fs, db.Activity_T.fs_posted, mut fs_item, price, "false", "false")
		}
		"wtb" {
			if price == "" { 
				println("${utils.signal_colored(false)} Invalid price | Profile list edit attempt\n\t=> ${username} | ${password} | ${item_id} | ${price} | ${list}\n\tIP: ${ip}")
				return api.text("[ X ] Error, Missing parameters....!") 
			}
    		edit_check = gd.edit_profile_list(mut profile, db.Settings_T.add_to_wtb, db.Activity_T.wtb_posted, mut fs_item, price, "false", "false")
		}
		"invo" {
    		edit_check = gd.edit_profile_list(mut profile, db.Settings_T.add_to_invo, db.Activity_T.invo_posted, mut fs_item)
		} else {}
	}

	if edit_check {
		println("${utils.signal_colored(true)} Item Added | Profile list edit\n\t=> ${username} | ${password} | ${item_id} | ${price} | ${list}\n\tIP: ${ip}")
		return api.text("[ + ] Item added!")
	}

	println("${utils.signal_colored(false)} Invalid operation | Profile list edit\n\t=> ${username} | ${password} | ${item_id} | ${price} | ${list}\n\tIP: ${ip}")
	return api.text("[ X ] Invalid operation....!")
}

/*
	mut user := gd.find_profile(username)
    gd.edit_profile_list(mut user, db.Settings_T.add_to_fs, db.Activity_T.fs_posted, mut gd.search("26295", false).results[0], "550m", "false", "false")
*/
@['/profile/edit/rm']
pub fn (mut api API) edit_rm_list() vweb.Result
{
	username 	:= api.query['username'] or { "" }
	password 	:= api.query['password'] or { "" }
	item_id		:= api.query['id'] or { "" }
	list 		:= api.query['list'] or { "" }
	ip			:= api.query['ip'] or { "" }

	if username == "" || password == "" || item_id == "" || list == "" {
		return api.text("[ X ] Error, Missing parameters....!")
	}

	mut gd := src.Guide{}
	lock api.guide { gd = api.guide }

	mut profile := gd.find_profile(username)
	mut edit_check := false

	if !(profile.username == username && profile.password == password)
	{
		println("${utils.signal_colored(false)} Invalid Info | Profile list removal edit\n\t=> ${username} | ${password} | ${item_id} | ${list}\n\tIP: ${ip}")
		return api.text("[ X ] Error, Invalid information provided....!")
	}

	mut item_check := mut gd.search(item_id, false)
	mut fs_item := item_check.results[0]
	
	if item_check.r_type != ._exact || "${fs_item.id}" != "${item_id}" {
		println("${utils.signal_colored(false)} Invalid item ID | Profile list removal edit\n\t=> ${username} | ${password} | ${item_id} | ${list}\n\tIP: ${ip}")
		return api.text("[ X ] Invalid item ID....!")
	}

	

	match list 
	{
		"fs" {
    		edit_check = gd.edit_profile_list(mut profile, db.Settings_T.rm_from_fs, db.Activity_T.fs_rm, mut fs_item, "0")
		}
		"wtb" {
    		edit_check = gd.edit_profile_list(mut profile, db.Settings_T.rm_from_wtb, db.Activity_T.wtb_rm, mut fs_item, "0")
		}
		"invo" {
    		edit_check = gd.edit_profile_list(mut profile, db.Settings_T.rm_from_invo, db.Activity_T.invo_rm, mut fs_item, "0")
		} else {}
	}

	if edit_check {
		println("${utils.signal_colored(true)} Item Removed | Profile list removal edit\n\t=> ${username} | ${password} | ${item_id} | ${list}\n\tIP: ${ip}")
		return api.text("[ + ] Item added!")
	}

	println("${utils.signal_colored(false)} Invalid operation | Profile list removal edit\n\t=> ${username} | ${password} | ${item_id} | ${list}\n\tIP: ${ip}")
	return api.text("[ X ] Invalid operation....!")
}