extends CharacterBody2D

@export var move_speed: float = 200.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 1.0

var _move_direction: Vector2 = Vector2.ZERO
var _is_dashing: bool = false
var _can_dash: bool = true


func _physics_process(_delta: float) -> void:
	if _is_dashing:
		move_and_slide()
		return

	_move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = _move_direction * move_speed

	if Input.is_action_just_pressed("dash") and _can_dash:
		_start_dash()

	move_and_slide()


func _start_dash() -> void:
	var dir: Vector2 = _move_direction if _move_direction != Vector2.ZERO else Vector2.RIGHT
	_is_dashing = true
	_can_dash = false
	velocity = dir * dash_speed
	await get_tree().create_timer(dash_duration).timeout
	_is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	_can_dash = true
