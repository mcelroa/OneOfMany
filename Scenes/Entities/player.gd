class_name Player
extends CharacterBody2D

signal task_available(available: bool)

@export var speed = 400
@export var task_manager: TaskManager

var nearby_task: Task
var is_holding_task: bool = false;


func _ready() -> void:
	task_manager.task_assigned.connect(on_task_assigned)
	task_manager.task_completed.connect(on_task_completed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if nearby_task and task_manager.current_task:
			if nearby_task.task_def.id == task_manager.current_task.id:
				is_holding_task = true
				nearby_task.start_hold()
	
	if event.is_action_released("interact"):
		cancel_task_hold()


func _process(delta: float) -> void:
	if not is_holding_task:
		return
	
	if nearby_task == null:
		is_holding_task = false
		return
	
	if nearby_task.tick_hold(delta):
		is_holding_task = false
		task_manager.complete_task(nearby_task.task_def)


func _physics_process(_delta):
	get_input()
	move_and_slide()


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func cancel_task_hold() -> void:
	if is_holding_task and nearby_task:
		nearby_task.cancel_hold()
	is_holding_task = false


func can_interact() -> bool:
	return nearby_task != null \
		and task_manager.current_task != null \
		and nearby_task.task_def.id == task_manager.current_task.id


func update_task_available() -> void:
	task_available.emit(can_interact())


func on_task_assigned(_task: TaskDefinition) -> void:
	update_task_available()


func on_task_completed(_total: int) -> void:
	cancel_task_hold()
	update_task_available()
