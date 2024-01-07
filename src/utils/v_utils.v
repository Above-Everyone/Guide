module utils

/*
	Function designed to be used in 'string' match block
*/
pub fn match_starts_with(content string, match_start string) string
{
	mut new := content
	if !content.starts_with(match_start) { new = match_start }
	return new
}