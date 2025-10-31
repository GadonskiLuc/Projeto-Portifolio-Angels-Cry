//ja mudei
if changed{
	alpha-=.02;
}else{//nao mudei
	alpha +=.02;
}
//quando alpha passar de 1, muda de room
if alpha >= 1 {
	room_goto(destination);
	
	//posicionando o player
	if room == rmLvl2{
		obj_player.x = 100;
		obj_player.y = 350;
	}else{
		obj_player.x = destinationX;
		obj_player.y = destinationY;
	}
}

//destruindo o objeto

if changed && alpha <= 0{
	instance_destroy();
}