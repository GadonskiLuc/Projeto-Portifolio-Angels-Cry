if life <= 0{
	spawnLife = irandom(4);
	if spawnLife == 4{
		instance_create_layer(x,y-sprite_height/2,"Instances", obj_life);
	}
	instance_destroy(self);
}else{
	
	//checa se está na tela
	if checkIfInViewport(x+sprite_get_width(0),y) 
	|| checkIfInViewport(x-sprite_get_width(0),y)
	|| checkIfInViewport(x,y-sprite_get_height(0)){
		active = true;
	}else{
		active = false;
	}
	
	if active{
		//movimento horizontal
	
		if xspd != 0{
			face = sign(xspd);
		}
	
		var _subPixel = .5;
		//perto de parede
		if place_meeting(x + 150, y, obj_wall) {
			//parar
			xspd = 0;
			state = "idle";
		}
	
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

		if invTimer > 0{
			invTimer--;
		}
		
		if idleTimer > 0{
			idleTimer--;
		}

		//state machine do inimigo
		switch (state){
			case "idle":
				//parado
				if sprite_index != spr_idle{
					sprite_index = spr_idle;
					image_index = 0;
				}
				xspd = 0;
				//ficar parado por um tempo antes de voltar a atacar
				var _closeToHole = !place_meeting(x + 100*face, y+1, obj_wall);
				var _closeToCarrascal = place_meeting(x + 100*face, y, obj_carrascal);
			
				if instance_exists(obj_player){
					var _dist = point_distance(x, y , obj_player.x, obj_player.y);
					var _dir = point_direction(x, y, obj_player.x, obj_player.y);
				
					if _dist <= 300 && idleTimer <= 0 && !_closeToHole && !_closeToCarrascal{
						xspd = lengthdir_x(maxVel,_dir);
						//player perto, boss vai atras dele
						state = "walking";
					}else if _dist < 75 && idleTimer <= 0{
						state = "attack";
					}
				}
			break;
	
			case "walking":
				//andando
				if sprite_index != spr_walking {
					sprite_index = spr_walking;
					image_index = 0;
				}
		
				//seguir o player
				if instance_exists(obj_player){
			
					var _dist = point_distance(x, y , obj_player.x, obj_player.y);
					var _dir = point_direction(x, y , obj_player.x, obj_player.y);
					var _closeToHole = !place_meeting(x + 100*face, y+1, obj_wall);
					var _closeToCarrascal = place_meeting(x + 100*face, y, obj_carrascal);
					
					if _closeToHole || _closeToCarrascal{ 
						xspd = 0;
						state = "idle";
					}else{
					
						if _dist > 75{
							xspd = lengthdir_x(maxVel,_dir);
						}else{
							//chegou perto demais ele ataca
							xspd = 0;
							state = "attack";
						}
					}
			
				}
				break;
			case "attack":
		
				enemy_attack(spr_attack,2, 3,sprite_width/2, -sprite_height/3,2,2);
				idleTimer = idleTime;
			break;
			
			case "attacked":
				//sprite_index = spr_damage;
		
				if animation_end(){
					state = "idle";
				}
				
			break;

		}
	}else{
		//checa se o spawn do inimigo está na tela
		if !checkIfInViewport(iniX+sprite_get_width(0),iniY) 
		&& !checkIfInViewport(iniX-sprite_get_width(0),iniY)
		&& !checkIfInViewport(iniX,iniY-sprite_get_height(0))
		&& !checkIfInViewport(iniX,iniY){
			x = iniX;
			y = iniY;
		}
	}
}