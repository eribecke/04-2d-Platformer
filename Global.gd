extends Node

const SAVE_PATH = "user://savegame.sav"
const SECRET = "C220 Is the Best!"
var save_file = ConfigFile.new()
onready var HUD = get_node_or_null("/root/Game/UI/HUD")
onready var Game = load("res://Game.tscn")


