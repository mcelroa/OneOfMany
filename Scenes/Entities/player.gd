class_name Player
extends CharacterBody2D

@export var speed = 400


var nearby_task: TaskDefinition
var is_near_task: bool = false;

var task_manager: TaskManager


func _ready() -> void:
	task_manager = get_tree().get_first_node_in_group("task_manager")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && nearby_task:
		task_manager.complete_task(nearby_task)
			

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func _physics_process(_delta):
	get_input()
	move_and_slide()
