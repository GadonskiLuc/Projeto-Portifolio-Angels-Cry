//configurando inputs
downKey			= keyboard_check_pressed(ord("S")) + gamepad_button_check_pressed(0, gp_padd);
downKey			= clamp(downKey, 0, 1);
upKey			= keyboard_check_pressed(ord("W")) + gamepad_button_check_pressed(0, gp_padu);
upKey			= clamp(upKey, 0, 1);
acceptKey		= keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(0, gp_face1);
acceptKey		= clamp(acceptKey, 0, 1);

//guardar quantidade de opções no menu atual
op_length = array_length(option[menu_level])

//percorrer o menu
pos += downKey - upKey;

//sfx de opções
if (downKey || upKey) && !playedSound {
	audio_play_sound(snd_menu_select,8,false);
}
playedSound = true;

//não loopar o sfx
if downKey + upKey == 0{
	playedSound = false;
}

if pos >= op_length{ pos = 0};
if pos < 0{ pos = op_length-1};

//usar as opções
if acceptKey{
	//som de confirm
	audio_play_sound(snd_menu_confirm,8,false);
	
	var _sml = menu_level;
	
	switch(menu_level){
		//menu principal
		case 0:
			switch(pos){
				case 0://start game
					var _transition = instance_create_layer(0, 0, layer, obj_transition);
					_transition.destination  = rmBoss1;
					_transition.destinationX = global.iniX;
					_transition.destinationY = global.iniY;
					break;
				case 1://options
					menu_level = 1;
					break;
				case 2://credits
		
					break;
				case 3://quit game
					game_end();
					break;
			}
			break;
		//menu de configurações
		case 1:
			switch(pos){
					case 0://sound on/off
						/*TODO*/
						break;
					case 1://controls
						/*TODO*/
						break;
					case 2://back
						menu_level = 0;
						break;
			}
			break;
		
	}
	
	//voltar para a primeira opção do menu
	if _sml != menu_level{ pos = 0};
	
	//tamanho correto do menu
	op_length = array_length(option[menu_level])
}