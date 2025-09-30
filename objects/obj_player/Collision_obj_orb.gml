if inv_timer <= 0 && state != "dash"{
	//dar dano
	global.life -= 3;
	
	damage_timer = damage_time;
	inv_timer = inv_time;
	getting_damage = true;
	
	//se destruir
	instance_destroy(other);
}