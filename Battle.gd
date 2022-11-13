extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const DICE := [14, 17, 16, 13, 12, 15]

var rng = RandomNumberGenerator.new()

var DICE_CELL:Vector2
var DICE_CELL2:Vector2
var rolled = false
var rolled1 = false
var rolled2 = false
var dice_val_attack = 0
var dice_val_defend = 0
const CLICK_TO_ROLL := 9
var attack_count = 0

var attacker
var defender

onready var attack_sprite
onready var defend_sprite
onready var attack_Kbody
onready var defend_Kbody




# Called when the node enters the scene tree for the first time.
func _ready():
	global.game_already_started = true

	get_attacker()
	get_defender()
	get_background()
	rng.randomize()
	call_deferred("setup_dice")
	set_invis_chars()
	attack_Kbody.visible = true
	defend_Kbody.visible = true
	if defender.player_name == "Japan":
		defend_sprite.position.x += 1390 - 932
	elif defender.player_name == "Viking":
		defend_sprite.position.x += 1430 - 972
	elif defender.player_name == "Egypt":
		defend_sprite.position.x += 1398 - 936
	elif defender.player_name == "Greece":
		defend_sprite.position.x += 1415 - 959
	defend_sprite.flip_h = true
	attack_sprite.position.y += 100
	defend_sprite.position.y += 100
	
	$Player1Health.value = attacker.hitpoints
	$Player2Health.value = defender.hitpoints

	
func get_attacker():
	if global.current_attacker == "Japan":
		attacker = global.players[0]
		attack_sprite = $JapanPlayer/AnimatedSprite
		attack_Kbody = $JapanPlayer
	elif global.current_attacker == "Viking":
		attacker = global.players[1]
		attack_sprite = $VikingPlayer/AnimatedSprite
		attack_Kbody = $VikingPlayer
	elif global.current_attacker == "Egypt":
		attacker = global.players[2]
		attack_sprite = $EgyptPlayer/AnimatedSprite
		attack_Kbody = $EgyptPlayer
	elif global.current_attacker == "Greece":
		attacker = global.players[3]
		attack_sprite = $GreecePlayer/AnimatedSprite
		attack_Kbody = $GreecePlayer

func get_defender():
	if global.current_defender == "Japan":
		defender = global.players[0]
		defend_sprite = $JapanPlayer/AnimatedSprite
		defend_Kbody = $JapanPlayer
	elif global.current_defender == "Viking":
		defender = global.players[1]
		defend_sprite = $VikingPlayer/AnimatedSprite
		defend_Kbody = $VikingPlayer
	elif global.current_defender == "Egypt":
		defender = global.players[2]
		defend_sprite = $EgyptPlayer/AnimatedSprite
		defend_Kbody = $EgyptPlayer
	elif global.current_defender == "Greece":
		defender = global.players[3]
		defend_sprite = $GreecePlayer/AnimatedSprite
		defend_Kbody = $GreecePlayer
		
func set_invis_chars():
	if global.current_attacker != "Japan" and global.current_defender != "Japan":
		$JapanPlayer/AnimatedSprite.visible = false
	if global.current_attacker != "Viking" and global.current_defender != "Viking":
		$VikingPlayer/AnimatedSprite.visible = false
	if global.current_attacker != "Egypt" and global.current_defender != "Egypt":
		$EgyptPlayer/AnimatedSprite.visible = false
	if global.current_attacker != "Greece" and global.current_defender != "Greece":
		$GreecePlayer/AnimatedSprite.visible = false
		
func setup_dice():
	var cells = $TileMap1.get_used_cells()
	for cell in cells:
		var index = $TileMap1.get_cell(cell.x, cell.y)
		#print("index" +index)
		match index:
			CLICK_TO_ROLL:
				#roll_dice(cell, self)
				if DICE_CELL:
					DICE_CELL2 = cell
				else:
					DICE_CELL = cell
					
func roll_dice(coord:Vector2):
	#dice_animation(coord)
	var dice = rng.randi_range(0,5)
	print(dice+1)
	$TileMap1.set_cell(coord.x, coord.y, DICE[dice])
	return( dice+1)


func dice_animation(coord:Vector2):	
	for i in range(0,20):
		var dice = rng.randi_range(0,5)
	
		$TileMap1.set_cell(coord.x, coord.y, DICE[dice])
		yield(get_tree().create_timer(0.05), "timeout")

func _input(event):
	if event is InputEventMouseButton:
	
		var click = $TileMap1.world_to_map($TileMap1.to_local(event.position)) 
		if 0<=click.x-DICE_CELL.x && click.x-DICE_CELL.x<=3 && 0<=click.y-DICE_CELL.y && click.y-DICE_CELL.y<=3&& $TileMap1.get_cell(DICE_CELL.x, DICE_CELL.y) == CLICK_TO_ROLL:
			dice_val_attack = roll_dice(DICE_CELL)
		
			rolled1 = true
			rolled = rolled1 and rolled2
		
		if 0<=click.x-DICE_CELL2.x && click.x-DICE_CELL2.x<=3 && 0<=click.y-DICE_CELL2.y && click.y-DICE_CELL2.y<=3&& $TileMap1.get_cell(DICE_CELL2.x, DICE_CELL2.y) == CLICK_TO_ROLL:
			dice_val_defend = roll_dice(DICE_CELL2)

			rolled2 = true
			rolled = rolled1 and rolled2
		
		if rolled:
			attack()
			rolled = false
		
func attack():
	attack_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	defend_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished_defend")
	#if rolled:
		#print(String(dice_val_attack) +"dice_val")

	#for i in range (0,max(dice_val_attack-1,1)):
	attack_sprite.play("attack")
	attack_count+=1
	defend_sprite.play("take_hit")
	updateHealth()
			
			#yield($JapanPlayer/AnimatedSprite,"animation_finished")
			#$JapanPlayer/AnimatedSprite.play("idle")

func get_background():
	if global.battle_location == "Japan":
		$JapanBack.visible = true
	elif global.battle_location == "Viking":
		$VikingBack.visible = true
	elif global.battle_location == "Egypt":
		$EgyptBack.visible = true
	elif global.battle_location == "Greece":
		$GreeceBack.visible = true
		#rolled = false
func updateHealth():
	var damage = attacker.sword * 10
	defender.hitpoints -= damage
	$Player2Health.value = defender.hitpoints
	if defender.hitpoints <= 20:
		var styleBox = $Player2Health.get("custom_styles/fg")
		styleBox.bg_color = Color(255, 0, 0)
	else:
		var styleBox = $Player2Health.get("custom_styles/fg")
		styleBox.bg_color = Color(0, 255, 0)
		
		
func _on_AnimatedSprite_animation_finished():
	if (attack_count < max(dice_val_attack-dice_val_defend,1)):
		attack_sprite.play('attack')
		updateHealth()
		#Egypt.play("take_hit")
		attack_count+=1
		
	elif attack_sprite.animation != 'idle':
		attack_sprite.play('idle')

func _on_AnimatedSprite_animation_finished_defend():
	if (attack_count < max(dice_val_attack-dice_val_defend,1)):
		defend_sprite.play("take_hit")
		#Egypt.play("take_hit")
		#attack_count+=1
	elif defend_sprite.animation != 'idle':
		defend_sprite.play('idle')
		update_singleton_health()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://GameMap.tscn")
	
		

	
	
		


func update_singleton_health():
	var dead
	if defender.hitpoints <= 0:
		dead = true
	if global.current_defender == "Japan":
		global.players[0].hitpoints = defender.hitpoints
		if dead and !(0 in global.dead_players):
			global.dead_players.append(0)
	elif global.current_defender == "Viking":
		global.players[1].hitpoints = defender.hitpoints
		if dead and !(1 in global.dead_players):
			global.dead_players.append(1)
	elif global.current_defender == "Egypt":
		global.players[2].hitpoints = defender.hitpoints
		if dead and !(2 in global.dead_players):
			global.dead_players.append(2)
	elif global.current_defender == "Greece":
		global.players[3].hitpoints = defender.hitpoints
		if dead and !(3 in global.dead_players):
			global.dead_players.append(3)
	
