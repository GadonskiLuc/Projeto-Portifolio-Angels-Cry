if !instance_exists(obj_transition){
	if life <= 0{
		instance_destroy(self);
	}else{
		//movimento horizontal
		x+= xspd;

		#region//movimento vertical
			
			if onGround {
				jumpHoldTimer	= 0;
			}
			//pulo baseado no tempo em que o botão é pressionado
			if jumpHoldTimer > 0{
				//definindo a velocidade vertical para a velocidade de pulo constantemente
				yspd = jspd;
				jumpHoldTimer--;
			}
			
			if onGround{	
				yspd = 0;
			}
			
			if !place_meeting(x, y + yspd, obj_wall){	
				y += yspd;
			}
			
		#endregion
	
		if idleTimer > 0{	
			//escolher o proximo ataque aleatoriamente
			attackType = 0;
			
			idleTimer--;
		}
		if invTimer > 0{
			invTimer--;
		}

		#region //state machine do boss
		switch (state){
			case "idle":
				onGround = true;
				playedSound = false;
				//parado
				if sprite_index != spr_idle{
					sprite_index = spr_idle;
					if !attacking{
						image_index = 0;
					}
				}
				
				xspd = 0;
				
				attacking = false;
				//ficar parado por um tempo antes de voltar a atacar
				if idleTimer <= 0{
					if instance_exists(obj_player){
						//player perto, boss vai atras dele
						state = "attack";
					}
				}
			break;
	
			case "attack":
				//parar nas bordas da tela
				if x <= 40 {xspd = 0};
				if x >= 430 {xspd = 0};
				
				//ataque com espada
				if attackType >=0 && attackType < 2{
					attacking = true;
					onGround = false;
					/*if sprite_index != spr_attack1 && sprite_index != spr_damage_on_atk{
						sprite_index = spr_attack1;
						image_index = 0;
						
					}*/
					if instance_exists(obj_player){
					
						xspd = 5* sign(-image_xscale);
						jumpHoldTimer = jumpHoldTime;
				
						
						if y <= 70 && !reachedTop{
							xspd = 0
							yspd = 5
						}
						//reachedTop = true;
						
					}
				}else{
					//segundo ataque
				}
			break;
			
			case "attacked":
				if x <= 40 {xspd = 0};
				if x >= 430 {xspd = 0};
					
				if attacking{
					sprite_index = spr_damage_on_atk;
					
					if animation_end(){
					state = "attack";
				}
									
				}else{
					sprite_index = spr_damage;
					if animation_end(){
					state = "idle";
				}
				}
				
				
			break;

		}
		#endregion
	}
}