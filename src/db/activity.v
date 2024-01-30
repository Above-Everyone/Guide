module db

pub struct Activity 
{
	pub mut:
		i_idx		int
		act_t 		Activity_T
		item		Item
		price		string
		timestamp 	string

		// validating trades
		seller_confirmation	bool
		buyer_confirmation	bool
}

pub fn new_activity(actt Activity_T, mut itm Item, p string, t string, idx int, args ...string) Activity
{
	mut act := Activity{i_idx: idx, act_t: actt, item: itm, price: p, timestamp: t}

	if args.len == 2 {
		act.seller_confirmation = args[0].bool()
		act.buyer_confirmation = args[1].bool()
	}
	return act
}

pub fn activityt2str(act_t Activity_T) string 
{
	match act_t
	{
		.item_sold {
			"item_sold"
		}
		.item_bought {
			"item_bought"
		}
		.item_viewed {
			"item_viewed"
		}
		.price_change {
			"price_change"
		} else {}
	}
	return ""
}

pub fn (mut a Activity) activity2str() string
{
	mut activity_str := "('${a.i_idx},'${a.act_t}','${a.item.item2profile()}','${a.price}','${a.timestamp}')"

	if "${a.act_t}" == "item_sold" || "${a.act_t}" == "item_bought" {
		activity_str = activity_str.replace("${a.price}", "${a.price}','${a.seller_confirmation}','${a.buyer_confirmation}")
	}
	return activity_str
}