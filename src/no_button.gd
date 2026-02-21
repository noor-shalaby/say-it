extends Button


@onready var viewport: Viewport = get_viewport()


func get_random_point_in_viewport() -> Vector2:
	var rect: Rect2 = viewport.get_visible_rect()
	
	var x: float = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var y: float = randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	return Vector2(x, y) if global_position.distance_to(Vector2(x, y)) > 128 else get_random_point_in_viewport()


func _on_mouse_entered() -> void:
	var target_pos: Vector2 = get_random_point_in_viewport()
	
	var tween: Tween = create_tween() \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "global_position", target_pos, global_position.distance_to(target_pos) * 0.0005)
