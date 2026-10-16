class_name CookStrings

static var tag_regex: RegEx = RegEx.create_from_string("(*UTF)[^\\p{L}]")
static var numberless_regex: RegEx = RegEx.create_from_string("(*UTF)\\p{N}")

static func to_tag(name: String) -> String:
	var start := name.rfindn("/") + 1
	var end := name.length()
	var last_dot := name.rfindn(".")
	if last_dot > 0 and last_dot > start:
		end = last_dot
	var sub := name.substr(start, end - start)
	return tag_regex.sub(sub, "-", true).to_upper()
	
	
static func to_tag_numberless(name: String) -> String:
	var tag := to_tag(name)
	return numberless_regex.sub(tag, "", true)
	
