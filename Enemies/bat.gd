extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	KNOCKBACK,
	CHASE
}

var state = IDLE
@export var KNOCKBACK_AMMOUNT = 500
@export var FRICTION = 4000
@export var MAX_SPEED = 200
@export var ACCELERATION = 20

@onready var sprite = $AnimatedSprite
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollition = $SoftCollision
@onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	sprite.flip_h = velocity.x < 0
	match state:
		IDLE:
			idle_state(delta)
		WANDER:
			pass
		KNOCKBACK:
			knockback_state(delta)
		CHASE:
			chase_state(delta)
	
	if softCollition.is_colliding():
		velocity += softCollition.get_push_vector() * delta * 400
		move_and_slide()
		
func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	seek_player()

func wander_state():
	pass

func knockback_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	if velocity == Vector2.ZERO:
		state = IDLE

func chase_state(delta):
	var player = playerDetectionZone.player
	if player:
		var direction = (player.global_position - global_position).normalized() #Vector unitario que apunta en la dirección que une al bat con el player
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		move_and_slide()
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * KNOCKBACK_AMMOUNT
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	state = KNOCKBACK

func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_hurtbox_invincibility_started():
	animationPlayer.play("start")

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("stop")
