extends Control


@onready var scene_tree: SceneTree = get_tree()
@onready var proposal_label: Label = $ProposalLabel
@onready var yes_button: Button = $YesButton
@onready var no_button: Button = $NoButton


func _ready():
	proposal_label.visible_ratio = 0.0
	yes_button.modulate.a = 0.0
	no_button.modulate.a = 0.0
	yes_button.scale = Vector2.ZERO
	no_button.scale = Vector2.ZERO
	no_button.is_moving = true
	
	await scene_tree.create_timer(0.2).timeout
	
	var tween: Tween = create_tween()
	tween.tween_property(proposal_label, "visible_ratio", 1.0, 1.0)
	
	await tween.finished
	await scene_tree.create_timer(0.5).timeout
	 
	tween = create_tween().set_parallel(true) \
	.set_trans(Tween.TRANS_ELASTIC) \
	.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(yes_button, "modulate:a", 1.0, 0.5)
	tween.tween_property(no_button, "modulate:a", 1.0, 0.5)
	tween.tween_property(yes_button, "scale", Vector2.ONE, 0.5)
	tween.tween_property(no_button, "scale", Vector2.ONE, 0.5)
	
	await tween.finished
	
	no_button.is_moving = false
	yes_button.start_breathing()
