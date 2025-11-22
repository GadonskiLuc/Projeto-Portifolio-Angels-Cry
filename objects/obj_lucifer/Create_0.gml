// Inherit the parent event
event_inherited();

spr_idle = spr_lucifer_idle;
spr_walking = spr_lucifer_idle; // mudar
spr_damage = spr_lucifer_damage;
spr_damage_on_atk = spr_lucifer_damage_on_attack;
spr_attack1 = spr_lucifer_attack1;
spr_attack2 = spr_lucifer_attack2;
spr_death = spr_lucifer_death;
playedSound = false;

xspd = 0;
max_xspd = 1.5;

life = 15;

idleTimer = 0;
idleTime = 60;
invTimer = 0;
invTime = 60;

side = "right";
firstAtk = true;
strength = 2;
attackType = 0;
attacking = false;

state = "idle";