class_name CookStrings

static var _numbered := _make_lut(true)
static var _numberless := _make_lut(false)


static func to_tag(name: String) -> String:
	var id := _tag_name(name).replace("-", "_").replace(" ", "_").replace(".", "_")
	if id.is_valid_ascii_identifier():
		return id.to_upper().replace("_", "-")
	return _convert(name, _numbered, false)


static func to_tag_numberless(name: String) -> String:
	return _convert(name, _numberless, true)


static func tag_match(a: String, b: String) -> bool:
	return a == b or to_tag(a) == to_tag(b)


static func tag_match_numberless(a: String, b: String) -> bool:
	return a == b or to_tag_numberless(a) == to_tag_numberless(b)


static func _make_lut(keep_digits: bool) -> PackedByteArray:
	var lut := PackedByteArray()
	lut.resize(128)
	lut.fill(45)
	for c in range(65, 91):
		lut[c] = c
		lut[c + 32] = c
	for c in range(48, 58):
		lut[c] = c if keep_digits else 0
	return lut


static func _tag_name(name: String) -> String:
	var start := name.rfind("/") + 1
	var dot := name.rfind(".")
	return name.substr(start, (dot if dot > start else name.length()) - start)


static func _tag_bytes(name: String) -> PackedByteArray:
	var sub := _tag_name(name)
	var buf := sub.to_utf8_buffer()
	if buf.size() == sub.length():
		return buf
	push_error("Tag names must be ASCII: %s" % name)
	buf.resize(sub.length())
	for i in sub.length():
		buf[i] = mini(sub.unicode_at(i), 127)
	return buf


static func _convert(name: String, lut: PackedByteArray, trim: bool) -> String:
	var buf := _tag_bytes(name)
	var end := buf.size()
	if trim:
		while end > 0 and lut[buf[end - 1]] <= 45:
			end -= 1
	var n := 0
	for i in end:
		var c := lut[buf[i]]
		if c:
			buf[n] = c
			n += 1
	buf.resize(n)
	return buf.get_string_from_ascii()
