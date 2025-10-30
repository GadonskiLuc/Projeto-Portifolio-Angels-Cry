if inv_timer <= 0 && state != "dash"{
	//toca som de hit
	if !playedSound{
		audio_play_sound(snd_gabriel_hurt,8,false)
	}
	playedSound = true
	//dar dano
	global.life -= 2;
	
	damage_timer = damage_time;
	inv_timer = inv_time;

	setOnGround(false);
	yspd = -5;
	xspd = 3 * (face*-1);
	getting_damage = true;
}