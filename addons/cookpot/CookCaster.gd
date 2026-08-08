extends Node

const TOPIC_ALL := "*"

class Listener:
	var topic: String
	var callable: Callable

var listeners: Array[Listener] = []

func listen(topic: String, callable: Callable) -> void:
	if index_of(callable) > 0:
		return
	var listener := Listener.new()
	listener.topic = topic
	listener.callable = callable
	listeners.append(listener)
	
	
func unlisten(callable: Callable) -> void:
	var index = index_of(callable)
	if index < 0:
		return
	listeners.remove_at(index)
	
	
func cast(topic: String, data: Variant) -> void:
	print("CookCast: ", topic, ": ", data)
	for i in range(listeners.size()):
		if listeners[i].topic == topic:
			listeners[i].callable.call(data)
		if listeners[i].topic == TOPIC_ALL:
			listeners[i].callable.call(topic, data)
	
	
func index_of(callable: Callable) -> int:
	for i in range(listeners.size()):
		if listeners[i].callable.get_object() != callable.get_object():
			continue
		if listeners[i].callable.get_method() != callable.get_method():
			continue
		return i
	return -1
