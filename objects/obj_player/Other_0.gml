if y >= room_height{
	state = "death";
	global.lives--
	if global.lives >= 0{
		room_restart();
	}
}