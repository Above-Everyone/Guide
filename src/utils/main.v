module utils

/*
	Function designed to be used in 'string' match block
*/
pub fn match_starts_with(content string, match_start string) string
{
	if content.contains(match_start) { return content } // true
	return match_start // false
}

/*
	ANSI COLORS FOR CONSOLE OUTPUT
*/
pub fn signal_colored(b bool) string
{
	if b {
		return "\x1b[32m[ + ]\x1b[37m"
	}

	return "\x1b[31m[ X ]\x1b[37m"
}