extends CharacterBody2D

@export var speed = 50
@export var patrol_distance = 200

var direction = 1
var start_position = Vector2.ZERO

func _ready():
	start_position = global_position

func _physics_process(delta):
	# Movement
	velocity.x = speed * direction
	velocity.y += 200 * delta  # Gravity
	
	move_and_slide()
	
	# If hit wall, turn around
	if is_on_wall():
		direction *= -1
	
	# Turn around at patrol distance
	if abs(global_position.x - start_position.x) > patrol_distance:
		direction *= -1
	
	# Play walk animation
	if has_node("Sprite2D"):
		$AnimationPlayer.play("move")
	
	# Face direction
	if has_node("Sprite2D"):
		$Sprite2D.flip_h = (direction < 0)
