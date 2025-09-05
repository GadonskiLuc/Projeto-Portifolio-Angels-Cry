function player_state_attack_slash(){
	xspd = 0;
	yspd += grav;

	//atacano
	if sprite_index != spr_gabriel_attack_slash{
		sprite_index = spr_gabriel_attack_slash;
		image_index = 0;
		ds_list_clear(hitByAttack);
	}

	//usar a hitbox e checar hits
	mask_index = spr_gabriel_attack_slash_HB;
	var _hitByAtkNow = ds_list_create();
	var _hits = instance_place_list(x,y,obj_enemy1,_hitByAtkNow,false);

	if _hits>0{
		for(var i = 0; i<_hits; i++){
			//se essa instancia ainda não foi acertada por esse ataque
			var _hitId = _hitByAtkNow[| i];
			if ds_list_find_index(hitByAttack, _hitId) == -1{
				ds_list_add(hitByAttack,_hitId);
				with(_hitId){
					_hitId.life -= 2;
					_hitId.damageTimer = _hitId.damageTime;
				}
			}
		}
	}

	ds_list_destroy(_hitByAtkNow);

	mask_index = spr_gabriel_idle;

	if animation_end(){
		sprite_index = spr_gabriel_idle;
		state = PLAYERSTATE.FREE
	}
}