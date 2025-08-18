extends Node3D

var exit_portal: Portal3D
var player: CharacterBody3D
var player_camera: Camera3D

@onready var portal_3d: Portal3D = $Portal3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Defer wiring until all siblings finish _ready to avoid Portal3D initializing too early
	await get_tree().process_frame

	# Get the "red" portal
	exit_portal = get_tree().current_scene.get_node_or_null("RedPortal/Portal3D")
	if exit_portal == null:
		push_error("BluePortal: RedPortal/Portal3D not found")
	else:
		portal_3d.exit_portal = exit_portal

	# Get the player
	player = get_tree().current_scene.get_node_or_null("Player")
	if player == null:
		push_error("BluePortal: Player not found")

	# Get the player camera
	player_camera = player.get_node_or_null("CameraMount/Camera3D")
	if player_camera == null:
		push_error("BluePortal: Player/CameraMount/Camera3D not found")
	else:
		portal_3d.player_camera = player_camera

	# Ensure cameras are set up after linking
	if portal_3d.exit_portal != null and portal_3d.player_camera != null:
		portal_3d.activate()
	else:
		push_error("BluePortal: BluePortal not activated.")

	# Ensure the player is on collision layer 16
	player.set_collision_layer_value(16, true)
