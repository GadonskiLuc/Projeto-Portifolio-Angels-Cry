if(inv_timer <= 0) 
&& state != "dash"
&& room != rmBoss2{
	//toca som de hit
	if !playedSoundDmg{
		audio_play_sound(snd_gabriel_hurt,8,false)
	}
	playedSoundDmg = true
	damage_timer = damage_time;
	inv_timer = inv_time;
	pushTimer = pushTime;

	global.life -= other.strength;
	
	setOnGround(false);
	yspd = -5;
	xspd = 3 * (face*-1);
	getting_damage = true;
}