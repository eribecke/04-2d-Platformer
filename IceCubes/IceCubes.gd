extends Area2D

export var score = 100

func _ready():
	pass 


func _on_IceCube_body_entered(body):
	var ice_sound = get_node_or_null("/root/Game/IceSound")
	if ice_sound != null:
		ice_sound.play()
	if body.name == "Player":
		Global.update_score(score)
		queue_free()
