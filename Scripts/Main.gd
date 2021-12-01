extends Node

export (PackedScene) var Mob
var score 


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func gamer_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()
	$DeathSound.play()


func _on_MobTimer_timeout():
	$MobPath/MobSpawLocation.offset = randi()
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTime_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTime.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
