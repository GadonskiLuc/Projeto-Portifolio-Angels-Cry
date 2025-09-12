// inputs
	getControls()
	
	if instance_exists(obj_transition) exit;
	
switch(state){
	case PLAYERSTATE.FREE: player_state_free(); break;
	case PLAYERSTATE.ATTACK_SLASH: player_state_attack_slash(); break;
	case PLAYERSTATE.ATTACK_COMBO: player_state_attack_combo(); break;
}
