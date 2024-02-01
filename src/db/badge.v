module db

pub enum Badges 
{
	null = 0x00201
	verified = 0x00202
	trusted = 0x00203
	reputation = 0x00204

	admin = 0x00205
	owner = 0x00206

	// crew
	ae = 0x00207
	pnkm = 0x00208
	nmdz = 0x00209
}

pub fn badge2str(b Badges) string 
{
	match b 
	{
		.verified {
			return "verified"
		}
		.trusted {
			return "trusted"
		}
		.reputation {
			return "reputation"
		}
		.admin {
			return "admin"
		}
		.owner {
			return "owner"
		} else { return "" }
	}

	return ""
}