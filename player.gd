extends KinematicBody2D

const GRAVITY = 40
const FRICTION = 0.3
const MOVE_SPEED = 600
const JUMP_SPEED = 700
const ACCELERATION = 25
const SLIDE_SPEED = GRAVITY / 4.0
const MAX_SLIDE_SPEED = JUMP_SPEED / 4
const MAX_FALL_SPEED = JUMP_SPEED * 2

var jumping = false
var move_left = false
var move_right = false
var touching_wall = false
var velocity = Vector2()

func _physics_process(_delta):
	get_user_actions()
	handle_air_actions()
	handle_move_actions()
	handle_jump_actions()
	handle_physics()

func body_exited(_body): touching_wall = false
func body_entered(_body): touching_wall = true

func get_user_actions():
	jumping = Input.is_action_just_pressed("jump")
	move_left = Input.is_action_pressed("move_left")
	move_right = Input.is_action_pressed("move_right")

func handle_physics():
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _ready():
	var _exit = $Area2D.connect("body_exited", self, "body_exited")
	var _enter = $Area2D.connect("body_entered", self, "body_entered")

func handle_move_actions():
	if move_left: velocity.x = max(velocity.x - ACCELERATION, -MOVE_SPEED)
	elif move_right: velocity.x = min(velocity.x + ACCELERATION, MOVE_SPEED)
	elif is_on_floor(): velocity.x = lerp(velocity.x, 0, FRICTION)

func handle_air_actions():
	if not is_on_floor() and touching_wall and velocity.y > 0:
		velocity.y = min(velocity.y + SLIDE_SPEED, MAX_SLIDE_SPEED)
	else: velocity.y = min(velocity.y + GRAVITY, MAX_FALL_SPEED)

func handle_jump_actions():
	if jumping and is_on_floor(): velocity.y = -JUMP_SPEED
	if jumping and touching_wall: velocity.y = -JUMP_SPEED
