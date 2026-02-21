extends Control


const END_TRACK: AudioStreamWAV = preload("uid://pynw0kyixauc")

@onready var scene_tree: SceneTree = get_tree()
@onready var bg_mat: Material = $Background.material
@onready var bg_particles: CPUParticles2D = $BackgroundParticlesEmitter/CPUParticles2D
@onready var bg_track: AudioStreamPlayer = $BackgroundTrack
@onready var headline: Label = $Headline
@onready var yes_button: Button = $YesButton
@onready var no_button: Button = $NoButton
@onready var piano_a4: AudioStreamPlayer = $PianoA4


func _ready() -> void:
	headline.visible_ratio = 0.0
	yes_button.modulate.a = 0.0
	no_button.modulate.a = 0.0
	yes_button.scale = Vector2.ZERO
	no_button.scale = Vector2.ZERO
	no_button.is_moving = true
	
	await scene_tree.create_timer(0.5).timeout
	bg_track.play()
	
	var tween: Tween = create_tween()
	tween.tween_property(headline, "visible_ratio", 0.3, 0.4)
	tween.tween_interval(0.5)
	tween.tween_property(headline, "visible_ratio", 0.5, 0.4)
	tween.tween_interval(0.5)
	tween.tween_property(headline, "visible_ratio", 1.0, 0.8)
	tween.tween_interval(0.5)
	
	await tween.finished
	 
	tween = create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(yes_button, "modulate:a", 1.0, 2.0)
	tween.tween_property(no_button, "modulate:a", 1.0, 2.0)
	tween.tween_property(yes_button, "scale", Vector2.ONE, 2.0)
	tween.tween_property(no_button, "scale", Vector2.ONE, 2.0)
	
	await tween.finished
	
	no_button.is_moving = false
	yes_button.start_breathing()


func brighten_background() -> void:
	var current_color: Color = bg_mat.get_shader_parameter("center_color")
	var target_color: Color = current_color.lightened(0.08)
	
	var tween: Tween = create_tween()
	tween.tween_method(
		func(value: Color) -> void:
			bg_mat.set_shader_parameter("center_color", value),
		current_color,
		target_color,
		1.0
	).set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)


func transition_headline() -> void:
	var tween: Tween = create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
	# Fade out + slight upward drift
	tween.tween_property(headline, "modulate:a", 0.0, 1.0)
	tween.tween_property(headline, "position:y", headline.position.y - 10, 1.0)
	tween.tween_property(headline, "scale", Vector2.ONE * 0.98, 1.0)
	
	# Wait before bringing new text
	await tween.finished
	await scene_tree.create_timer(0.5).timeout
	
	tween = create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
	# Fade new text in
	brighten_background()
	headline.text = "I knew you would ;)"
	headline.modulate = headline.modulate.lightened(0.05)
	tween.tween_property(headline, "modulate:a", 1.0, 1.0)
	tween.tween_property(headline, "position:y", headline.position.y + 10, 1.0)
	tween.tween_property(headline, "scale", Vector2.ONE, 1.0)


func _on_yes_button_pressed() -> void:
	yes_button.disabled = true
	no_button.disabled = true
	
	piano_a4.play()
	bg_particles.emitting = false
	bg_track.stop()
	bg_track.stream = END_TRACK
	bg_track.play()
	
	var tween: Tween = create_tween() \
		.set_parallel(true)
	
	# Fade buttons
	tween.tween_property(no_button, "modulate:a", 0.0, 0.5)
	tween.tween_property(no_button, "scale", Vector2.ONE * 0.98, 0.5)
	tween.tween_interval(1.0)
	tween.tween_property(yes_button, "modulate:a", 0.0, 1.0)
	tween.tween_property(yes_button, "scale", Vector2.ONE * 1.02, 1.0)
	
	await tween.finished
	await scene_tree.create_timer(0.5).timeout
	transition_headline()
