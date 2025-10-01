if(inv_timer <= 0){
	damage_timer = damage_time;
	inv_timer = inv_time;
	pushTimer = pushTime;

	global.life -= 2;
	
	setOnGround(false);
	yspd = -5;
	xspd = 3 * (face*-1);
	getting_damage = true;
}