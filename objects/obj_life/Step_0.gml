yspd += grav;
if place_meeting(x,y+1,obj_wall)
|| place_meeting(x,y+1,obj_semiSolidWall){
	yspd = 0;
}
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