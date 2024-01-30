module src

import os
import time
import net.http

pub const (
    search_filepath      = "logs/searches.log"
    changes_filepath     = "logs/changes.log"
    visits_filepath      = "logs/visits.log"
    suggestion_filepath  = "logs/suggestions.log"

	/* Discord API Webhook Endpoints */
	search_api = "https://discordapp.com/api/webhooks/1199621453256081491/cwIygRnaTn9hK9fvdG44O_sNmBqHF-UaNx-al2nklXPFjY2cWjAdvLW0N-Z30OSvcJlE"
	change_api = "https://discord.com/api/webhooks/1201347084591300639/xuHLzv6JjyMggubcTWXros2L4rjReG1KXQS-dhdGXMt4KbmDJimM6xOJ69dYNMYgWng-"

)

pub enum Log_T
{
	_null = 0x670001
	_visit = 0x670002
	_search = 0x670003
	_change = 0x670004
	_request = 0x670005
	_suggestion = 0x670006
}

pub enum App_T
{
	_null = 0x680001
	_bot = 0x680002
	_site = 0x680004
	_desktop = 0x680005
}

pub fn new_log(app_t App_T, log_t Log_T, args ...string)
{
	if args.len < 1 { return }

	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")
	app := app_to_str(app_t)
	mut db := os.open_append(get_db_path(log_t)) or { return }

	match app_t
	{
		._bot {
			db.write("('${app}','${args[0]}','${args[1]}','${args[2]}','${args[3]}','${current_time}')\n".bytes()) or { 0 } 
		}
		._site {
            db.write("('${app}','${args[0]}','${args[1]}','${args[2]}','${args[3]}','${current_time}')\n".bytes()) or { 0 }
		}
		._desktop {
            db.write("('${app}','${args[0]}','${args[1]}','${args[2]}','${args[3]}','${current_time}')\n".bytes()) or { 0 }
		} else {}
	}
	send_discord_msg(app_t, log_t, ...args)

	db.close()
}

pub fn send_discord_msg(app_t App_T, log_t Log_T, args ...string)
{
	if args.len < 1 { return }

	current_time := "${time.now()}".replace("-", "/").replace(" ", "-")
	mut json_format := os.read_file("json_format.txt") or { return }

	app := app_to_str(app_t)
	url := get_api(log_t)

	match app_t
	{
		._bot {
			return
		}
		._site {
            json_format = json_format.replace("{YM_APPLICATION_TYPE}", "${app}").replace("{CLIENTS_IP_ADDRESS}", args[0]).replace("{CLIENTS_SEARCH_QUERY}", args[1]).replace("{YM_RESULT_TYPE}", args[2]).replace("{YM_RESULT_COUNT}", args[3]).replace("{CURRENT_TIME}", current_time)
			if log_t == ._change {
				json_format = json_format.replace("{YM_APPLICATION_TYPE}", "${app}").replace("{CLIENTS_IP_ADDRESS}", args[0]).replace("{CLIENTS_SEARCH_QUERY}", args[1]).replace("\"Results Type\"", "\"Old Price\"").replace("{YM_RESULT_TYPE}", args[2]).replace("\"Results Count\"", "\"New Price\"").replace("{YM_RESULT_COUNT}", args[3]).replace("{CURRENT_TIME}", current_time)
			}
		}
		._desktop {
			return
		} else {}
	}

	http.post_json(url, json_format) or { return }
}

pub fn read_log_db_count(log_t Log_T) int 
{
	match log_t
	{
		._visit {
			return (os.read_lines(visits_filepath) or { [] }).len
		}
		._search {
			return (os.read_lines(search_filepath) or { [] }).len
		}
		._change {
			return (os.read_lines(changes_filepath) or { [] }).len
		}
		._request {
			return (os.read_lines(suggestion_filepath) or { [] }).len
		} else { return 0 }
	}

	return 0
}

pub fn app_to_str(app_t App_T) string
{
	match app_t 
	{
		._bot {
			return "DISCORD_BOT"
		}
		._site {
			return "WEB_STIE"
		}
		._desktop {
			return "DESKTOP"
		} else {}
	}

	return ""
}

pub fn get_db_path(log_t Log_T) string
{
	match log_t
	{
		._visit {
			return visits_filepath
		}
		._search {
			return search_filepath
		}
		._change {
			return changes_filepath
		}
		._request {
			return suggestion_filepath
		} else {}
	}

	return ""
}

pub fn get_api(log_t Log_T) string
{
	match log_t
	{
		._visit {
			return ""
		}
		._search {
			return search_api
		}
		._change {
			return change_api
		}
		._request {
			return ""
		} else {}
	}

	return ""
}