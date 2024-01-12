module items 

import os
import time

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
pub fn (mut i Item) add_extra_info() bool 
{
	return false
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
pub fn (mut i Item) ywinfo_price_logs() []string
{
	return ['']
}

/*
	[@DOC]

	Output the item in string type however you want using a delimiter
*/
pub fn (mut i Item) item2str(delm string) string
{
	return "[${i.name}${delm}${i.id}${delm}${i.url}${delm}${i.price}${delm}${i.update}${delm}${i.is_tradable}${delm}${i.is_giftable}${delm}${i.in_store}${delm}${i.store_price}${delm}${i.gender}${delm}${i.xp}${delm}${i.category}]"
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