extends Node2D

const CLICK_TO_ROLL := 9

const DICE := [14, 17, 16, 13, 12, 15]

var rng = RandomNumberGenerator.new()

var DICE_CELL:Vector2

var moves = 0

var players = [Player.new("Player 1"),Player.new("Player 2"),Player.new("Player 3"),Player.new("Player 4")]

var curr_player = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	call_deferred("setup_game")

func setup_game():
	$Label.set_text(players[curr_player].player_name);
	var cells = $TileMap.get_used_cells()
	for cell in cells:
		var index = $TileMap.get_cell(cell.x, cell.y)
		match index:
			CLICK_TO_ROLL:
				#roll_dice(cell, self)
				DICE_CELL = cell

func roll_dice(coord:Vector2):	
	dice_animation(coord)
	var dice = rng.randi_range(0,5)
	moves = dice+1
	$TileMap.set_cell(coord.x, coord.y, DICE[dice])
	
func dice_animation(coord:Vector2):	
	for i in range(0,20):
		var dice = rng.randi_range(0,5)
		moves = dice+1
		$TileMap.set_cell(coord.x, coord.y, DICE[dice])
		yield(get_tree().create_timer(0.05), "timeout")

func next_turn(coord:Vector2):
	if curr_player<3:
		curr_player += 1
	else:
		curr_player=0
	$Label.set_text(players[curr_player].player_name);
	$TileMap.set_cell(coord.x, coord.y, CLICK_TO_ROLL)
	
func _input(event):
	if event is InputEventMouseButton:
		var click = $TileMap.world_to_map($TileMap.to_local(event.position)) 
		if 0<=click.x-DICE_CELL.x && click.x-DICE_CELL.x<=3 && 0<=click.y-DICE_CELL.y && click.y-DICE_CELL.y<=3&& $TileMap.get_cell(DICE_CELL.x, DICE_CELL.y) == CLICK_TO_ROLL:
			roll_dice(DICE_CELL)
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.scancode == KEY_UP || event.scancode ==  KEY_DOWN || event.scancode ==  KEY_LEFT || event.scancode ==  KEY_RIGHT:
			moves -= 1
			if moves==0:
				next_turn(DICE_CELL)
