if !instance_exists(obj_transition){
	if life <= 0{
		sprite_index = spr_death
		if animation_end(){
			global.finished = true;
			instance_destroy(self);
			var _transition = instance_create_layer(x,y,"Controllers",obj_transition);
			_transition.destination = rmLoreScreen;
			instance_destroy(obj_player);
		}
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
			if point_distance(x, y, obj_player.x, obj_player.y) < 50{
				//atacar com impacto quando o player tiver perto
				attackType = 0
			}else{
				//escolher o proximo ataque aleatoriamente
				attackType = irandom(2);
			}
			
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
				if x >= 450 {xspd = 0};
				
				//ataque com espada
				if attackType >=0 && attackType < 2{
					
					attacking = true;
					onGround = false;
					
					if sprite_index != spr_attack1_1 
					&& sprite_index != spr_damage_on_atk1 
					&& sprite_index != spr_damage_on_atk2
					&& !reachedTop{
						
						sprite_index = spr_attack1_1;
						image_index = 0;
						
					}
					if instance_exists(obj_player){
						
						if animation_end(){
							image_index = 6;
							if !playedSound{
								audio_play_sound(snd_baal_charging_fire, 8, false);
								playedSound = true;
							}
							
							if y > 80 && !reachedTop{
								xspd = 7* sign(-image_xscale);
								yspd = jspd;
							}
						
							if y <= 80 && !reachedTop{
								xspd = 0
								reachedTop = true;
							}
							if reachedTop{
								xspd = 0;
								yspd = 0;
								if sprite_index != spr_attack1_2{
									sprite_index = spr_attack1_2;
								}
	
								if animation_end(){
									image_index = 5;
									yspd = 7;
									var _floor = instance_place(x, y, obj_wall);
									if _floor{
										y = _floor.bbox_top
										if !attacked{
											audio_play_sound(snd_baal_atk_arm, 8, false);
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
						
						}
					}
				}else{
					//segundo ataque
					
					if sprite_index != spr_attack2{
						image_index = 0;
						sprite_index = spr_attack2;
						audio_play_sound(snd_lucifer_atk2, 8, false);
					}
					
					if animation_end(){
						var _orb = instance_create_layer(x+(20*-image_xscale), y-sprite_height+20, "Instances", obj_blue_orb);
						_orb.targetY = 280
						var _orb2 = instance_create_layer(x+(20*-image_xscale), y-sprite_height+10, "Instances", obj_blue_orb);
						_orb2.targetY = 190
						var _orb3 = instance_create_layer(x+(20*-image_xscale), y-sprite_height, "Instances", obj_blue_orb);
						_orb3.targetY = 100
					
						state = "idle";
						idleTimer = idleTime;
					}
				}
			break;
			
			case "attacked":
				if x <= 40 {xspd = 0};
				if x >= 430 {xspd = 0};
				if y >= 224 {
					yspd = 0;
					y = 224;
				};
				if y < 80 {yspd = 0};
					
				invTimer = invTime;
				if attacking{
					if sprite_index == spr_attack1_1{
						sprite_index = spr_damage_on_atk1;
					}else{
						sprite_index = spr_damage_on_atk2
					}				
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