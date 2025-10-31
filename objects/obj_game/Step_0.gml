if global.life <= 0 {
	obj_player.xspd = 0;
	obj_player.yspd = 0;
	obj_player.state = "idle";
	
	global.lives--
	
	
	if room == rmLvl2 || room == rmLvl1{
		room_restart();
	}else{
		room_goto_previous()
	}
}

if global.lives < 0{
	game_restart();
}