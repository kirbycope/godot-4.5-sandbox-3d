extends BaseState

const ANIMATION_JUMPING := "Falling_Idle" + "/mixamo_com"
const ANIMATION_JUMPING_HOLDING_RIFLE := "Rifle_Falling_Idle" + "/mixamo_com"
const ANIMATION_JUMPING_HOLDING_TOOL := "Tool_Falling_Idle" + "/mixamo_com"
const NODE_NAME := "Falling"

var time_falling: float ## The time spent in the "falling" state.

## Called when there is an input event.
func _input(event: InputEvent) -> void:
	# Check if the game is not paused
	if !player.game_paused:
		# Ⓐ/[Space] _pressed_ and double jumping is enabled -> Start "double jumping"
		if event.is_action_pressed("button_0") and player.enable_double_jump and !player.is_double_jumping:
			# Check if the animation player is not locked
			if !player.is_animation_locked:
				# Set the player's vertical velocity
				player.velocity.y = player.jump_velocity
				# Set the "double jumping" flag
				player.is_double_jumping = true

		# Ⓐ/[Space] _pressed_ and flying is enabled --> Start "flying"
		if event.is_action_pressed("button_0") and player.enable_flying:
			# Check if the animation player is not locked
			if !player.is_animation_locked:
				# Start "flying"
				transition(NODE_NAME, "Flying")


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Uncomment the next line if using GodotSteam
	#if !is_multiplayer_authority(): return
	# Check if the game is not paused
	if !player.game_paused:
		# Check if the player is not canceling a climb or hang
		if !Input.is_action_pressed("button_3"):
			# Check the eyeline for a ledge to grab.
			if !player.raycast_top.is_colliding() and player.raycast_high.is_colliding():
				# Get the collision object
				var collision_object = player.raycast_high.get_collider()

				# Only proceed if the collision object is not in the "held" group and not a player
				if !collision_object.is_in_group("held") and !collision_object is CharacterBody3D:
					# Start "hanging"
					transition(NODE_NAME, "Hanging")

	# Check if the player is on the ground (and has no vertical velocity)
	if player.is_on_floor() and player.velocity.y == 0.0:
		# It would take approximately 1.43 seconds to fall 10 meters under gravity = -9.8 m/s² (ignoring air resistance and assuming initial downward velocity is zero).
		if time_falling > 1.43:
			# Transition to ragdoll state for hard impacts
			transition(NODE_NAME, "Ragdoll")
		else:
			# Start "standing"
			transition(NODE_NAME, "Standing")


	# Check if the player is "falling"
	if player.is_falling:
		# Increment the time spent in the "falling" state
		time_falling += delta
		# Play the animation
		play_animation()


## Plays the appropriate animation based on player state.
func play_animation() -> void:
	# Check if the animation player is not locked
	if !player.is_animation_locked:
		# Check if the player is "holding a rifle"
		if player.is_holding_rifle:
			# Check if the animation player is not already playing the appropriate animation
			if player.animation_player.current_animation != ANIMATION_JUMPING_HOLDING_RIFLE:
				# Play the "jumping, holding a rifle" animation
				player.animation_player.play(ANIMATION_JUMPING_HOLDING_RIFLE)

		# Check if the player is "holding a tool"
		elif player.is_holding_tool:
			# Check if the animation player is not already playing the appropriate animation
			if player.animation_player.current_animation != ANIMATION_JUMPING_HOLDING_TOOL:
				# Play the "jumping, holding a tool" animation
				player.animation_player.play(ANIMATION_JUMPING_HOLDING_TOOL)

		# The player must be unarmed
		else:
			# Check if the animation player is not already playing the appropriate animation
			if player.animation_player.current_animation != ANIMATION_JUMPING:
				# Play the "jumping" animation
				player.animation_player.play(ANIMATION_JUMPING)


## Start "falling".
func start() -> void:
	# Enable _this_ state node
	process_mode = PROCESS_MODE_INHERIT

	# Set the player's new state
	player.current_state = STATES.State.FALLING

	# Flag the player as "falling"
	player.is_falling = true


## Stop "falling".
func stop() -> void:
	# Disable _this_ state node
	process_mode = PROCESS_MODE_DISABLED

	# Flag the player as not "falling"
	player.is_falling = false

	# Flag the player as not "double jumping"
	player.is_double_jumping = false

	# Reset the time spent falling
	time_falling = 0.0
