extends Node2D

const GrassEffect = preload("res://Effects/grass_effect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_hurtbox_area_entered(_area): # area lleva _ para que no me tire warning por no usarlo dentro de la funcion
	create_grass_effect()
	queue_free()
