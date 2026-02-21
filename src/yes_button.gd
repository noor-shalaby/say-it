extends Button


@export var hover_anim_dur: float = 0.1
@export var unhover_anim_dur: float = 0.2

var breathing_tween: Tween


func _ready() -> void:
	start_breathing()


func start_breathing():
	breathing_tween = create_tween() \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT) \
	.set_loops()
	
	breathing_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 1.3)
	breathing_tween.tween_interval(0.2)
	breathing_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1.3)

func stop_breathing() -> void:
	if breathing_tween:
		breathing_tween.kill()


func tween_border(width: float = 0.0, anim_dur: float = unhover_anim_dur) -> void:
	var tween: Tween = create_tween() \
	.set_parallel(true) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(get_theme_stylebox("normal"), "border_width_left", width, anim_dur)
	tween.tween_property(get_theme_stylebox("normal"), "border_width_top", width, anim_dur)
	tween.tween_property(get_theme_stylebox("normal"), "border_width_right", width, anim_dur)
	tween.tween_property(get_theme_stylebox("normal"), "border_width_bottom", width, anim_dur)


func _on_mouse_entered() -> void:
	tween_border(4.0, hover_anim_dur)

func _on_mouse_exited() -> void:
	tween_border()
