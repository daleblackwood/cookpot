class_name CookStrings


static func to_tag(name: String, numbers := true) -> String:
	var start = name.rfindn("/") + 1
	var end = name.length()
	var last_dot = name.rfindn(".")
	if last_dot > 0 and last_dot > start:
		end = last_dot
	var result = ""
	for i in range(start, end):
		var c = name[i].to_lower()
		if (c < 'a' or c > 'z') and (not numbers or c < '0' or c > '9'):
			continue
		result += c
	return result
