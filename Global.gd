extends Node

const SAVE_PATH = "user://savegame.sav"
const SECRET = "C220 Is the Best!"
var save_file = ConfigFile.new()

onready var HUD = get_node_or_null("/root/Game/UI/HUD")
onready var IceCubes = get_node_or_null("/root/Game/Coin_Container")
onready var Game = load("res://Game.tscn")
onready var IceCube = load("res://IceCubes/IceCube.tscn")


var save_data = {
	"general": {
		"score":0
		,"health":100
		,"icecubes":[]
	}
}


func _ready():
	update_score(0)
	update_health(0)

func update_score(s):
	save_data["general"]["score"] += s
	HUD.find_node("Score").text = "Score: " + str(save_data["general"]["score"])

func update_health(h):
	save_data["general"]["health"] += h
	HUD.find_node("Health").text = "Health: " + str(save_data["general"]["health"])

func restart_level():
	HUD = get_node_or_null("/root/Game/UI/HUD")
	IceCubes = get_node_or_null("/root/Game/Coin_Container")
	
	
	for c in IceCubes.get_children():
		c.queue_free()
	for c in save_data["general"]["icecubes"]:
		var icecube = IceCube.instance()
		icecube.position = str2var(c)
		IceCubes.add_child(icecube)
	update_score(0)
	update_health(0)
	get_tree().paused = false

# ----------------------------------------------------------
	
func save_game():
	save_data["general"]["icecubes"] = []
	for c in IceCubes.get_children():
		save_data["general"]["icecubes"].append(var2str(c.position))
	

	var save_game = File.new()
	save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, SECRET)
	save_game.store_string(to_json(save_data))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return
	save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, SECRET)
	var contents = save_game.get_as_text()
	var result_json = JSON.parse(contents)
	if result_json.error == OK:
		save_data = result_json.result
	else:
		print("Error: ", result_json.error)
	save_game.close()
	
	var _scene = get_tree().change_scene_to(Game)
	call_deferred("restart_level")
