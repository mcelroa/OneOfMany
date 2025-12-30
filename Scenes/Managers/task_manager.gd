class_name TaskManager
extends Node

signal task_assigned(task: TaskDefinition)
signal task_completed(total: int)
signal timer_started(seconds: float)

@export var all_tasks: Array[TaskDefinition]

@onready var pick_task_timer: Timer = $PickTaskTimer

var current_task: TaskDefinition
var completed_tasks: int = 0
var enabled: bool = false


func begin() -> void:
	enabled = true
	completed_tasks = 0
	current_task = null

	start_timer()


func stop() -> void:
	enabled = false
	pick_task_timer.stop()
	current_task = null


func assign_task(task: TaskDefinition) -> void:
	if not enabled:
		return
		
	current_task = task
	
	task_assigned.emit(task)


func complete_task(task: TaskDefinition) -> void:
	if not enabled:
		return
		
	if current_task == null:
		return
		
	if current_task.id != task.id:
		return
	
	completed_tasks += 1
	current_task = null
	
	task_completed.emit(completed_tasks)
		
	start_timer()


func pick_random_task() -> TaskDefinition:
	return all_tasks.pick_random()


func start_timer() -> void:
	if not enabled:
		return
		
	pick_task_timer.start()
	
	timer_started.emit(5)


func on_pick_task_timer_timeout() -> void:
	var task: TaskDefinition = pick_random_task()
	assign_task(task)
