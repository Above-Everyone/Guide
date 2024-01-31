module db

pub struct WTB 
{
	pub mut:
		posted_timestamp	string
		wtb_price			string
		item				Item

		buyer_confirmation  	string
		seller_confirmation 	string
		confirmed_transaction	bool
}