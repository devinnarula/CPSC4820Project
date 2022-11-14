extends Node2D

const CLICK_TO_ROLL := 9

const DICE := [14, 17, 16, 13, 12, 15]

var SWORD_BUTTONS := [$SwordButton1, $SwordButton2, $SwordButton3]
var BOW_BUTTONS := [$BowButton1, $BowButton2, $BowButton3]
var RESOURCE_BUTTONS := [$UpgradeSword, $UpgradeBow, $EatFood, $UpgradeMovement]
var STEEL_LOCS := [Vector2(1,3), Vector2(3,5)]
var WOOD_LOCS := [Vector2(29,9), Vector2(30,10)]
var FOOD_LOCS := [Vector2(3,27), Vector2(4,28)]
var KNOWLEDGE_LOCS := [Vector2(24,26), Vector2(25,27)]

var rng = RandomNumberGenerator.new()

var DICE_CELL:Vector2

var moves = 0
var moves_for_sprite = 0
var players = []

export (int) var curr_player = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SWORD_BUTTONS = [$SwordButton1, $SwordButton2, $SwordButton3]
	BOW_BUTTONS = [$BowButton1, $BowButton2, $BowButton3]
	RESOURCE_BUTTONS = [$UpgradeSword, $UpgradeBow, $EatFood, $UpgradeMovement]
	rng.randomize()
	call_deferred("setup_game")
	players = [
		Player.new("Japan",$Player1Health, $Player1Hunger,$EgyptPlayer,Vector2(15,15)),
		Player.new("Viking",$Player2Health, $Player2Hunger,$KinematicBody2D,Vector2(16,15)),
		Player.new("Egypt",$Player3Health, $Player3Hunger,$KinematicBody2D,Vector2(15,16)),
		Player.new("Greece",$Player4Health, $Player4Hunger,$KinematicBody2D,Vector2(16,16))
		]
	players[0].updateHealth(-10)
	players[1].updateHealth(0)
	players[2].updateHealth(-30)
	players[3].updateHealth(-85)
	players[0].updateHunger(-90)
	players[1].updateHunger(-60)
	players[2].updateHunger(-50)
	players[3].updateHunger(-5)

func setup_game():
	$gamebackgroundsound.play();
	curr_labels()
	var cells = $TileMap1.get_used_cells()
	for cell in cells:
		var index = $TileMap1.get_cell(cell.x, cell.y)
		match index:
			CLICK_TO_ROLL:
				#roll_dice(cell, self)
				DICE_CELL = cell


func roll_dice(coord:Vector2):
	$diceroll.play();
	dice_animation(coord)
	var dice = rng.randi_range(0,5)
	moves = dice+1+players[curr_player].movement
	$TileMap1.set_cell(coord.x, coord.y, DICE[dice])
	$EndButton.disabled = false;
	$SwordButton1.disabled = true;
	$SwordButton2.disabled = true;
	$SwordButton3.disabled = true;
	for i in range (0,4):
		if i!=curr_player:
			if(abs(players[i].location.x-players[curr_player].location.x)<=1 and abs(players[i].location.y-players[curr_player].location.y)<=1):
				if i<curr_player:
					SWORD_BUTTONS[i].disabled = false;
					SWORD_BUTTONS[i].text = players[i].player_name;
				else:
					SWORD_BUTTONS[i-1].disabled = false;
					SWORD_BUTTONS[i-1].text = players[i].player_name;
	$BowButton1.disabled = true;
	$BowButton2.disabled = true;
	$BowButton3.disabled = true;
	for i in range (0,4):
		if i!=curr_player:
			if(abs(players[i].location.x-players[curr_player].location.x)<=4 and abs(players[i].location.y-players[curr_player].location.y)<=4):
				if i<curr_player:
					BOW_BUTTONS[i].disabled = false;
					BOW_BUTTONS[i].text = players[i].player_name;
				else:
					BOW_BUTTONS[i-1].disabled = false;
					BOW_BUTTONS[i-1].text = players[i].player_name;
	$UpgradeSword.disabled = true
	for x in range(STEEL_LOCS[0][0], STEEL_LOCS[1][0]+1):
		for y in range(STEEL_LOCS[0][1], STEEL_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$UpgradeSword.disabled = false
	$UpgradeBow.disabled = true
	for x in range(WOOD_LOCS[0][0], WOOD_LOCS[1][0]+1):
		for y in range(WOOD_LOCS[0][1], WOOD_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$UpgradeBow.disabled = false
	$EatFood.disabled = true
	for x in range(FOOD_LOCS[0][0], FOOD_LOCS[1][0]+1):
		for y in range(FOOD_LOCS[0][1], FOOD_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$EatFood.disabled = false
	$UpgradeMovement.disabled = true
	for x in range(KNOWLEDGE_LOCS[0][0], KNOWLEDGE_LOCS[1][0]+1):
		for y in range(KNOWLEDGE_LOCS[0][1], KNOWLEDGE_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$UpgradeMovement.disabled = false
	if players[curr_player].hunger>0:
		players[curr_player].updateHunger(-10)
		$PlayerHunger.value = players[curr_player].hunger;
		if players[curr_player].hunger <= 20:
			var styleBox = $PlayerHunger.get("custom_styles/fg")
			styleBox.bg_color = Color(255, 0, 0)
		else:
			var styleBox = $PlayerHunger.get("custom_styles/fg")
			styleBox.bg_color = Color(0, 255, 0)
	if players[curr_player].hunger <= 0:
		players[curr_player].updateHealth(-10)
		$PlayerHealth.value = players[curr_player].hitpoints;
		if players[curr_player].hitpoints <= 20:
			var styleBox = $PlayerHealth.get("custom_styles/fg")
			styleBox.bg_color = Color(255, 0, 0)
		else:
			var styleBox = $PlayerHealth.get("custom_styles/fg")
			styleBox.bg_color = Color(0, 255, 0)

func dice_animation(coord:Vector2):	
	for i in range(0,20):
		var dice = rng.randi_range(0,5)
		moves = dice+1+players[curr_player].movement
		$TileMap1.set_cell(coord.x, coord.y, DICE[dice])
		yield(get_tree().create_timer(0.05), "timeout")

func next_turn(coord:Vector2):
	if curr_player<3:
		curr_player += 1
	else:
		curr_player=0
	$TileMap1.set_cell(coord.x, coord.y, CLICK_TO_ROLL)
	curr_labels()
	
func curr_labels():
	$Label.set_text(players[curr_player].player_name);
	$Movement.set_text("Movement Bonus: "+str(players[curr_player].movement))
	$Sword.set_text("Sword Multiplier: "+str(players[curr_player].sword))
	$Bow.set_text("Bow Multiplier: "+str(players[curr_player].bow))
	$PlayerHealth.value = players[curr_player].hitpoints;
	$PlayerHunger.value = players[curr_player].hunger;
	$SwordButton1.disabled = true;
	$SwordButton2.disabled = true;
	$SwordButton3.disabled = true;
	$BowButton1.disabled = true;
	$BowButton2.disabled = true;
	$BowButton3.disabled = true;
	$EndButton.disabled = true;
	$UpgradeSword.disabled = true
	$UpgradeBow.disabled = true
	$EatFood.disabled = true
	$UpgradeMovement.disabled = true

	if players[curr_player].hitpoints <= 20:
		var styleBox = $PlayerHealth.get("custom_styles/fg")
		styleBox.bg_color = Color(255, 0, 0)
	else:
		var styleBox = $PlayerHealth.get("custom_styles/fg")
		styleBox.bg_color = Color(0, 255, 0)
	if players[curr_player].hunger <= 20:
		var styleBox = $PlayerHunger.get("custom_styles/fg")
		styleBox.bg_color = Color(255, 0, 0)
	else:
		var styleBox = $PlayerHunger.get("custom_styles/fg")
		styleBox.bg_color = Color(0, 255, 0)
	
func updateLocation(player:int, diff:Vector2):
	players[player].updateLocation(diff)
	$SwordButton1.disabled = true;
	$SwordButton2.disabled = true;
	$SwordButton3.disabled = true;
	for i in range (0,4):
		if i!=player:
			if(abs(players[i].location.x-players[player].location.x)<=1 and abs(players[i].location.y-players[player].location.y)<=1):
				if i<curr_player:
					SWORD_BUTTONS[i].disabled = false;
					SWORD_BUTTONS[i].text = players[i].player_name;
				else:
					SWORD_BUTTONS[i-1].disabled = false;
					SWORD_BUTTONS[i-1].text = players[i].player_name;
	$BowButton1.disabled = true;
	$BowButton2.disabled = true;
	$BowButton3.disabled = true;
	for i in range (0,4):
		if i!=player:
			if(abs(players[i].location.x-players[player].location.x)<=4 and abs(players[i].location.y-players[player].location.y)<=4):
				if i<curr_player:
					BOW_BUTTONS[i].disabled = false;
					BOW_BUTTONS[i].text = players[i].player_name;
				else:
					BOW_BUTTONS[i-1].disabled = false;
					BOW_BUTTONS[i-1].text = players[i].player_name;
	$UpgradeSword.disabled = true
	for x in range(STEEL_LOCS[0][0], STEEL_LOCS[1][0]+1):
		for y in range(STEEL_LOCS[0][1], STEEL_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$UpgradeSword.disabled = false
	$UpgradeBow.disabled = true
	for x in range(WOOD_LOCS[0][0], WOOD_LOCS[1][0]+1):
		for y in range(WOOD_LOCS[0][1], WOOD_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$UpgradeBow.disabled = false
	$EatFood.disabled = true
	for x in range(FOOD_LOCS[0][0], FOOD_LOCS[1][0]+1):
		for y in range(FOOD_LOCS[0][1], FOOD_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$EatFood.disabled = false
	$UpgradeMovement.disabled = true
	for x in range(KNOWLEDGE_LOCS[0][0], KNOWLEDGE_LOCS[1][0]+1):
		for y in range(KNOWLEDGE_LOCS[0][1], KNOWLEDGE_LOCS[1][1]+1):
			if players[curr_player].location == Vector2(x,y):
				$UpgradeMovement.disabled = false
	moves -= 1
	#if moves==0:
	#	next_turn(DICE_CELL)
	
func game_over(player:int):
	var winner = players[player].player_name
	global.winner = winner;
	get_tree().change_scene("res://EndScreen.tscn")

func _input(event):
	if event is InputEventMouseButton:
		var click = $TileMap1.world_to_map($TileMap1.to_local(event.position)) 
		if 0<=click.x-DICE_CELL.x && click.x-DICE_CELL.x<=3 && 0<=click.y-DICE_CELL.y && click.y-DICE_CELL.y<=3&& $TileMap1.get_cell(DICE_CELL.x, DICE_CELL.y) == CLICK_TO_ROLL:
			roll_dice(DICE_CELL)
			
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.scancode == KEY_UP || event.scancode ==  KEY_DOWN || event.scancode ==  KEY_LEFT || event.scancode ==  KEY_RIGHT:
			if curr_player == 0:
				$JapanPlayer.set_moves(moves)
			elif curr_player == 1:
				$VikingPlayer.set_moves(moves)
			elif curr_player == 2:
				$EgyptPlayer.set_moves(moves)
			elif curr_player == 3:
				$GreecePlayer.set_moves(moves)

func endTurn():
	moves = 0
	if curr_player == 0:
		$JapanPlayer.set_moves(moves)
	elif curr_player == 1:
		$VikingPlayer.set_moves(moves)
	elif curr_player == 2:
		$EgyptPlayer.set_moves(moves)
	elif curr_player == 3:
		$GreecePlayer.set_moves(moves)
	next_turn(DICE_CELL)

func _on_SwordButton1_pressed():
	print("Player " + players[curr_player].player_name + " attacks " + $SwordButton1.text)
	endTurn()


func _on_SwordButton2_pressed():
	print("Player " + players[curr_player].player_name + " attacks " + $SwordButton2.text)
	endTurn()


func _on_SwordButton3_pressed():
	print("Player " + players[curr_player].player_name + " attacks " + $SwordButton3.text)
	endTurn()


func _on_BowButton1_pressed():
	print("Player " + players[curr_player].player_name + " attacks " + $BowButton1.text)
	endTurn()


func _on_BowButton2_pressed():
	print("Player " + players[curr_player].player_name + " attacks " + $BowButton2.text)
	endTurn()


func _on_BowButton3_pressed():
	print("Player " + players[curr_player].player_name + " attacks " + $BowButton3.text)
	endTurn()


func _on_EndButton_pressed():
	endTurn()

func _on_UpgradeSword_pressed():
	players[curr_player].sword += 0.1
	$Sword.set_text("Sword Multiplier: "+str(players[curr_player].sword))
	endTurn()

func _on_UpgradeBow_pressed():
	players[curr_player].bow += 0.1
	$Bow.set_text("Bow Multiplier: "+str(players[curr_player].bow))
	endTurn()

func _on_EatFood_pressed():
	players[curr_player].updateHunger(10)
	$PlayerHunger.value = players[curr_player].hunger;
	if players[curr_player].hunger <= 20:
		var styleBox = $PlayerHunger.get("custom_styles/fg")
		styleBox.bg_color = Color(255, 0, 0)
	else:
		var styleBox = $PlayerHunger.get("custom_styles/fg")
		styleBox.bg_color = Color(0, 255, 0)
	endTurn()

func _on_UpgradeMovement_pressed():
	players[curr_player].movement += 1
	$Movement.set_text("Movement Bonus: "+str(players[curr_player].movement))
	endTurn()
