function controlsSetup(){
	bufferTime			= 5;
	
	jumpKeyBuffered		= 0;
	jumpKeyBufferTimer	= 0;
}

function getControls(){
	//direction inputs
	rightKey		= keyboard_check(ord("D")) + gamepad_button_check(0, gp_padr);
	rightKey		= clamp(rightKey, 0, 1)
	
	leftKey			= keyboard_check(ord("A")) + gamepad_button_check(0, gp_padl);
	leftKey			= clamp(leftKey, 0, 1)
	
	downKey			= keyboard_check(ord("S")) + gamepad_button_check(0, gp_padd);
	downKey			= clamp(downKey, 0, 1)
	
	upKey			= keyboard_check(ord("W")) + gamepad_button_check(0, gp_padu);
	upKey			= clamp(upKey, 0, 1)
	
	//action inputs
	jumpKeyPressed	= keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(0, gp_face1);
	jumpKeyPressed	= clamp(jumpKeyPressed, 0, 1);
	
	jumpKey			= keyboard_check(vk_space) + gamepad_button_check(0, gp_face1);
	jumpKey			= clamp(jumpKey, 0, 1);
	
	runKey			= keyboard_check(vk_shift) + gamepad_button_check(0, gp_face3);
	runKey			= clamp(runKey, 0, 1);
	
	attackKey		= mouse_check_button_pressed(1) + gamepad_button_check_pressed(0, gp_face2);
	attackKey		= clamp(attackKey, 0, 1);
	
	dashKey			= mouse_check_button_pressed(mb_right) + gamepad_button_check_pressed(0, gp_shoulderl);
	dashKey			= clamp(dashKey, 0, 1);
	
	confirmButton = keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed(0, gp_start);
	confirmButton = clamp(confirmButton,0,1);
	
	//jumpkey buffering
	if jumpKeyPressed {
		jumpKeyBufferTimer = bufferTime;
	}
	if jumpKeyBufferTimer > 0 {
		jumpKeyBuffered = 1;
		jumpKeyBufferTimer--;
	}else{
		jumpKeyBuffered = 0;
	}
}

function checkIfInViewport(_x, _y){
	//guardando dimensões da camera
	var vx1 = camera_get_view_x(view_camera[0]);
	var vy1 = camera_get_view_y(view_camera[0]);
	var vw = camera_get_view_width(view_camera[0]);
	var vh = camera_get_view_height(view_camera[0]);

	// Checa se o objeto está dentro do viewport
	if (_x > vx1 && _x < vx1 + vw && _y > vy1 && _y < vy1 + vh) {
	    return true; 
	
	}else{
		return false;	
	}
}

function checkForSemisolidePlatform(_x, _y){
	//variavel de retorno
	var _rtrn = noone;
	
	//nao estamos subindo, ai checamos uma colisao normalmente
	if yspd >= 0 && place_meeting(_x, _y, obj_semiSolidWall){
		//criar uma dslist para guardar todas as instancias de colisao com a obj_semiSolidWall
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x,_y, obj_semiSolidWall, _list, false);
		
		//percorrer pela lista e retornar apenas a plataforma que esata abaixo do player
		for(var i = 0; i< _listSize; i++){
			var _listInst = _list[| i];
			if _listInst != forgetSemiSolid && floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.yspd){
				//retornar o id da plataforma
				_rtrn = _listInst;
				//sair do loop mais cedo
				i = _listSize;
			}
		}
		//destruir a lista para economizar memoria
		ds_list_destroy(_list);
	}
	//retornar a variavel
	return _rtrn;
}