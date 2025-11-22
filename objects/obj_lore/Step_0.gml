confirmButton = keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed(0, gp_start);
confirmButton = clamp(confirmButton,0,1);

y -= scroll_speed;

if y <= -string_height(text) || confirmButton{
	if global.finished{
		var _transition = instance_create_layer(0, 0, layer, obj_transition);
		_transition.destination  = rmCreditsScreen;
	}else{
		var _transition = instance_create_layer(0, 0, layer, obj_transition);
		_transition.destination  = rmLvl1;
		_transition.destinationX = global.iniX;
		_transition.destinationY = global.iniY;
	}
}