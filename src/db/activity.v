module db

pub enum Activity_T 
{
	null 			= 0x690000

	/* TRADING ACTIONS */
	item_sold 		= 0x690001
	item_bought		= 0x690002
	item_viewed		= 0x690003

	/* MISC ACTIONS */
	price_change	= 0x690004
	logged_in 		= 0x690005

	/* POSTING ACTIONS */
	fs_posted		= 0x690006
	wtb_posted		= 0x690007
	invo_posted		= 0x690008

	/* RM ACTIONS */
	fs_rm			= 0x690009
	wtb_rm			= 0x690010
	invo_rm			= 0x690011
}

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
	mut act := Activity{i_idx: idx, act_t: actt, timestamp: t}

	if p != "" { act.price = p }
	if itm.name != "" { act.item = itm }

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
		}
		.logged_in {
			"logged_in"
		}
		.fs_posted {
			"fs_posted"
		}
		.wtb_posted {
			"wtb_posted"
		}
		.invo_posted {
			"invo_posted"
		} else {}
	}
	return ""
}

pub fn activityt2db(act_t Activity_T) string 
{
	match act_t
	{
		.item_sold {
			return "SOLD"
		}
		.item_bought {
			return "BOUGHT"
		}
		.item_viewed {
			return "VIEWED"
		}
		.price_change {
			return "CHANGE"
		}
		.logged_in {
			return "LOGGED_IN"
		}
		.fs_posted {
			return "FS_POSTED"
		}
		.wtb_posted {
			return "WTB_POSTED"
		}
		.invo_posted {
			return "INVO_POSTED"
		} else {}
	}
	return ""
}

pub fn (mut a Activity) activity2str() string
{
	mut activity_str := "('${a.i_idx},'${a.act_t}','${a.timestamp}')"

	if a.item.name != "" {
		activity_str = "('${a.i_idx},'${a.act_t}','${a.item.item2profile()}','${a.timestamp}')"
	}

	if "${a.act_t}" == "item_sold" || "${a.act_t}" == "item_bought" || "${a.act_t}" == "fs_posted" || "${a.act_t}" == "wtb_posted" {
		activity_str = "('${a.i_idx},'${a.act_t}','${a.item.item2profile()}','${a.price}','${a.seller_confirmation.str()}','${a.buyer_confirmation.str()}','${a.timestamp}')"
	}

	return activity_str
}

pub fn (mut a Activity) activity2db() string
{
	c := activityt2db(a.act_t)
	println("${a.act_t} ${c}")
	mut activity_str := "('${a.i_idx},'${c}','${a.timestamp}')"

	if a.item.name != "" {
		activity_str = "('${a.i_idx},'${c}','${a.item.item2profile()}','${a.timestamp}')"
	}

	if "${a.act_t}" == "item_sold" || "${a.act_t}" == "item_bought" || "${a.act_t}" == "fs_posted" || "${a.act_t}" == "wtb_posted" {
		activity_str = "('${a.i_idx},'${c}','${a.item.item2profile()}','${a.price}','${a.seller_confirmation.str()}','${a.buyer_confirmation.str()}','${a.timestamp}')"
	}

	return activity_str
}