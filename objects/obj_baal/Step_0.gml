if !instance_exists(obj_transition){
	if life <= 0{
		sprite_index = spr_damage
		if alpha >= 0{
			y+=2
			alpha -=.01
		}else{
			
			ini_open("checkpoint.ini");

			ini_write_real("player", "iniX", global.iniX);
			ini_write_real("player", "iniY", global.iniY);
			ini_write_real("player", "room", room);
			ini_write_real("player", "Maxlife", global.Maxlife);
			ini_write_real("player", "dash", global.powerUp[0]);
			ini_write_real("player", "defense", global.powerUp[1]);

			ini_close();
			
			instance_destroy(self);
			var _wrap = instance_create_layer(400,225,"Sensors", obj_wrapPortal);
			_wrap.destination = rmBoss3;
			_wrap.destinationX = global.iniX;
			_wrap.destinationY = global.iniY;
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
				droppedLife = false;
				playedSound = false;
				playedSoundFire = false;
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
						
						if !playedSound{
							audio_play_sound(snd_stone_falling,8,false)
						}
						playedSound = true;
						
						
						var _armAtk = instance_create_layer(obj_player.x,60,"Instances",obj_baal_arm);
						_armAtk.father = self
						timesAttacked++
					
						state = "idle";
						
					}
				}else{
					sprite_index = spr_attack2
					if !playedSoundFire{
						audio_play_sound(snd_baal_charging_fire,8,false)
					}
					playedSoundFire = true;
					
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
						
						if !playedSound{
							audio_play_sound(snd_baal_fireball,8,false)
						}
						playedSound = true;
					
						state = "idle";
						idleTimer = idleTime;
					}
				}	
				
			break;
			
			case "attacked":
				sprite_index = spr_damage;
				
				var _dropHealth = irandom(10)
				if _dropHealth > 8 && !droppedLife && global.life < 8{
					instance_create_layer(obj_player.x,60, "Instances", obj_life);
				}
				droppedLife = true;
		
				if animation_end(){
					state = "idle";
				}
				
			break;

		}
	}
}