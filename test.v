import net.http
import x.json2 as jsn

import src.items

fn main()
{
    mut ywinfo_prices := []items.YW_INFO_PRICES{}
    id := "26295"
    mut check := http.get_text("https://api.yoworld.info/api/items/${id}")

    lines := check.split(",")

	mut staff_item_price_proposal_id := false
    for line in lines
    {
        mut line_arg := line.replace("{", "").replace("}", "").replace("\"", "").replace("]", "").replace("[", "").replace("\n", "").split(":")
        // println(line_arg[0])
		if "staff_item_price_proposal" in line_arg { staff_item_price_proposal_id = true }

        if staff_item_price_proposal_id {
            if line_arg[0] in ['updated_at', 'item_id', 'price', 'approved', 'username', 'level'] {
                println("${line_arg[0]}: ${line_arg[1]}")
            }
        }
        
    }
}
