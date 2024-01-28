module src

import os
import time

import src.items
import src.utils

pub fn is_manager(ip string) bool
{
	manager_db := os.read_lines("db/managers.txt") or { [] }

	if ip in manager_db {
		return true
	}

	return false
}

pub fn (mut g Guide) add_suggestion(mut item items.Item, price_suggested string) bool
{
	mut db := os.open_file(utils.suggestion_filepath, "a") or { return false }
	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")

	db.write("('${item.name}','${item.id}','${price_suggested}','${current_time}')\n".bytes()) or { return false }
	db.close()

	return true
}

pub fn (mut g Guide) add_request(mut item items.Item)
{

}