extends Control

export(NodePath) var np_neg_score_bar
export(NodePath) var np_pos_score_bar

onready var neg_score_bar = get_node(np_neg_score_bar) as ProgressBar
onready var pos_score_bar = get_node(np_pos_score_bar) as ProgressBar

func _ready():
	LevelUi.hide()
	var score = LevelUi.score
	pos_score_bar.value = max(score, 0)
	neg_score_bar.value = 20 + min(score, 0)

func _on_Quit_pressed():
	Game.transition_to_scene("res://Scenes/MainMenu.tscn")

func _on_Replay_pressed():
	SfxManager.play("buttonpress")
	Game.current_level_path = "res://Scenes/Levels/Level01.tscn"
	Game.transition_to_scene(Game.current_level_path)
	yield(ScreenTransition, "transitioned_halfway")
	Game.new_game()
