extends RigidBody3D

const HT = preload("res://assets/sounds/vending_machine/ht.mp3")
const ILFTSYA = preload("res://assets/sounds/vending_machine/ilftsya.mp3")
const PIC = preload("res://assets/sounds/vending_machine/pic.mp3")
const TB = preload("res://assets/sounds/vending_machine/tb.mp3")
const TYVM = preload("res://assets/sounds/vending_machine/tyvm.mp3")
const YCEWAR = preload("res://assets/sounds/vending_machine/ycewar.mp3")
const YW = preload("res://assets/sounds/vending_machine/yw.mp3")

var scene_start_time: float = 0.0

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var timer: Timer = $Timer


func _ready() -> void:
	scene_start_time = Time.get_ticks_msec() / 1000.0


## Called when the collision shape in front of vending machine is entered.
func _on_area_3d_body_entered(body: Node3D) -> void:
	# Don't play sound in the first few seconds after scene loading
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - scene_start_time < 2.0:
		return
	else:
		if !audio_stream_player_3d.playing:
			if body is CharacterBody3D and body.is_in_group("Player"):
				audio_stream_player_3d.stream = HT
				audio_stream_player_3d.play()
		timer.start()


## Called when the collision shape in front of vending machine is exited.
func _on_area_3d_body_exited(body: Node3D) -> void:
	if !audio_stream_player_3d.playing:
		if body is CharacterBody3D and body.is_in_group("Player"):
			audio_stream_player_3d.stream = ILFTSYA
			audio_stream_player_3d.play()
	timer.stop()


## Called when the collision shape that matches the vending machine is entered.
func _on_area_3d_2_body_entered(body: Node3D) -> void:
	# Don't play sound in the first few seconds after scene loading
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - scene_start_time < 2.0:
		return
	else:
		if !audio_stream_player_3d.playing:
			if body is CharacterBody3D or RigidBody3D:
				audio_stream_player_3d.stream = TB
				audio_stream_player_3d.play()


func _on_timer_timeout() -> void:
	if !audio_stream_player_3d.playing:
		audio_stream_player_3d.stream = PIC
		audio_stream_player_3d.play()
	timer.stop()
