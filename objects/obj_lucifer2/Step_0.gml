if !instance_exists(obj_transition){
	if life <= 0{
		instance_destroy(self);
	}else{
		//movimento horizontal
		x+= xspd;

		#region//movimento vertical
			
			if onGround {
				yspd = 0;
				airHoldTimer = 0;
			}
			if !onGround{	
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
				reachedTop = false;
				airHoldTimer = 0;
				attacked = false;
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
						
						if y > 70 && !reachedTop{
							xspd = 5* sign(-image_xscale);
							yspd = jspd;
						}
						
						if y <= 70 && !reachedTop{
							xspd = 0
							reachedTop = true;
							airHoldTimer = airHoldTime;
						}
						if reachedTop{
							xspd = 0;
							yspd = 0;
						}
						if airHoldTimer > 0{
							airHoldTimer--
						}else if airHoldTimer <= 0 && reachedTop{
							yspd = 5;
							var _floor = instance_place(x, y, obj_wall);
							if _floor{
								y = _floor.bbox_top
								if !attacked{
									var _impactL = instance_create_layer(x, y, "Instances", obj_impact);
									var _impactR = instance_create_layer(x, y, "Instances", obj_impact);
									_impactR.right = true;
								}
								onGround = true;
								attacked = true;
								xspd = 6;
								if x >= 430{
									idleTimer = idleTime;
									state = "idle"
								}
							}
						}
						
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