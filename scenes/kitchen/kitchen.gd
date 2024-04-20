extends Node3D

class Stats:
	var amount: int
	var mistakes: int = 0
	var remaining: int
	
	func _init(count: int):
		amount = 0
		remaining = count

const pizza_scene = preload("res://scenes/pizza/pizza.tscn")

const FINISHED_SPEED = 0.010
const SPEED_INCREMENT = 0.00005

class Recipe:
	var sauce: Ingredient.Sauce
	var cheese: bool = true
	var pepperoni: int
	var shrimp: int
	var pineapple: int
	
	func _init():
		sauce = Ingredient.Sauce.TOMATO if randi_range(0, 1) else Ingredient.Sauce.HOT
		pepperoni = randi_range(0, 5)
		shrimp = randi_range(0, 5)
		pineapple = randi_range(0, 5)

enum Gamemode {
	ARCADE,
	ENDLESS,
}

@export var gamemode: Gamemode

@export var recipe_label: Label3D

@export var stats_label: Label3D

@export var path: Path3D

@export var animation_player: AnimationPlayer
@export var music: AudioStreamPlayer

## Game stats
var stats: Stats

var recipe: Recipe: set = _set_recipe

var completed := false
var speed := 0.0005

var pizza: Pizza
var current_speed

func _ready() -> void:
	recipe = Recipe.new()
	match gamemode:
		Gamemode.ARCADE: stats = Stats.new(40)
		Gamemode.ENDLESS: stats = Stats.new(-1)
	_spawn_pizza()
	_update_stats()

func _physics_process(delta: float) -> void:
	if pizza:
		current_speed = speed if not completed else lerp(current_speed, FINISHED_SPEED, delta)
		pizza.progress_ratio += current_speed
		if pizza.progress_ratio >= 1:
			_check_finished_pizza()

func _spawn_pizza() -> void:
	if pizza:
		if pizza.ingredients_modified.is_connected(_check_unfinished_pizza):
			pizza.ingredients_modified.disconnect(_check_unfinished_pizza)
		pizza.queue_free()
	var new_pizza = pizza_scene.instantiate()
	path.add_child(new_pizza)
	pizza = new_pizza
	new_pizza.ingredients_modified.connect(_check_unfinished_pizza)

func _check_pizza() -> bool:
	if (pizza.sauce == recipe.sauce
	and pizza.cheese == recipe.cheese
	and pizza.pepperoni == recipe.pepperoni
	and pizza.shrimp == recipe.shrimp
	and pizza.pineapple == recipe.pineapple):
		return true
	else:
		return false

func _check_unfinished_pizza() -> void:
	if _check_pizza():
		completed = true

func _check_finished_pizza() -> void:
	if completed:
		stats.amount += 1
		if gamemode != Gamemode.ENDLESS:
			stats.remaining -= 1
		speed += SPEED_INCREMENT
		recipe = Recipe.new()
		_spawn_pizza()
	else:
		stats.mistakes += 1
		# speed -= SPEED_INCREMENT
		if stats.mistakes < 3:
			var tween = get_tree().create_tween()
			tween.tween_property(music, "pitch_scale", music.pitch_scale + 0.1, 2)
			tween.play()
		_spawn_pizza()
		animation_player.play("incorrect")
	completed = false
	_update_stats()

func _update_stats() -> void:
	stats_label.text = "Pizzas Made: %s\nPizzas Left: %s\nMistakes: %s" % [stats.amount, "∞" if stats.remaining == -1 else str(stats.remaining), stats.mistakes]
	if stats.remaining == 0:
		$Endgame/Victory.visible = true
		await get_tree().create_timer(5).timeout
		Game.emit_signal("change_scene", load("res://scenes/title_screen/title_screen.tscn"))
	if stats.mistakes >= 3:
		$Endgame/Failure.visible = true
		await get_tree().create_timer(5).timeout
		Game.emit_signal("change_scene", load("res://scenes/title_screen/title_screen.tscn"))

func _set_recipe(value: Recipe):
	recipe = value
	
	var string := ""
	
	match value.sauce:
		Ingredient.Sauce.TOMATO: string += "Tomato sauce\n"
		Ingredient.Sauce.HOT: string += "Hot sauce\n"
		
	if value.cheese: string += "Cheese\n"
	
	if value.pepperoni: string += "%s Pepperoni\n" % str(value.pepperoni)
	if value.shrimp: string += "%s Shrimp\n" % str(value.shrimp)
	if value.pineapple: string += "%s Pineapple\n" % str(value.pineapple)
	
	recipe_label.text = string
