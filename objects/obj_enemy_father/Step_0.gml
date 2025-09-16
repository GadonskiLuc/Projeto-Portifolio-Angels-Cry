if life <= 0{
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
	//só se move se estiver na tela
	if active{
		
		//atacado
		if attacked{
			xspd = (vel*.25)*face*-1;
			sprite_index = spr_damage;
		}
		
		if damageTimer > 0{
			attacked = true;
			damageTimer--;
		}else{
			attacked = false;
		}
		
		#region//sair de dentro das plataformas solidas que se posicionaram dentro do player na begin step
			var _rightWall	= noone;
			var _leftWall	= noone;
			var _bottomWall = noone;
			var _topWall	= noone;
			var _list = ds_list_create();
			var _listSize = instance_place_list(x, y, obj_movePlat, _list, false);
	
			//percorrer por todos os objetos da lista
			for(var i = 0; i < _listSize; i++){
				var _listInst = _list[| i];
		
				//checar se há paredes perto em cada direção e guardar a mais próxima
					//paredes à direita
					if _listInst.bbox_left - _listInst.xspd >= bbox_right-1{
						if !instance_exists(_rightWall) || _listInst.bbox_left < _rightWall.bbox_left{
							_rightWall = _listInst;
						}
					}
					//paredes à esquerda
					if _listInst.bbox_right - _listInst.xspd <= bbox_left+1{
						if !instance_exists(_leftWall) || _listInst.bbox_right > _leftWall.bbox_right{
							_leftWall = _listInst;
						}
					}
					//paredes abaixo
					if _listInst.bbox_top - _listInst.yspd >= bbox_bottom-1{
						if !instance_exists(_bottomWall) || _listInst.bbox_top < _leftWall.bbox_top{
							_bottomWall = _listInst;
						}
					}
					//paredes acima
					if _listInst.bbox_bottom - _listInst.yspd <= bbox_top+1{
						if !instance_exists(_topWall) || _listInst.bbox_bottom > _topWall.bbox_top{
							_topWall = _listInst;
						}
					}
			}
	
			//destruir a lista para economizar memoria
			ds_list_destroy(_list);
	
			//sair das paredes
				//direita
				if instance_exists(_rightWall){
					var _rightDist = bbox_right - x;
					x = _rightWall.bbox_left - _rightDist;
				}
				//esquerda
				if instance_exists(_leftWall){
					var _leftDist = x - bbox_left;
					x = _leftWall.bbox_right + _leftDist;
				}
				//abaixo
				if instance_exists(_bottomWall){
					var _bottomDist = bbox_bottom - y;
					y = _bottomWall.bbox_top - _bottomDist;
				}
				//acima
				if instance_exists(_topWall){
					var _topDist = y - bbox_top;
					var _targetY = _topWall.bbox_bottom + _topDist;
					//checar se não ha uma parede no caminho
					if !place_meeting(x, _targetY,obj_wall){
						y = _targetY;
					}
				}
		#endregion

		#region//movimento horizontal	
			
			//sprite virar pro lado que está andando
			if xspd != 0 {
				face = sign(xspd) * -1;
			}

			//colisao horizontal

			var _subPixel = .5;

			if place_meeting(x + xspd, y, obj_wall) {
		
				//ver se há um degrau na frente
				if !place_meeting(x+xspd, y - abs(xspd) - 1, obj_wall){
					while place_meeting(x+xspd, y, obj_wall){	y-= _subPixel;	}
				}else{ //checar se não há um degrau inverso a frente		
					//degrau inverso (tem o lance de duplicar o abs(xspd*2))
					if !place_meeting(x + xspd, y+abs(xspd)+1,obj_wall){
						while place_meeting(x+xspd,y,obj_wall){	y+= _subPixel;	}
					}else{
						//aproximar da parede precisamente
						var _pixelCheck = _subPixel * sign(xspd);
						while !place_meeting(x + _pixelCheck, y, obj_wall){	x += _pixelCheck;	}
						//definir a velocidade para -1 para virar
						xspd *= -1;
					}
				}
			}
	
			//descer degraus
			downSlopeSemiSolid = noone;
			if yspd >= 0 && !place_meeting(x+xspd,y+1,obj_wall) && place_meeting(x+xspd, y + abs(xspd)+1,obj_wall){
				//checar se há uma plataforma semisolida no caminho
				downSlopeSemiSolid = checkForSemisolidePlatform(x+xspd,y+abs(xspd)+1);
				//precisamente descendo se não há uma plataforma no caminho
				if !instance_exists(downSlopeSemiSolid){
					while !place_meeting(x+ xspd, y+_subPixel,obj_wall){	y+=_subPixel;	}
				}
			}
			//se chega numa beirada, dar a meia volta
			if instance_exists(myFloorPlat){
				if (myFloorPlat.object_index == obj_wall && !place_meeting(x+xspd,y+1,obj_wall))
				|| (myFloorPlat.object_index == obj_semiSolidWall && !place_meeting(x+xspd,y+1,obj_semiSolidWall)){
					xspd *= -1
				}
			}

			//mover-se
			x+= xspd;
		#endregion

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
		
		
		//controle de sprites
		
		if animation_end(spr_damage){	
			sprite_index = spr_idle;	
			xspd = vel*-face;
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