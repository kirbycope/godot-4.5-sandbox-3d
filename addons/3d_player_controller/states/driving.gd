extends BaseState

const ANIMATION_DRIVING := "Driving" + "/mixamo_com"
const ANIMATION_ENTERING_CAR := "Entering_Car" + "/mixamo_com"
const ANIMATION_EXITING_CAR := "Exiting_Car" + "/mixamo_com"
const NODE_NAME := "Driving"

var time_driving: float = 0.0 ## The time spent driving the vehicle.


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Uncomment the next line if using GodotSteam
	#if !is_multiplayer_authority(): return
	# Check if the player is "driving"
	if player.is_driving:
		# Play the animation
		play_animation()


## Plays the appropriate animation based on player state.
func play_animation() -> void:
	# Check if the animation player is not locked
	if !player.is_animation_locked:
		# Check if the animation player is not already playing the appropriate animation
		if player.animation_player.current_animation != ANIMATION_DRIVING:
			# Play the "driving" animation
			player.animation_player.play(ANIMATION_DRIVING)


## Start "driving".
func start() -> void:
	# Enable _this_ state node
	process_mode = PROCESS_MODE_INHERIT

	# Set the player's new state
	player.current_state = STATES.State.DRIVING

	# Flag the player as "driving"
	player.is_driving = true

	# Set the player's movement speed
	player.speed_current = 10.0

	# Disable CollisionShape3D
	player.collision_shape.disabled = true

	# [Re]Set the driving time
	time_driving = 0.0


## Stop "driving".
func stop() -> void:
	# Disable _this_ state node
	process_mode = PROCESS_MODE_DISABLED

	# Flag player as not "driving"
	player.is_driving = false

	# Reset player velocity to prevent flying when exiting
	player.velocity = Vector3.ZERO

	# Remove the player from the vehicle
	player.is_driving_in.player = null

	# Remove the vehicle with the player
	player.is_driving_in = null

	# Wait 2 physics frames before re-enabling collision
	await get_tree().physics_frame
	await get_tree().physics_frame
	player.collision_shape.disabled = false

	# [Re]Set the driving time
	time_driving = 0.0
