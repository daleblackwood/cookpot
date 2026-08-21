class_name CookSceneUtils


static func get_ancestor(node: Node, type: Variant) -> Node:
	var parent := node
	while parent:
		if is_instance_of(parent, type):
			return parent
		parent = parent.get_parent()
	return null
	
	
static func find_type(node: Node, type: Variant) -> Node:
	if is_instance_of(node, type):
		return node
	for child in node.get_children():
		var child_result := find_type(child, type)
		if child_result:
			return child_result
	return null


static func make_elements(elements: Array, count: int) -> void:
	if elements.size() < 1:
		push_error("must be at least one element")
	var first: Node = elements[0]
	while elements.size() < count:
		var element := first.duplicate()
		element.name = "%s%d" % [first.name, elements.size()]
		elements.append(element)
		first.add_sibling(element)
	while elements.size() > maxi(1, count):
		var element = elements.pop_back()
		first.get_parent().remove_child(element)
