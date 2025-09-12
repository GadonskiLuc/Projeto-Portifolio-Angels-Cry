//checar se colidiu com o player

var _player = place_meeting(x, y, obj_player);

if (_player && !colided){
	colided = true;
	obj_player.sprite_index = spr_gabriel_idle;
	//transicionando
	var _tran = instance_create_layer(0,0,layer,obj_transition);
	
	_tran.destination = destination;
	_tran.destinationX = destinationX;
	_tran.destinationY = destinationY;
	
}else if !_player{
	colided = false;
}