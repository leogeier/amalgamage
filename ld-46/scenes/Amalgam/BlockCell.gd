extends Reference

class_name BlockCell


var pos
var type
var node
var polygon


func _init(_pos, _type, _node, length):
	pos = _pos
	type = _type
	node = _node
	
	var halfLen = length / 2.0
	var center = _pos * length
	polygon = PoolVector2Array([ \
		center + Vector2(-halfLen, -halfLen), \
		center + Vector2( halfLen, -halfLen), \
		center + Vector2( halfLen,  halfLen), \
		center + Vector2(-halfLen,  halfLen) ])
