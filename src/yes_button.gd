extends Button


const HOVER_ANIM_DUR: float = 0.1
const UNHOVER_ANIM_DUR: float = 0.2

@onready var stylebox: StyleBoxFlat = get_theme_stylebox("normal")

var breathing_tween: Tween


func _ready() -> void:
	disabled = true


func start_breathing() -> void:
	disabled = false
	
	breathing_tween = create_tween() \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_loops()
	
	breathing_tween.tween_property(self, "scale", Vector2.ONE * 1.1, 1.3)
	breathing_tween.tween_interval(0.2)
	breathing_tween.tween_property(self, "scale", Vector2.ONE, 1.3)

func stop_breathing() -> void:
	if breathing_tween:
		breathing_tween.kill()


func tween_border(width: float = 0.0, anim_dur: float = UNHOVER_ANIM_DUR) -> void:
	var tween: Tween = create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(stylebox, "border_width_left", width, anim_dur)
	tween.tween_property(stylebox, "border_width_top", width, anim_dur)
	tween.tween_property(stylebox, "border_width_right", width, anim_dur)
	tween.tween_property(stylebox, "border_width_bottom", width, anim_dur)


func _on_mouse_entered() -> void:
	tween_border(4.0, HOVER_ANIM_DUR)

func _on_mouse_exited() -> void:
	tween_border()


func _on_pressed() -> void:
	stop_breathing()
