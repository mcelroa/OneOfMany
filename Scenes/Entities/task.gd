class_name Task
extends Node2D

@export var task_def: TaskDefinition

@onready var sprite: Sprite2D = $Sprite2D

var task_manager: TaskManager


func _ready() -> void:
	task_manager = get_tree().get_first_node_in_group("task_manager")
	
	task_manager.task_assigned.connect(on_task_assigned)
	task_manager.task_completed.connect(on_task_completed)


func set_active(active: bool) -> void:
	sprite.modulate = Color.GREEN if active else Color.WHITE


func on_area_entered(body: Player) -> void:	
	body.nearby_task = task_def
	body.is_near_task = true


func on_area_exited(body: Player) -> void:	
	body.nearby_task = null
	body.is_near_task = false


func on_task_assigned(task: TaskDefinition) -> void:
	if task_def.id == task.id:
		set_active(true)


func on_task_completed(_total: int) -> void:
	set_active(false)
