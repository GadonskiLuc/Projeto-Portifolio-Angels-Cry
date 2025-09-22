function player_state_attack_slash(){
	xspd = 0;

	//atacano
	if sprite_index != spr_gabriel_attack_slash{
		sprite_index = spr_gabriel_attack_slash;
		image_index = 0;
		ds_list_clear(hitByAttack);
	}
	//usar a hitbox e checar hits
	if damage == noone{
		damage = instance_create_layer(x, y, "Instances", obj_damage);
		damage.image_xscale = face;
		damage.father = id;
	}

	mask_index = spr_gabriel_idle;

	if animation_end(){
		sprite_index = spr_gabriel_idle;
		state = PLAYERSTATE.FREE
	}
}