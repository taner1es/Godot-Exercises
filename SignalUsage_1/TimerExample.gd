extends Node

func _ready():
	$Timer.connect("timeout",self,"_on_Timer_timeout")
	
func _on_Timer_timeout():
	$Sprite.visible = !$Sprite.visible
