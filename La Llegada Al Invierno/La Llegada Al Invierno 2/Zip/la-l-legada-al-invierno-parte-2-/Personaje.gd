extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sens = 0.003

@onready var cam = $Camera3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):

	# gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# movimiento
	var input_dir = Input.get_vector("a", "d", "w", "s")

	var direction = (
		transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event):

	if event is InputEventMouseMotion:

		# girar personaje
		rotate_y(-event.relative.x * sens)

		# mover cámara arriba/abajo
		cam.rotation.x -= event.relative.y * sens

		# límite vertical
		cam.rotation.x = clamp(
			cam.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)
