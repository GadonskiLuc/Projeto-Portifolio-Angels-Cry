//desenha o inimigo
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale*face, image_yscale, image_angle, image_blend, image_alpha);
draw_text(x,y-50,"Life:	"+string(life));
//desenhando uma linha para checar o campo de visao do inimigo
//draw_line(x, y-sprite_height/2 , x + (dist*sign(-face)),y - sprite_height/2);