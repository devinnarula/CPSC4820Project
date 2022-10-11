extends Node2D

class_name Player

var player_name = ""
var hitpoints = 100
	
func _init(name:String):
	player_name = name

func updateHealth(change:int, bar:ProgressBar):
	hitpoints += change
	bar.value = hitpoints
