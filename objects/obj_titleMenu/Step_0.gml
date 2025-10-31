//configurando inputs
downKey			= keyboard_check_pressed(ord("S")) + gamepad_button_check_pressed(0, gp_padd);
downKey			= clamp(downKey, 0, 1);
upKey			= keyboard_check_pressed(ord("W")) + gamepad_button_check_pressed(0, gp_padu);
upKey			= clamp(upKey, 0, 1);
acceptKey		= keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(0, gp_face1);
acceptKey		= clamp(acceptKey, 0, 1);


//percorrer o menu
pos += downKey - upKey;

if (downKey || upKey) && !playedSound {
	audio_play_sound(snd_menu_select,8,false);
}
playedSound = true;

if downKey + upKey == 0{
	playedSound = false;
}

if pos >= op_length{ pos = 0};
if pos < 0{ pos = op_length-1};

//usar as opções
if acceptKey{
	audio_play_sound(snd_menu_confirm,8,false);
	switch(pos){
		case 0://start game
			room_goto_next();
			break;
		
		case 1://quit game
			game_end();
			break;
	}
}