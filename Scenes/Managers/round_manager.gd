class_name RoundManager
extends Node

signal round_started(target_tasks: int)
signal round_progress(tasks_done: int, target_tasks: int)
signal round_won

@export var target_tasks: int = 5
@export var task_manager: TaskManager

var tasks_done: int = 0
var is_running: bool = false

func _ready() -> void:
	start_round()
	
	task_manager.task_completed.connect(on_task_completed)


func start_round() -> void:
	tasks_done = 0
	is_running = true
	
	task_manager.begin()
	
	round_started.emit(target_tasks)
	round_progress.emit(tasks_done, target_tasks)


func win() -> void:
	print("WIN")
	is_running = false
	
	task_manager.stop()
	
	round_won.emit()
	

func on_task_completed(total: int) -> void:
	if !is_running:
		return
	
	tasks_done = total
	round_progress.emit(tasks_done, target_tasks)
		
	if tasks_done >= target_tasks:
		win()
