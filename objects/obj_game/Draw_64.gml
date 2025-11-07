if room != rmTitleScreen{
	draw_set_alpha(1)
	draw_sprite(spr_hpBar_back,1,35,20)
	draw_sprite_ext(spr_hpBar_front,1,35,20,
	max(0,global.life/global.Maxlife),1,0,c_white,1)
	
	draw_sprite(spr_gabriel_icon,1,10,10);
	draw_set_colour(c_yellow)
	draw_text_transformed(45,30, global.lives,2,2,0)

}

if(instance_exists(obj_baal)){
	
	draw_sprite(spr_hpBar_back_boss,1,65,500)
	draw_sprite_ext(spr_hpBar_front_boss,1,65,500,
	max(0,obj_baal.life/40),1,0,c_white,1)

}
if(instance_exists(obj_lucifer)){
	
	draw_sprite(spr_hpBar_back_boss,1,65,500)
	draw_sprite_ext(spr_hpBar_front_boss,1,65,500,
	max(0,obj_lucifer.life/15),1,0,c_white,1)

}