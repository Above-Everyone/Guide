module template

import src.db

pub struct Template
{
	pub mut:
		items 		db.Item
		price		string
}

pub fn new_template(items []Template) db.Response
{
	
}