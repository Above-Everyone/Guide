import os


fn main() 
{
	mut db := os.read_lines("db/items.txt") or { "" }

	lines := db.replace("(", "").replace(")", "").replace("").split("\n")

	for line in lines 
	{
		mut line_arg := line.split(",")
	}
}