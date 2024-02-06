import src
import src.db

fn main() {
	mut gd := src.build_guide()
	mut profile := gd.find_profile("billy")

	//println(profile.list_to_str()()) // Output Profile Invo/FS/WTB List
	//println(profile.p2db()) // Output Profile Settings
	println(profile.to_db()) // Output Full Profile Struct
}
