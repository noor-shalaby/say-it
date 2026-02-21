extends Button


const SCREEN_MARGIN: float = 32.0

@onready var viewport: Viewport = get_viewport()

var is_moving: bool = false


func get_random_point_in_viewport() -> Vector2:
	var rect: Rect2 = viewport.get_visible_rect()
	
	var new_pos: Vector2
	new_pos.x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	new_pos.y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	var screen_size = get_viewport_rect().size
	new_pos.x = clamp(new_pos.x, SCREEN_MARGIN, screen_size.x - size.x - SCREEN_MARGIN)
	new_pos.y = clamp(new_pos.y, SCREEN_MARGIN, screen_size.y - size.y - SCREEN_MARGIN)
	
	return new_pos if global_position.distance_to(new_pos) > 128 else get_random_point_in_viewport()


func _on_mouse_entered() -> void:
	if is_moving:
		return
	is_moving = true
	
	var target_pos: Vector2 = get_random_point_in_viewport()
	
	var tween: Tween = create_tween() \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "global_position", target_pos, global_position.distance_to(target_pos) * 0.0005)
	await tween.finished
	is_moving = false
