extends Node2D

class_name Player

var player_name = ""
var hitpoints = 100
var hunger = 100
var healthbar:ProgressBar
var hungerbar:ProgressBar
var body:KinematicBody2D
var movement = 0
var sword = 1
var bow = 0.5

	
func _init(name:String, bar_health:ProgressBar, bar_hunger:ProgressBar, kinematicBody:KinematicBody2D):
	player_name = name
	healthbar = bar_health
	hungerbar = bar_hunger
	body = kinematicBody

func updateHealth(change:int):
	hitpoints += change
	healthbar.value = hitpoints
	if hitpoints <= 20:
		var styleBox = healthbar.get("custom_styles/fg")
		styleBox.bg_color = Color(255, 0, 0)
	else:
		var styleBox = healthbar.get("custom_styles/fg")
		styleBox.bg_color = Color(0, 255, 0)
		
func updateHunger(change:int):
	hunger += change
	hungerbar.value = hunger
	if hunger <= 20:
		var styleBox = hungerbar.get("custom_styles/fg")
		styleBox.bg_color = Color(255, 0, 0)
	else:
		var styleBox = hungerbar.get("custom_styles/fg")
		styleBox.bg_color = Color(0, 255, 0)
		
		
