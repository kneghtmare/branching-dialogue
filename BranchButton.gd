extends Button

signal branch_pressed(index)

export var branchIndex: int = 0


func _ready() -> void:
	connect("button_up", self, "onButtonUp")


func onButtonUp() -> void:
	emit_signal("branch_pressed", branchIndex)
