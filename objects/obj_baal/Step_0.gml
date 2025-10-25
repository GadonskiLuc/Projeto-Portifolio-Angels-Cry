if !instance_exists(obj_transition){
	if life <= 0{
		sprite_index = spr_damage
		if alpha >= 0{
			y+=2
			alpha -=.01
		}else{
			instance_destroy(self);
			var _sensor = instance_create_layer(483,224,"Sensors", obj_sensor);
			_sensor.destination = rmLvl2;
			_sensor.destinationX = obj_player.iniX;
			_sensor.destinationY = obj_player.iniY;
		}
	}else{
	
		if idleTimer > 0{
			attackType = irandom(3);
			//attackType = 2;
			idleTimer--;
		}
		if invTimer > 0{
			invTimer--;
		}

		//state machine do boss
		switch (state){
			case "idle":
				//parado
				if sprite_index != spr_idle && animation_end(){
					sprite_index = spr_idle;
					image_index = 0;
				}
				xspd = 0;
				
				if idleTimer <= 0 && timesAttacked <= 0{
					if instance_exists(obj_player){
						state = "attack";
					
					}
				}
			break;	
			
			case "attack":
				if attackType >=0 && attackType < 2{
					if timesAttacked <=0{
						sprite_index = spr_attack1
						
						var _armAtk = instance_create_layer(obj_player.x,60,"Instances",obj_baal_arm);
						_armAtk.father = self
						timesAttacked++
					
						state = "idle";
						
					}
				}else{
					sprite_index = spr_attack2
					
					if animation_end(){
						var _orb1 = instance_create_layer(x, y-195, "Instances", obj_flameBall);
						var _orb2 = instance_create_layer(x, y-195, "Instances", obj_flameBall);
						var _orb3 = instance_create_layer(x, y-195, "Instances", obj_flameBall);
						var _orb4 = instance_create_layer(x, y-195, "Instances", obj_flameBall);
						var _orb5 = instance_create_layer(x, y-195, "Instances", obj_flameBall);
					
						_orb1.targetX = x
						_orb2.targetX = x+150
						_orb3.targetX = x-150
						_orb4.targetX = x-350
						_orb5.targetX = x+350
					
					
						state = "idle";
						idleTimer = idleTime;
					}
				}	
				
			break;
			
			case "attacked":
				sprite_index = spr_damage;
		
				if animation_end(){
					state = "idle";
				}
				
			break;

		}
	}
}