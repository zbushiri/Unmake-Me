extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
@onready var actionable_finder: Area2D = $aFinder
var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var Actionable = actionable_finder.get_overlapping_areas()
		if Actionable.size() > 0:
			Actionable[0].action()
			return
			
func _input(event):
	# Handle jump.
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_multiplier
	# Handle jump down
	if event.is_action_pressed("move_down") and is_on_floor():
		set_collision_mask_value(2, false)  # Disable Layer 2 collision
		await get_tree().create_timer(0.2).timeout
		set_collision_mask_value(2, true)   # Re-enable Layer 2 collision

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)

	move_and_slide()

	# Flip sprite based on direction
	if direction == 1:
		sprite.flip_h = false
	elif direction == -1:
		sprite.flip_h = true

	# Play animations based on movement
	if abs(velocity.x) > 0.0:
		animation_player.play("move")
	else:
		animation_player.play("idle")

	# Play jump animation
	if velocity.y < 0.0 or velocity.y > 0.0:
		animation_player.play("jump")
