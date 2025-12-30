class_name HUD
extends CanvasLayer

@onready var interact_prompt: Control = $MarginContainer/InteractPrompt
@onready var current_task_label: Label = %CurrentTaskLabel
@onready var current_task: Control = $MarginContainer/CurrentTask
@onready var tasks_complete_label: Label = %TasksCompleteLabel
@onready var tasks_complete: Control = $MarginContainer/TasksComplete
@onready var next_countdown_label: Label = %NextCountdownLabel
@onready var next_task_countdown: Control = $MarginContainer/NextTaskCountdown
@onready var countdown_timer: Timer = $CountdownTimer

var remaining_seconds: int = 0

@export var task_manager: TaskManager
@export var round_manager: RoundManager
@export var player: Player


func _ready() -> void:
	task_manager.task_assigned.connect(on_task_assigned)
	task_manager.timer_started.connect(on_timer_started)
	task_manager.task_completed.connect(on_task_completed)
	
	round_manager.round_progress.connect(on_round_progress)
	
	player.task_available.connect(on_task_available)
	
	countdown_timer.timeout.connect(on_countdown_tick)


func on_task_assigned(task: TaskDefinition) -> void:
	current_task.visible = true
	next_task_countdown.visible = false
	
	current_task_label.text = "Current task: " + task.title


func on_timer_started(seconds: float) -> void:
	next_task_countdown.visible = true
	remaining_seconds = int(seconds)
	update_countdown_label()
	
	countdown_timer.start()


func on_countdown_tick() -> void:
	remaining_seconds -= 1
	update_countdown_label()
	
	if remaining_seconds <= 0:
		next_task_countdown.visible = false
		countdown_timer.stop()


func update_countdown_label() -> void:
	next_countdown_label.text = "Next task in " + str(remaining_seconds)


func on_round_progress(tasks_done: int, _target_tasks: int) -> void:
	tasks_complete_label.text = "Tasks done: " + str(tasks_done)
	

func on_task_completed(_total: int) -> void:
	current_task.visible = false
	tasks_complete.visible = true


func on_task_available(available: bool) -> void:
	interact_prompt.visible = available
