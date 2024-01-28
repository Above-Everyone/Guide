module items 

import net.http
import x.json2 as jsn

pub struct Item
{
    pub mut:
        idx             int
        /*
            General Item Information
        */
        name   			string
        id     			int
        url    			string
        price  			string
        update 			string

        /*
            Actions you can do with the ITEM
        */
        is_tradable 	int
        is_giftable 	int

        /*
            In-store Information
        */
        in_store       	bool
        store_price    	string
        gender         	string
        xp             	string
        category       	string

		yw_info_prices	[]YW_INFO_PRICES
}

pub struct YW_INFO_PRICES
{
	pub mut:
		price			string
		approve 		bool
		approved_by		string
		timestamp		string
}

pub struct Prices
{
    pub mut:
        username        string
        old_price       string
        old_update      string
        item            Item
}

pub struct YW_INFO_LOG
{
    pub mut:
        item    Item
        prices  []string
        update  []string
        status  []string
}

/*
	[DOC]

	Create a new 'Item' struct providing an array of item information
*/
pub fn new(arr []string) Item 
{
	if arr == [] { return Item{} }

	if arr.len == 5 
	{
		return Item{
			name: arr[0],
			id: arr[1].int(),
			url: arr[2],
			price: arr[3],
			update: arr[4]
		}
	}
	
	return Item{
		name: arr[0],
		id: arr[1].int(),
		url: arr[2],
		price: arr[3],
		update: arr[4]
		is_tradable: arr[5].int(),
		is_giftable: arr[6].int(),
		in_store: arr[7].bool(),
		store_price: arr[8],
		gender: arr[9],
		xp: arr[10],
		category: arr[11]
	}
}

/*
	[@DOC]

	Add more information besides the basics
*/
pub fn (mut i Item) add_extra_info(add_main_info bool) bool 
{
	results := http.post_form("https://yoworlddb.com/scripts/getItemInfo.php", {"iid": "${i.id}"}) or { http.Response{} }

    if results.body.starts_with("{") == false || results.body.ends_with("}") == false {
        println("[ X ] (INVALID_JSON) Error, Unable to get item information....!\n\n{results}")
        return false
	}

	json_data := (jsn.raw_decode(results.body) or { "" }).as_map()
	response := (jsn.raw_decode("${json_data['response'] or {0}}") or { "" }).as_map()

	if add_main_info {
		i.name = (response['item_name'] or { "" }).str()
		item_id := "${i.id}"
		i.url = "https://yw-web.yoworld.com/cdn/items/${item_id[0..2]}/${item_id[2..4]}/${item_id}/${item_id}_60_60.gif"
	}

	i.gender = (response['gender'] or { "" }).str()
    i.is_tradable = (response['is_tradable'] or { "" }).int()
    i.is_giftable = (response['can_gift'] or { "" }).int()
    i.category = (response['category'] or { "" }).str()
    i.xp = (response['xp'] or { "" }).str()

	if (response['active_in_store'] or { 0 }).str() == "1" { i.in_store = true } 
    else { i.in_store = true }

    if (response['price_coins'] or { 0 }).str() != "0" { i.store_price = (response['price_coins'] or { 0 }).str() + "c" }
    else if (response['price_cash'] or { 0 }).str() != "0" { i.store_price = (response['price_cash'] or { 0 }).str() + "yc" }
    else { i.store_price = "0" }

	return true
}

/*
	[@DOC]

	Retrieve all price changes
*/
pub fn (mut i Item) price_logs() []string 
{
	
	return ['']
}

/*
	[@DOC]

	Retrieve all YW.Info's price changes
*/
pub fn (mut i Item) ywinfo_price_logs()
{
	mut check := http.get_text("https://api.yoworld.info/api/items/${i.id}")

    lines := check.split(",")

	mut start_scraping := false
    mut price_info := []string{}
    for line in lines
    {
        mut line_arg := line.replace("{", "").replace("}", "").replace("\"", "").replace("[", "").replace("\n", "").split(":")
		if "staff_item_price_proposal" in line_arg { start_scraping = true }


        if line_arg.len >= 2 && start_scraping {
            match line_arg[0] {
                "updated_at" {
                    if price_info.len == 0 && line_arg[1] != "false" { 
                        price_info << line_arg[1]
                    }
                    
                }
                "price" {
                    if price_info.len == 1 && line_arg[1] != "false" { 
                        price_info << line_arg[1]
                    }
                }
                "approved" {
                    if price_info.len == 2 {
                        price_info << line_arg[1]
                    }
                }
                "username" {
                    if price_info.len == 3 && line_arg[1] != "false" {
                        price_info << line_arg[1]
                        i.yw_info_prices << i.parse_ywinfo_prices(price_info)
                        price_info = []string{}
                    }
                } else {}
            }
        }
    }
}

pub fn (mut i Item) parse_ywinfo_prices(arr []string) YW_INFO_PRICES
{
    return YW_INFO_PRICES{price: arr[1], approve: arr[2].bool(), approved_by: arr[3], timestamp: arr[0]}
}

/*
	[@DOC]

	Output the item in string type however you want using a delimiter
*/
pub fn (mut i Item) item2str(delm string) string
{
	return "[${i.name}${delm}${i.id}${delm}${i.url}${delm}${i.price}${delm}${i.update}${delm}${i.is_tradable}${delm}${i.is_giftable}${delm}${i.in_store}${delm}${i.store_price}${delm}${i.gender}${delm}${i.xp}${delm}${i.category}]"
}

pub fn (mut i Item) ywinfo_prices_2str() string 
{
	mut new := ""
	for price in i.yw_info_prices
	{
		new += "${price.price},${price.approve},${price.approved_by},${price.timestamp}\n"
	}
	
	return new
}

/*
	[@DOC]

	Incase, it needs to be saved
*/
pub fn (mut i Item) item2profile() string
{
	return "${i.name},${i.id},${i.url},${i.price},${i.update}"
}

/*
	[@DOC]

	Incase, it needs to be saved
*/
pub fn (mut i Item) to_db() string
{
	return "('${i.name}','${i.id}','${i.url}','${i.price}','${i.update}')"
}

/*
	[@DOC]

	Output the item in string type for API
*/
pub fn (mut i Item) item2api() string
{
	return "[${i.name},${i.id},${i.url},${i.price},${i.update},${i.is_tradable},${i.is_giftable},${i.in_store},${i.store_price},${i.gender},${i.xp},${i.category}]"
}