module str_utils

/*
	Function designed to be used in 'string' match block
*/
pub fn match_starts_with(content string, match_start string) string
{
	if content.contains(match_start) { return content } // true
	return match_start // false
}