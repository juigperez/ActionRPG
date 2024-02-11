extends CharacterBody2D

var knockback = Vector2.ZERO
const KNOCKBACK_AMMOUNT = 500
const FRICTION = 0.8

func _physics_process(delta):
	if velocity != Vector2.ZERO:
		velocity *= FRICTION
		move_and_slide()

func _on_hurtbox_area_entered(area):
	knockback = area.knockback_vector * KNOCKBACK_AMMOUNT
	velocity = knockback
