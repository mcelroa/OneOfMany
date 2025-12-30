class_name Task
extends Node2D

@export var task_def: TaskDefinition
@export var hold_duration: float = 4.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var bar_root: Node2D = $ProgressBarRoot
@onready var bar_fill: Sprite2D = $ProgressBarRoot/BarFill

var task_manager: TaskManager

var holding: bool = false
var progress: float = 0.0


func _ready() -> void:
	task_manager = get_tree().get_first_node_in_group("task_manager")
	
	task_manager.task_assigned.connect(on_task_assigned)
	task_manager.task_completed.connect(on_task_completed)
	
	bar_root.visible = false
	set_fill(0.0)


func start_hold():
	holding = true
	progress = 0.0
	bar_root.visible = true
	set_fill(progress)


func cancel_hold() -> void:
	holding = false
	progress = 0.0
	bar_root.visible = false
	set_fill(0.0)


func tick_hold(delta: float) -> bool:
	if not holding:
		return false

	progress += delta / hold_duration
	progress = clamp(progress, 0.0, 1.0)
	set_fill(progress)

	if progress >= 1.0:
		holding = false
		bar_root.visible = false
		return true

	return false

func set_fill(amount: float) -> void:
	bar_fill.scale.x = amount


func set_active(active: bool) -> void:
	sprite.modulate = Color.GREEN if active else Color.WHITE
	if not active:
		cancel_hold()


func on_area_entered(body: Player) -> void:
	body.nearby_task = self
	body.update_task_available()

func on_area_exited(body: Player) -> void:
	if body.nearby_task == self:
		body.nearby_task = null
		body.cancel_task_hold()
		body.update_task_available()


func on_task_assigned(task: TaskDefinition) -> void:
	set_active(task_def.id == task.id)


func on_task_completed(_total: int) -> void:
	set_active(false)
