extends CharacterBody2D

# Define a velocidade de movimento do personagem
const SPEED = 300.0
# Define a força do pulo (negativa porque vai contra a direção da gravidade)
const JUMP_FORCE = -400.0
var is_jumping :=  false
@onready  var animacao := $anim as AnimatedSprite2D

# Função principal que processa a física do personagem a cada frame
func _physics_process(delta: float) -> void:
	# Adiciona a gravidade ao personagem se ele não estiver no chão
	if not is_on_floor():
		# Aumenta a velocidade vertical aplicando a gravidade multiplicada pelo delta (tempo entre frames)
		velocity += get_gravity() * delta

	# Lida com o pulo, verificando se a tecla "jump" (W ou seta para cima) ou "ui_accept" (padrão do Godot) foi pressionada
	# Só permite o pulo se o personagem estiver no chão (is_on_floor())
	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		# Aplica a força do pulo à velocidade vertical
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		

	# Obtém a direção de entrada (esquerda/direita) somando o input de "A" e "D" (move_left, move_right) e as setas
	var direction := Input.get_axis("move_left", "move_right") + Input.get_axis("ui_left", "ui_right")
	
	# Se houver alguma direção pressionada (direita ou esquerda), move o personagem nessa direção com a velocidade definida
	if direction != 0:
		velocity.x = direction * SPEED
		animacao.scale.x = direction
		if !is_jumping:
			animacao.play("run")
	elif is_jumping:
			animacao.play("jump")
			
	else:
		# Se nenhuma direção estiver sendo pressionada, desacelera suavemente o personagem até parar
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animacao.play("idle")

	# Move o personagem com a física, permitindo deslizar ao colidir com paredes
	move_and_slide()
