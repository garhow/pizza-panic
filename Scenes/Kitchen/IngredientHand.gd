extends Area3D

@onready var controller: XRController3D = get_parent()

@export var IndicatorManager: IndicatorManager

var held_ingredient

func _physics_process(_delta) -> void:
	match controller.get_input("trigger_click"):
		true:
			if held_ingredient == null:
				_check_for_dispenser()
		false:
			if held_ingredient != null:
				_check_for_pizza()
	

func _check_for_dispenser() -> void:
	if get_overlapping_areas().size() > 0:
		for area in get_overlapping_areas():
			if area is Dispenser:
				held_ingredient = area.type
				IndicatorManager.visiblify(area.type)
				$Grab.play()

func _check_for_pizza() -> void:
	if get_overlapping_areas().size() > 0:
		for area in get_overlapping_areas():
			if area is PizzaArea:
				area.add_topping(held_ingredient)
	held_ingredient = null
	IndicatorManager.invisiblify()
	$Release.play()
