extends Node

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player
var score = 0 setget set_score
var num_circles = 0
var highscore = 0
var new_highscore = false
var level = 0
var bonus = 0 setget set_bonus

func _ready():
	randomize()
	load_score()
	$HUD.hide()
	
func new_game():
	new_highscore = false
	settings.hide_ad_banner()
	self.score = 0
	self.bonus = 0
	num_circles = 0
	level = 1
	$HUD.update_score(score, 0)
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_Captured")
	player.connect("died", self, "_on_Jumper_Died")
	spawn_circle($StartPosition.position)
	if settings.enable_music:
		$Music.play()
		$Music.volume_db = 0
	$HUD.show()
	$HUD.show_message("Go!")
	
func spawn_circle(_position = null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x,y)
	add_child(c)
	c.connect("full_orbit", self, "set_bonus", [1])
	c.init(_position, level)
	
func _on_Jumper_Captured(object):
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	self.score += 1 * bonus
	self.bonus += 1
	num_circles += 1
	if num_circles > 0 and num_circles % settings.circles_per_level == 0:
        level += 1
        $HUD.show_message("Level %s" % str(level))
func _on_Jumper_Died():
	if score > highscore:
		highscore = score
		save_score()
	get_tree().call_group("circles", "implode")
	$Screens.game_over(score, highscore)
	if settings.enable_music:
		fade_music()
	$HUD.hide()
	settings.show_ad_interstitial()
	
func set_score(value):
	$HUD.update_score(score, value)
	score = value
	if score > highscore and !new_highscore:
		$HUD.show_message("New Record!")
		new_highscore = true
	
		
func load_score():
	var f = File.new()
	if f.file_exists(settings.score_file):
		f.open(settings.score_file, File.READ)
		highscore = f.get_var()
		f.close()
	
func save_score():
	var f = File.new()
	f.open(settings.score_file, File.WRITE)
	f.store_var(highscore)
	f.close()
	
func fade_music():
	$MusicFade.interpolate_property($Music, "volume_db", 0, -50, 1.0, Tween.TRANS_SINE, Tween.EASE_IN)
	$MusicFade.start()
	yield($MusicFade, "tween_all_completed")
	$Music.stop()
	
func set_bonus(value):
	bonus = value
	$HUD.update_bonus(bonus)