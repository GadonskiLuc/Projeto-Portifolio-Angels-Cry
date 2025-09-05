//se mexer em circulos
dir += rotSpd;

//saber nossa posição alvo
var _targetX = xstart+lengthdir_x(radius, dir);
var _targetY = ystart+lengthdir_y(radius, dir);

//guardar a xspd e a yspd

xspd = _targetX - x;
//xspd = 0;
//yspd = _targetY - y;
yspd = 0;

//movimento

x += xspd;
y += yspd;