// Inherit the parent event
event_inherited();
if life > 0{
	//se chega numa beirada, dar a meia volta
	if instance_exists(myFloorPlat){
			if (myFloorPlat.object_index == obj_semiSolidWall && !place_meeting(x+sign(xspd)*sprite_width,y+1,obj_semiSolidWall)){
				xspd *= -1
			}
	}

	//pisar na plataforma se há uma
	if instance_exists(myFloorPlat){
			
		var _subPixel = .5;
		while !place_meeting(x, y + _subPixel, myFloorPlat) && !place_meeting(x, y, obj_wall){	y+= _subPixel;	};
		//ter certeza de que nao estejamos debaixo do topo de uma plataforma semisolida
		if myFloorPlat.object_index == obj_semiSolidWall || object_is_ancestor(myFloorPlat.object_index, obj_semiSolidWall){
			while place_meeting(x, y, myFloorPlat) {	y-=_subPixel;	};
		}
		//arredondar a variavel y
		y = floor(y);
			
		//colidir com o chao
		yspd = 0;
	}

	//mover-se
	if !place_meeting(x, y + yspd, obj_wall){	
		y += yspd;
	}
}
