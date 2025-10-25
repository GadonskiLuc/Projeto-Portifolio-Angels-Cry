if global.life <= 0 {
	if room == rmLvl2 || room == rmLvl1{
		room_restart();
	}else{
		room_goto_previous()
	}
}