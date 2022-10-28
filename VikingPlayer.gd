extends KinematicBody2D



# Called when the node enters the scene tree for the first time.
var speed = 3

var attack = false

var velocity = Vector2()

var moves = 0

onready var _animated_sprite = $AnimatedSprite

func set_moves(moves_input):
	self.moves = moves_input
	
func get_input():

	if (((get_parent().curr_player) == 1) or ((get_parent().curr_player) == 2)):
		# maybe add another check for how many moves left
		if (self.moves > 0):
		#_animated_sprite.animation = "run"
			velocity = Vector2.ZERO
			if Input.is_action_just_released('right'):
				#velocity.x +=1000
				move_and_collide(Vector2(32,0))
				get_parent().updateLocation(1, Vector2(1,0));
				self.moves -=1
				attack = false

			elif Input.is_action_just_released('left'):
				#velocity.x -= 1000
				move_and_collide(Vector2(-32,0))
				get_parent().updateLocation(1, Vector2(-1,0));
				self.moves -=1
				attack = false

			elif Input.is_action_just_released('down'):
				#velocity.y += 1000
				move_and_collide(Vector2(0,32))
				get_parent().updateLocation(1, Vector2(0,1));
				self.moves -=1
				attack = false

			elif Input.is_action_just_released('up'):
				#velocity.y -= 1000
				move_and_collide(Vector2(0,-32))
				get_parent().updateLocation(1, Vector2(0,-1));
				self.moves -=1
				attack = false
			
			elif Input.is_action_just_released('attack'):
				attack = true
				
		
			velocity = velocity * speed
		else:
			velocity.x = 0
			velocity.y = 0


		

func _physics_process(delta):

	get_input()
	
	if attack:
		_animated_sprite.animation = "attack"
		
	elif(velocity.x != 0 or velocity.y != 0):
		_animated_sprite.animation = "run"
	else:
		_animated_sprite.animation = "idle"

	velocity = move_and_slide(velocity)
