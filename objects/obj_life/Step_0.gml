yspd += grav;
var _floor = instance_nearest(x,y+1,obj_wall);
var _semiFloor = instance_nearest(x,y,obj_semiSolidWall);

if place_meeting(x,y+1,obj_wall){
	yspd = _floor.yspd;
	xspd = _floor.xspd;
}
if place_meeting(x, y+1, obj_semiSolidWall){
	yspd = _semiFloor.yspd;
	xspd = _semiFloor.xspd;
	//y = _semiFloor.y;
}
x += xspd; 
y += yspd;

if collectTimer > 0{
	collectTimer--;
}
if collectTimer <= 0{
	sprite_index = spr_life_disappear;
	if animation_end(){
		instance_destroy();
	}
}