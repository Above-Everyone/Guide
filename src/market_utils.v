module src

import os
import time

import src.db

pub fn is_manager(ip string) bool
{
	manager_db := os.read_lines("db/managers.txt") or { [] }

	if ip in manager_db {
		return true
	}

	return false
}

pub fn (mut g Guide) add_suggestion(mut item db.Item, price_suggested string, user_ip string) bool
{
	mut db_v := os.open_file(suggestion_filepath, "a") or { return false }
	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")

	db_v.write("('${item.name}','${user_ip}','${item.id}','${price_suggested}','${current_time}')\n".bytes()) or { return false }
	db_v.close()

	return true
}

pub fn (mut g Guide) add_request(mut item db.Item)
{

}