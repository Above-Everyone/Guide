import src

fn main() {
	mut gd := src.build_guide()

	mut profile := gd.find_profile("Billy")

	println(profile.to_str())
}