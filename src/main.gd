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
	
	await scene_tree.create_timer(0.2).timeout
	
	var tween: Tween = create_tween()
	tween.tween_property(proposal_label, "visible_ratio", 1.0, 0.6)
	
	await scene_tree.create_timer(1.0).timeout
	 
	tween = create_tween().set_parallel(true) \
	.set_trans(Tween.TRANS_ELASTIC) \
	.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(yes_button, "modulate:a", 1.0, 0.6)
	tween.tween_property(no_button, "modulate:a", 1.0, 0.6)
	tween.tween_property(yes_button, "scale", Vector2.ONE, 0.6)
	tween.tween_property(no_button, "scale", Vector2.ONE, 0.6)
	
	await tween.finished
	yes_button.start_breathing()
