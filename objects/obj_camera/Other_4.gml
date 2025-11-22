//sair se não tiver um player
if !instance_exists(obj_player) exit;

//guardar o tamanho da camera
var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeigth = camera_get_view_height(view_camera[0]);

//guardar as coordenadas do foco da camera
var _camX = obj_player.x - _camWidth/2;
var _camY = (obj_player.y) - _camHeigth/2;

//fixar a camera nas bordas da sala/janela
_camX = clamp(_camX, 0, room_width - _camWidth);
_camY = clamp(_camY, 0, room_height - _camHeigth);

//definir coordenadas da camera ao iniciar a sala
finalCamX = _camX;
finalCamY = _camY;