module utils

import os

pub fn is_manager(ip string) bool
{
	manager_db := os.read_lines("db/managers.txt") or { [] }

	if ip in manager_db {
		return true
	}

	return false
}