if(inv_timer <= 0){
	//toca som de hit
	if !playedSoundDmg{
		audio_play_sound(snd_gabriel_hurt,8,false)
	}
	playedSoundDmg = true
	
	damage_timer = damage_time;
	inv_timer = inv_time;
	pushTimer = pushTime;

	global.life -= 2;
	
	setOnGround(false);
	yspd = -5;
	xspd = 3 * (face*-1);
	getting_damage = true;
}