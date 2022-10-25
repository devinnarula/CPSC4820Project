extends Node2D

const CLICK_TO_ROLL := 9

const DICE := [14, 17, 16, 13, 12, 15]

var rng = RandomNumberGenerator.new()

var DICE_CELL:Vector2

var moves = 0
var moves_for_sprite = 0
var players = []

export (int) var curr_player = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	call_deferred("setup_game")
	players = [Player.new("Player 1",$Player1Health, $Player1Hunger,$EgyptPlayer),Player.new("Player 2",$Player2Health, $Player2Hunger,$KinematicBody2D),Player.new("Player 3",$Player3Health, $Player3Hunger,$KinematicBody2D),Player.new("Player 4",$Player4Health, $Player4Hunger,$KinematicBody2D)]
	players[0].updateHealth(-10)
	players[1].updateHealth(0)
	players[2].updateHealth(-30)
	players[3].updateHealth(-85)
	players[0].updateHunger(-90)
	players[1].updateHunger(-60)
	players[2].updateHunger(-50)
	players[3].updateHunger(-5)

func setup_game():
	curr_labels()
	var cells = $TileMap1.get_used_cells()
	for cell in cells:
		var index = $TileMap1.get_cell(cell.x, cell.y)
		match index:
			CLICK_TO_ROLL:
				#roll_dice(cell, self)
				DICE_CELL = cell

func roll_dice(coord:Vector2):	
	dice_animation(coord)
	var dice = rng.randi_range(0,5)
	moves = dice+1
	$TileMap1.set_cell(coord.x, coord.y, DICE[dice])
	
func dice_animation(coord:Vector2):	
	for i in range(0,20):
		var dice = rng.randi_range(0,5)
		moves = dice+1
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
			moves -= 1
			if moves==0:
				next_turn(DICE_CELL)
