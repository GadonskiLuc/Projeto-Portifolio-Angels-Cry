// inputs
	getControls()
	
if instance_exists(obj_transition) exit;
	
if keyboard_check(ord("R")){
	game_restart();
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

#region//nao ser esquecido pela minha movePlat
earlyMoveplatXspd = false;
if instance_exists(myFloorPlat) && myFloorPlat.xspd !=0 && !place_meeting(x,y + termVel+1, myFloorPlat){
	//voltar para a plataforma
	if !place_meeting(x+ myFloorPlat.xspd, y, obj_wall){
		x += myFloorPlat.xspd;
		earlyMoveplatXspd = true;
	}
}
#endregion

#region//movimento horizontal

	//delay do dash
	if dashTimer > 0 {
		dashTimer--;
	}

	//se mover se nao estiver tomando dano
	if damage_timer <= 0{
		moveDir = rightKey - leftKey;
	}

	//velocidade horizontal
	runType = runKey;
	if pushTimer <= 0 && state != "attack" && state != "crouching" && state != "dash"{
		xspd = moveDir * moveSpd[runType];
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
				//definir a velocidade para 0 para colidir
				xspd = 0;
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

	//mover-se
	x+= xspd;
#endregion

#region//movimento vertical
	//gravidade
	
	if coyoteHangTimer > 0 {
		coyoteHangTimer--;
	}else{
		//aplicar a gravidade
		if !planing{
			yspd += grav;
		}
		//não esta mais no chão
		setOnGround(false);
	}
	
	//preparar variaveis de pulo
	if onGround {
		jumpCount		= 0;
		jumpHoldTimer	= 0;
		coyoteJumpTimer = coyoteJumpFrames;
	} else {
		//se o player estiver no ar, ter certeza de que não tenha um pulo extra
		coyoteJumpTimer--;
		if jumpCount == 0 && coyoteJumpTimer <=0 {
			jumpCount = 1;
		}
	}
	
	//iniciar o pulo
	var _floorIsSolid = false;
	if instance_exists(myFloorPlat)
	&& (myFloorPlat.object_index == obj_wall || object_is_ancestor(myFloorPlat.object_index, obj_wall)){
		_floorIsSolid = true;
	}
	
	//pular baixinho ao pressionar rapidamente o botão
	if !jumpKey {
		jumpHoldTimer = 0;
	}
	//pulo baseado no tempo em que o botão é pressionado
	if jumpHoldTimer > 0 && !planing {
		//definindo a velocidade vertical para a velocidade de pulo constantemente
		yspd = jspd[jumpCount-1];
		//contando o tempo
		jumpHoldTimer--;
	}
	
	//planar	
	if jumpCount > 1 && jumpKey && jumpHoldTimer > 0{
		setPlaning(true);
		yspd = planeSpd;
		jumpHoldTimer--;
	}
	setPlaning(false)
	
	
	//colisao vertical
	
		//limitar a velocidade de queda
		if yspd > termVel {
			yspd = termVel;
		}
	
		var _subPixel = .5;
		
		//colisão vertical subindo
		if yspd < 0 && place_meeting(x, y + yspd, obj_wall) {
			//pulando em degraus inversos
			
			var _slopeSlide = false;
			//slide upLeft
			if moveDir == 0 && !place_meeting(x - abs(yspd)-1, y + yspd,obj_wall){
				while place_meeting(x ,y + yspd,obj_wall){	x-= 1; }
				_slopeSlide = true;
			}
			
			//slide upRight
			if moveDir == 0 && !place_meeting(x + abs(yspd)+1, y + yspd,obj_wall){
				while place_meeting(x, y + yspd,obj_wall){	x += 1; }
				_slopeSlide = true;
			}
			//colisao normal
			if !_slopeSlide{
				//aproximar da parede precisamente
				var _pixelCheck = _subPixel * sign(yspd);
				while !place_meeting(x, y + _pixelCheck, obj_wall){
					y += _pixelCheck;
				}
				if yspd < 0 {
					jumpHoldTimer = 0;
				}
				
				//definir a velocidade para 0 para colidir
				yspd = 0;
			}
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
		
		//percorrer os objetos colididos e retornar apenas o que o topo esta abaixo do jogador
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
		
		//ultimo confere pra ver se realmente ha um chao abaixo do player
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
			setOnGround(true);
		}
		
		//mover-se
		if !place_meeting(x, y + yspd, obj_wall){	
			y += yspd;
		}
		//resetar a variavel forgetSemiSolid
		
		if instance_exists(forgetSemiSolid) && !place_meeting(x, y, forgetSemiSolid){
			forgetSemiSolid = noone;
		}
#endregion
	
#region//ultimos movimentos e colisoes com plataformas movimentadas
	//X - moveplatXspd e colisoes
	//guardar a moveplatXspd
	moveplatXspd = 0;
	if instance_exists(myFloorPlat) {moveplatXspd = myFloorPlat.xspd}
	
	//mover-se com a movepaltXspd
	if !earlyMoveplatXspd{
		if place_meeting(x+ moveplatXspd, y, obj_wall){
			//colar na parede precisamente
			var _subPixel = .5;
			var _pixelCheck = _subPixel * sign(moveplatXspd);
			while !place_meeting(x+ _pixelCheck, y, obj_wall){
				x+=_pixelCheck;
			}
		
			//definir moveplatXspd para 0 pra terminar a colisao
			moveplatXspd = 0;
		}
	}
	x += moveplatXspd;

	//Y - colar o player na myFloorPlataform se ela esta se movendo verticalmente
	if instance_exists(myFloorPlat) 
	&& (myFloorPlat.yspd != 0 
	|| myFloorPlat.object_index == obj_movePlat 
	|| object_is_ancestor(myFloorPlat.object_index, obj_movePlat)
	|| myFloorPlat.object_index == obj_semiSolidWallMovePlat 
	|| object_is_ancestor(myFloorPlat.object_index, obj_semiSolidWallMovePlat)	) {
		//colar no topo da plataforma
		if !place_meeting(x,myFloorPlat.bbox_top, obj_wall)
		&& myFloorPlat.bbox_top >= bbox_bottom-termVel{
			y = myFloorPlat.bbox_top;
		}
		
		//ficou redundande por causa do bloco de codigo abaixo
		
		/*//ser imprensado por uma parede solida enquanto esta numa plataforma semisolida
		if myFloorPlat.yspd < 0 && place_meeting(x, y + myFloorPlat.yspd, obj_wall){
			//ser derrubado da plataforma
			if myFloorPlat.object_index == obj_semiSolidWallMovePlat || object_is_ancestor(myFloorPlat.object_index, obj_semiSolidWallMovePlat){
				//ser derrubado
				var _subPixel = .25;
				while place_meeting(x,y + myFloorPlat.yspd, obj_wall){	y+= _subPixel;	};
				//se formos empurrados contra uma parede enquanto estamos descendo, nos empurrade de volta
				while place_meeting(x,y, obj_wall){	y-= _subPixel;	};
				y = round(y);
			}
			
			//cancelar a variavel myFloorPlat
			setOnGround(false);
		}*/
	}
	
	//ser derrubado de uma plataforma semisolida por uma plataforma solida
	if instance_exists( myFloorPlat)
	&& (myFloorPlat.object_index == obj_semiSolidWall || object_is_ancestor(myFloorPlat.object_index, obj_semiSolidWall))
	&& place_meeting(x, y, obj_wall){
		//se ja estou preso numa parede, tentar me derrubar de uma semisolida
		//se continuo preso significa que de fato estou preso ué
		
		//não checar demais para não entrar em paredes sólidas
		var _maxPushDist = 10;
		var _pushedDist	 = 0;
		var _startY		 = y;
		while place_meeting(x ,y, obj_wall) && _pushedDist <= _maxPushDist{
			y++;
			_pushedDist++;
		}
		//esquecer a myFloorPlat
		myFloorPlat = noone;
		
		//se continuo numa parede, basicamente não me descer da plataforma
		if _pushedDist > _maxPushDist {
			y = _startY;
		}
	}

#endregion
	
//checar se estou preso
image_blend = c_white;

if place_meeting(x, y, obj_wall){
	image_blend = c_blue;
}

//codigo para morrer se ficar preso numa parede
/*if place_meeting(x, y ,obj_wall){
	crushTimer++;
	if crushTimer > crushDeathTime{
		instance_destroy();
	}
}else{
	crushTimer = 0;
}*/
	
//definir colisao unica
mask_index = maskSpr;

#region//levando dano

//player voar pra tras
if pushTimer > 0 {
	pushTimer--;
}

if(damage_timer > 0){
	damage_timer--;
}else{
	getting_damage = false;
}
	
if(inv_timer > 0){
	inv_timer--;
	image_alpha = 0.5;
}else{
	image_alpha = 1;
}
#endregion

	
switch(state){
	
	#region //parado
	case "idle": 
		sprite_index = idleSpr;
		if attackKey {
			image_index = 0;
			state = "attack";		
		}else if jumpKeyBuffered && jumpCount < jumpMax && (!downKey || _floorIsSolid){
			image_index = 0;
			state = "jumping"
			//resetar o buffer
			jumpKeyBuffered		= false;
			jumpKeyBufferTimer	= 0;
		
			//encrementar nossa variavel jumpCount
			jumpCount++;
		
			//definir o jumpHoldTimer
			jumpHoldTimer = jumpHoldFrames[jumpCount-1];
		
			//nao estamos mais no chao
			setOnGround(false);
		}else if !onGround || yspd != 0{
			state = "jumping"
		}else if (rightKey || leftKey){
			state = "moving";
		}else if downKey && onGround{
			state = "crouching";
		}else if dashKey && global.powerUp[0] && dashTimer <= 0{
			image_index = 0;
			state = "dash";
		}
	break;
	#endregion
	
	#region ataque
	case "attack": //ataque
		if onGround{
			xspd = 0;
		}
		moveDir = 0;
		//atacano
		if sprite_index != attackSpr{
			sprite_index = attackSpr;
			image_index = 0;
			ds_list_clear(hitByAttack);
		}
		//usar a hitbox e checar hits
		if damage == noone{
			damage = instance_create_layer(x, y, "Instances", obj_damage);
			damage.image_xscale = face;
			damage.father = id;
		}
		if dashKey && global.powerUp[0] && dashTimer <= 0{
			image_index = 0;
			state = "dash";
			if damage{
				instance_destroy(damage,false);
				damage = noone;
			}
		}

		if animation_end(){
			sprite_index = idleSpr;
			state = "idle"
		}
	break;
	#endregion
	
	#region air attack
	case "air attack":
		//atacano
		if sprite_index != airAtkSpr{
			sprite_index = airAtkSpr;
			image_index = 0;
			ds_list_clear(hitByAttack);
		}
		
		if damage == noone{
			damage = instance_create_layer(x, y+10, "Instances", obj_damage);
			damage.image_xscale = face;
			damage.father = id;
		}
		
		if animation_end(){
			state = "jumping";
		}
		if onGround{
			state = "idle";
		}
	break;
	#endregion
	
	#region //movendo
	case "moving": 
		//andando
		if abs(xspd) > 0 {
			sprite_index = walkSpr;
		}
		//correndo
		if abs(xspd) >= moveSpd[1] {
			sprite_index = runSpr;
		}
		//player virar pro lado que está andando
		if moveDir != 0{
			face = moveDir;
		}
		if attackKey{
			state = "attack";
		}else if jumpKeyBuffered && jumpCount < jumpMax && (!downKey || _floorIsSolid){
			state = "jumping"
			//resetar o buffer
			jumpKeyBuffered		= false;
			jumpKeyBufferTimer	= 0;
		
			//encrementar nossa variavel jumpCount
			jumpCount++;
		
			//definir o jumpHoldTimer
			jumpHoldTimer = jumpHoldFrames[jumpCount-1];
		
			//nao estamos mais no chao
			setOnGround(false);
		}else if !onGround || yspd != 0{
			state = "jumping";
		}else if abs(xspd) < .1 && !downKey{
			state = "idle";
			xspd = 0;
		}else if downKey{
			xspd = 0;
			state = "crouching";
		}else if dashKey && global.powerUp[0] && dashTimer <= 0{
			image_index = 0;
			state = "dash";
		}
	break;
	#endregion
	
	#region pulando
	case "jumping": //pulando
		sprite_index = jumpSpr;
		
		if moveDir != 0{
			face = moveDir;
		}
		
		if onGround{
			state = "idle";
		}else if attackKey{
			state = "air attack";
		}
	break;
	#endregion
	
	#region agaixando
	case "crouching":
		sprite_index = crouchSpr;
		//manual = downKey || automatica = colisao com parede
		if onGround{
			crouching = true;
		}
		//forçada / automatica
		if onGround && place_meeting(x,y,obj_wall){
			crouching = true;
		}
		//mudar a colisao
		if crouching {mask_index = crouchSpr};
		//transição para levantar-se
			//manual = !downKey || automatica = !onGround
			if crouching && (!downKey || !onGround){
				//checar se posso me levantar
				mask_index = idleSpr;
				//levantar-se se não há uma parede no caminho
				if !place_meeting(x,y,obj_wall){
					crouching = false;
					state = "idle";
				}//se não, voltar para a colisão agaixado
				else{
					mask_index = crouchSpr;
				}	
			}
			
		//descer de uma plataforma semisolida manualmente
		if downKey && jumpKeyPressed {
			//ter certeza de que estamos numa plataforma semisolida
			if instance_exists(myFloorPlat) &&
			(myFloorPlat.object_index == obj_semiSolidWall || object_is_ancestor(myFloorPlat.object_index, obj_semiSolidWall)){
				//checar se podemos ir pra baixo da plataforma
				var _yCheck = max(1, myFloorPlat.yspd+1);
				if !place_meeting(x, y + _yCheck, obj_wall){
					//descer da plataforma
					y += 1;
					
					//herdar qualquer velocidade para baixo da plataforma para ela não nos pegar novamente
					yspd = _yCheck - 1;
					
					//esquecer essa plataforma para não ser pego por ela novamente
					forgetSemiSolid = myFloorPlat;
					
					//sem mais plataformas
					setOnGround(false);
				}
			}else{
				state = "jumping";
			}
		}
		
		if !downKey{
			state = "idle";
		}else if yspd != 0{
			state = "jumping";
		}else if attackKey{
			state = "attack";
		}
	break;
	#endregion
	
	#region dash
	case "dash":
		sprite_index = dashSpr;
		image_alpha = 0.5;
		//se mover
		xspd = dashSpd*face;
		
		//sair do estado
		if image_index >= image_number-1{
			state = "idle";
			dashTimer = dashTime;
		}
	break;
	#endregion
}
