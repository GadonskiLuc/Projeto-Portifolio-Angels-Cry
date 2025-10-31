if room != rmTitleScreen{
	draw_sprite(spr_hpBar_back,1,35,20)
	draw_sprite_ext(spr_hpBar_front,1,35,20,
	max(0,global.life/global.Maxlife),1,0,c_white,1)
	
	draw_sprite(spr_gabriel_icon,1,10,10);
	draw_set_colour(c_yellow)
	draw_text_transformed(45,30, global.lives,2,2,0)

}