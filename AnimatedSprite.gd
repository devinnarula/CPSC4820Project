extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func animates_player(direction: Vector2):
	if direction != Vector2.ZERO:
		# Play walk animation
		$AnimatedSprite.play("run")
	else:
		# Play idle animation
		$AnimatedSprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
