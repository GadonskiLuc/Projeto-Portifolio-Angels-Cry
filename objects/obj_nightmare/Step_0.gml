// Inherit the parent event
event_inherited();

//if instance_exists(myFloorPlat){ yspd *= -1 };

if type == "horizontal"{
	yspd = 0;
	if x <= iniX-maxW || x >= iniX+maxW{
		xspd *= -1;
	}
}
if type == "vertical"{
	xspd = 0;
	if y <= iniY-maxH || y >= iniY+maxH{
		yspd *= -1;
	}
}
if type == "diagonal"{
	if x <= iniX-maxW || x >= iniX+maxW{
		xspd *= -1;
	}
	if y <= iniY-maxH || y >= iniY+maxH{
		yspd *= -1;
	}
}
y += yspd;