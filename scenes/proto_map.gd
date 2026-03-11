extends Node3D
@onready var player: CharacterBody3D = $Player
@onready var animation_player: AnimationPlayer = $"whatever/2/House_Demo_039/AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/proto_map.tscn")


func _on_house_demo_039_body_entered(body: Node3D) -> void:
	print("body detected 1")
	if body.name == "Player":
		animation_player.play("door_open")
	


func _on_house_demo_039_body_exited(body: Node3D) -> void:
	print("body detected 2")
	if body.name == "Player":
		animation_player.play("RESET")
