import src
import src.db

fn main() {
	mut gd := src.build_guide()

	gd.query = "25178"
	mut item := gd.find_by_id()

	//mut profile := gd.find_profile("Billy")
	mut profile := db.create_profile("test", "test", "5.5.5.5", "453453", "YW_NAME", "DISCORDNAME", "DISCORDID", "FB", "FBID")

	//println(profile.list_to_str()()) // Output Profile Invo/FS/WTB List
	//println(profile.p2db()) // Output Profile Settings
	println(profile.to_db()) // Output Full Profile Struct

	/* Adding an Item To FS */
	//gd.edit_profile_list(mut profile, db.Settings_T.add_to_fs, db.Activity_T.fs_posted, mut item, "550m", "false", "false")

	profile.save_profile()
}
