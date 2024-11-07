extends Node2D

@onready var sfx_player : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sfx(sfx : AudioStream):
	if sfx:
		sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.stream = sfx
		sfx_player.bus = "SFX"
		sfx_player.play()
		sfx_player.finished.connect(sfx_player.queue_free)
		
