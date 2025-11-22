if gameOver{
	var _x1 = view_xport[0];
	var _w = view_wport[0];
	var _x2 = _x1 + _w;
	var _halfW = _x2/2;
	var _y1 = view_yport[0];
	var _h = view_hport[0];
	var _y2 = _y1 + _h*2;
	var _halfH = _y2/2;
	
	var _barH = _h * .30;
	
	barSpd = lerp(barSpd, 1, .05);
	
	draw_set_colour(c_black);
	
	//escurecer a tela
	draw_set_alpha(barSpd * 0.3);
	draw_rectangle(_x1,_y1,_x2,_y2,false)
	
	//desenhando a barra de cima
	draw_set_alpha(1);
	draw_rectangle(_x1,_y1,_x2,_y1 + _barH * barSpd, false);
	
	//desenhando a barra de baixo
	draw_rectangle(_x1,_y2,_x2,_y2 - _barH * barSpd, false);

	draw_set_alpha(1);
	draw_set_colour(-1);
	
	if barSpd >= .80{
		
		fontAlpha = lerp(fontAlpha,1,.01);
		//escrevendo game over
		draw_set_alpha(fontAlpha);
		draw_set_font(font_main);
		draw_set_valign(1);
		draw_set_halign(1);
	
		draw_text_transformed(_halfW,_halfH,"Game Over",3,3,0);
		draw_text_transformed(_halfW,_halfH+50,"Pressione 'Enter' ou 'Start' para reiniciar",1,1,0);
	
		draw_set_font(-1);
		draw_set_valign(-1);
		draw_set_halign(-1);
		draw_set_alpha(1);
	}
}else{
	barSpd = 0;
	fontAlpha = 0;
	if room != rmTitleScreen && room != rmCreditsScreen{
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
	if(instance_exists(obj_lucifer2)){
	
		draw_sprite(spr_hpBar_back_boss,1,65,500)
		draw_sprite_ext(spr_hpBar_front_boss,1,65,500,
		max(0,obj_lucifer2.life/15),1,0,c_white,1)

	}
}