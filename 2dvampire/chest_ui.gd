extends NinePatchRect

@onready var chest : AnimatedSprite2D = $AnimatedSprite2D
@onready var options: VBoxContainer = %Options
@onready var rewards: Control = $Rewards

func _ready() -> void:
	randomize()
	hide()
	$Open.show()
	$Close.hide()

func open() -> void:
	clear_reward()
	chest.play("idle")
	get_tree().paused = true
	show()
	$Open.show()
	$Close.hide()

func _on_open_pressed() -> void:
	chest.play("open")
	await chest.animation_finished
	set_reward()
	$Open.hide()
	$Close.show()

func _on_close_pressed() -> void:
	get_tree().paused = false
	hide()

func set_reward():
	clear_reward()
	
	var chance : float = randf()
	
	if chance < 0.5:
		upgrade_item(2,3)
		print("rare")
	elif chance < 0.75:
		upgrade_item(1,4)
		print("epic")
	else:
		upgrade_item(0,5)
		print("legendary")

func upgrade_item(start, end):
	for index in range(start, end):
		var upgrades = options.get_available_upgrades()
		
		if upgrades.size() == 0:
			add_gold(index)
		else:
			var selected_upgrade : Item
			selected_upgrade = upgrades.pick_random()
			if selected_upgrade is Weapon and selected_upgrade.max_level_reached():
				rewards.get_child(index).texture = selected_upgrade.evolution.icon
			else:
				rewards.get_child(index).texture = selected_upgrade.icon
			selected_upgrade.upgrade_item()

func clear_reward():
	for slot in rewards.get_children():
		slot.texture = null
		
func add_gold(index):
	var gold : Gold = load("res://2dvampire/PickupResources/Gold.tres")
	gold.player_reference = owner
	rewards.get_child(index).texture = gold.icon
	gold.activate()
