import src

fn main()
{
	mut gd := src.build_guide()

	mut item := gd.search("cupid", false)

	for mut itm in item.results 
	{
		println(itm.item2str(" | "))
	}
}
