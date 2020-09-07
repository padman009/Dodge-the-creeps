extends Node

export (PackedScene) var Mob
var score

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()
	$DeathSound.play()
	if $HUD/ScoreLabel.text.to_int() > $HUD/HighScore.text.substr(5).to_int():
		$HUD/HighScore.text = $HUD/HighScore.text.substr(0, 5) + $HUD/ScoreLabel.text
	pass # Replace with function body.

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	pass

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var mob = Mob.instance()
	add_child(mob)
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	
	mob.position = $MobPath/MobSpawnLocation.position
	
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	pass # Replace with function body.


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	pass # Replace with function body.


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	pass # Replace with function body.
