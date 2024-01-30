module src

import src.db

pub enum ResultType
{
	_none					= 0
	_exact 					= 1
	_extra 					= 2
	_item_failed_to_update	= 3
	_item_updated			= 4
}

pub struct Response
{
	pub mut:
		r_type		ResultType
		results		[]db.Item
}

pub fn result_t(res_t ResultType) string
{
	match res_t
	{
		._exact {
			return "ResultType._exact"
		}
		._extra {
			return "ResultType._extra"
		}
		._item_failed_to_update {
			return "ResultType._item_failed_to_update"
		}
		._item_updated {
			return "ResultType._item_updated"
		} else {}
	}
	return ""
}