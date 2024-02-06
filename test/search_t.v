import os
import src

fn main()
{
	args := os.args.clone()

	query := "${args}".replace("['", "").replace("']", "").replace("', '", " ").replace("${args[0]}", "").trim_space()
	mut gd := src.build_guide()

	mut item := gd.search(query, false)

	for mut itm in item.results 
	{
		println("Results: " + itm.item2str(" | "))
	}
	println("Result Type: ResultType.${item.r_type} | Found: ${item.results.len}")
}
