module db

import net.http

/*
	[@DOC]
    pub fn (mut i Item) ywinfo_price_logs()

	Description:
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