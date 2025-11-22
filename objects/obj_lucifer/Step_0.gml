if !instance_exists(obj_transition){
	if life <= 0{
		
		sprite_index = spr_death
		
		if animation_end(){
			instance_destroy(self);
		
			global.iniX = 96;
			global.iniY = 352;
		
			var _dash = instance_create_layer(x,y,"Instances",obj_upgrade);
			_dash.type = 0;
			var _wrap = instance_create_layer(460,224,"Sensors", obj_wrapPortal);
			_wrap.destination = rmLvl2;
			_wrap.destinationX = global.iniX;
			_wrap.destinationY = global.iniY;
		}
	}else{
		//movimento horizontal
		x+= xspd;

		#region//movimento vertical
			//gravidade
			yspd += grav;
	
			//colisao vertical
	
			//limitar a velocidade de queda
			if yspd > termVel {
				yspd = termVel;
			}
			//colisão vertical com chão
		
			//checar se ha plataformas solidas ou semisolidas abaixo
			var _clampYspd = max(0, yspd);
			var _list = ds_list_create(); //criar uma dslist para guardar todos os objetos que estamos indo em direção
			var _array = array_create(0);
			array_push(_array,obj_wall,obj_semiSolidWall);
		
			//checar os objetos e os adcionar na lista
			var _listSize = instance_place_list(x, y + 1 + _clampYspd + termVel, _array, _list, false);
		
				////correção de bug para caso usar sprites com maior resolução
				var _yCheck = y+1 + _clampYspd;
				if instance_exists(myFloorPlat) { _yCheck += max(0,myFloorPlat.yspd)};
				var _semiSolid = checkForSemisolidePlatform(x, _yCheck);
		
			//percorrer os objetos colididos e retornar apenas o que o topo esta abaixo do inimigo
			for(var i = 0; i < _listSize; i++){
				//guardar cada objeto
				var _listInst = _list[|	i];
			
				//evitar magnetismo
				if (_listInst != forgetSemiSolid
				&& (_listInst.yspd <= yspd || instance_exists(myFloorPlat)) 
				&& (_listInst.yspd > 0 || place_meeting(x, y+1 + _clampYspd, _listInst )))
				|| (_listInst == _semiSolid){
					//retornar uma parede solida ou semisolida que esta abaixo do jogador
					if _listInst.object_index == obj_wall 
					|| object_is_ancestor(_listInst.object_index, obj_wall) 
					|| floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.yspd){
						//retornar o objeto mais "alto"
						if !instance_exists(myFloorPlat)
						|| _listInst.bbox_top + _listInst.yspd <= myFloorPlat.bbox_top + myFloorPlat.yspd
						|| _listInst.bbox_top + _listInst.yspd <= bbox_bottom{
							myFloorPlat = _listInst;
						}
					}
				}
			}
			//destruir a lista para não usar memoria atoa
			ds_list_destroy(_list);
		
			//basicamente ter certeza de que pisamos numa plataforma ao descer degraus
			if instance_exists(downSlopeSemiSolid) {myFloorPlat = downSlopeSemiSolid}
		
			//ultimo confere pra ver se realmente ha um chao abaixo do inimigo
			if instance_exists(myFloorPlat) && !place_meeting(x,y + termVel, myFloorPlat){
				myFloorPlat = noone;
			}
		
			//pisar na plataforma se há uma
		
			if instance_exists(myFloorPlat){
			
				var _subPixel = .5;
				while !place_meeting(x, y + _subPixel, myFloorPlat) && !place_meeting(x, y, obj_wall){	y+= _subPixel;	};
				//ter certeza de que nao estejamos debaixo do topo de uma plataforma semisolida
				if myFloorPlat.object_index == obj_semiSolidWall || object_is_ancestor(myFloorPlat.object_index, obj_semiSolidWall){
					while place_meeting(x, y, myFloorPlat) {	y-=_subPixel;	};
				}
				//arredondar a variavel y
				y = floor(y);
			
				//colidir com o chao
				yspd = 0;
			}
		
			//mover-se
			if !place_meeting(x, y + yspd, obj_wall){	
				y += yspd;
			}
		#endregion
	
		if idleTimer > 0{
			if point_distance(x, y, obj_player.x, obj_player.y) < 50{
				//atacar com a espada quando o player tiver perto
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
					if sprite_index != spr_attack1 && sprite_index != spr_damage_on_atk{
						sprite_index = spr_attack1;
						image_index = 0;
						
					}
					if instance_exists(obj_player){
						
						if animation_end(){
							if !playedSound{
								audio_play_sound(snd_lucifer_atk1,8,false);
							}
							playedSound = true;
							image_index = 6;
							xspd = 10* sign(-image_xscale);
				
							if !firstAtk{
								if x <= 50 && side == "right"{
									side = "left";
									image_xscale *= -1;
									state = "idle";
									idleTimer = idleTime;
					
								}else if x >= 400 && side == "left"{
									side = "right";
									image_xscale *= -1;
									state = "idle";
									idleTimer = idleTime;
					
								}
							}
							firstAtk = false;
						}
					}
				}else{
					if sprite_index != spr_attack2{
						sprite_index = spr_attack2;
						image_index = 0;
						if !playedSound{
							audio_play_sound(snd_lucifer_atk2,8,false);
						}
						playedSound = true;
					}
					if animation_end(){
						var _orb = instance_create_layer(x+(20*-image_xscale), y-sprite_height+10, "Instances", obj_orb);
						state = "idle";
						idleTimer = idleTime;
					}
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