import src
import src.db

fn main() {
	mut gd := src.build_guide()

	gd.query = "25178"
	mut item := gd.find_by_id()

	mut profile := gd.find_profile("billy")
	mut check := gd.edit_profile_list(mut profile, db.Settings_T.add_to_fs, db.Activity_T.fs_posted, mut item, "TEST", "false", "false")

	if !check {
		println("Something went wrong adding item to user's list!")
		return
	}

	println(profile.list_to_str()) // Output Full Profile Struct
	println("Item added!")
}
