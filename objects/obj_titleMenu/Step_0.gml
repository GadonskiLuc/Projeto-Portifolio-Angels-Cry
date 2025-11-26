//configurando inputs
downKey			= keyboard_check_pressed(ord("S")) + keyboard_check_pressed(vk_down) + gamepad_button_check_pressed(0, gp_padd);
downKey			= clamp(downKey, 0, 1);
upKey			= keyboard_check_pressed(ord("W")) + keyboard_check_pressed(vk_up) + gamepad_button_check_pressed(0, gp_padu);
upKey			= clamp(upKey, 0, 1);
acceptKey		= keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed(0, gp_face1);
acceptKey		= clamp(acceptKey, 0, 1);
backKey			= keyboard_check_pressed(vk_backspace) + gamepad_button_check_pressed(0, gp_face2);
backKey			= clamp(backKey, 0, 1);

//guardar quantidade de opções no menu atual
op_length = array_length(option[menu_level])

//percorrer o menu
pos += downKey - upKey;

//voltar
if backKey && menu_level > 0{
	audio_play_sound(snd_menu_select,8,false);
	menu_level--;
	//tamanho correto do menu
	op_length = array_length(option[menu_level])
}

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
				case 0://load game
					if (file_exists("checkpoint.ini")){
						ini_open("checkpoint.ini");
					    global.iniX = ini_read_real("player", "iniX", global.iniX);
					    global.iniY = ini_read_real("player", "iniY", global.iniY);
					    global.room = ini_read_real("player", "room", global.room);
					    global.life = ini_read_real("player", "Maxlife", global.life);
					    global.powerUp[0] = ini_read_real("player", "dash", global.powerUp[0]);
						global.powerUp[1] = ini_read_real("player", "defense", global.powerUp[1]);
		
					    ini_close();
						
						var _transition = instance_create_layer(0, 0, layer, obj_transition);
						_transition.destination  = global.room;
						_transition.destinationX = global.iniX;
						_transition.destinationY = global.iniY;
					}
					break;
				case 1://start game
					if (file_exists("checkpoint.ini")){
						file_delete("checkpoint.ini");
					}
					global.finished = false;
					var _transition = instance_create_layer(0, 0, layer, obj_transition);
					_transition.destination  = rmLoreScreen;
					break;
				case 2://options
					menu_level = 1;
					break;
				case 3://credits
					room_goto(rmCreditsScreen);
					break;
				case 4://quit game
					game_end();
					break;
			}
			break;
		//menu de configurações
		case 1:
			switch(pos){
					case 0://sound on/off
						if global.musicVolume == 1 { 
							global.musicVolume = 0 
							option[1, 0] = "Musica: Nao";
						}else{ 
							global.musicVolume = 1
							option[1, 0] = "Musica: Sim";
						}
						break;
					case 1://fullscreen
						window_set_fullscreen( !window_get_fullscreen() );
						break;
					case 2://controls
						menu_level = 2;
						break;
					case 3://back
						menu_level = 0;
						break;
			}
			break;
		//menu de controles	
		case 2:
			switch(pos){
					case 0://back
						menu_level = 1
						break;
			}
			break;
		
	}
	
	//voltar para a primeira opção do menu
	if _sml != menu_level{ pos = 0};
	
	//tamanho correto do menu
	op_length = array_length(option[menu_level])
}