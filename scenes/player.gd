extends CharacterBody3D


const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5
var mouse_captured : bool = false
var look_rotation : Vector2
var look_speed : float = 0.0005
var SENSITIVITY : float = 0.03
var crouch_height: float = 0.5
var stand_height: float = 2.0
var crouching: bool = false
var crouch_speed: float = 2.5

@onready var head: SpringArm3D = $Head

@onready var armsani: AnimationPlayer = $Head/Camera3D/PSX_First_Person_Arms/AnimationPlayer

func crouch():
	if Input.is_action_just_pressed("crouch"):
		crouching = !crouching
		if crouching:
			$CollisionShape3D.shape.height = crouch_height
		else:
			$CollisionShape3D.shape.height = stand_height

func _ready() -> void:
	armsani.play("Relax_hands_idle_start")
	mouse_captured = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not mouse_captured:
			capture_mouse()
		else:
			armsani.play("Magic_spell_attack")
			
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		release_mouse()

	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func rotate_look(rot_input: Vector2):
	look_rotation.x = clamp(
		look_rotation.x + rot_input.y * look_speed,
		deg_to_rad(-85),
		deg_to_rad(85)
	)
	look_rotation.y -= rot_input.x * look_speed 
	look_rotation.y = wrapf(look_rotation.y, 0, TAU)

	rotation.y = look_rotation.y 	 
	head.rotation.x = look_rotation.x 	

func _physics_process(delta: float) -> void:
	
	crouch()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	armsani.play("Relax_hands_idle")
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !crouching:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = direction.x * crouch_speed
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
