font_main = font_add_sprite(spr_main_font,32, true,2);

if global.finished{
	text = "Com a derrota de Lucifer, \n o arcanjo Gabriel sacramenta \n a vitoria do ceu sobre sua revolta, \n e o bane para as profundesas \ndo Tartaro, onde permanecera preso \npelo resto da eternidade. \n\nPelo menos,\nassim nossos herois esperam..."
}else{
	text = "Preludio \n\nGenesis, \nantes do inicio dos tempos, \na Santa Trindade governa os ceus \ne seus anjos sob um regime de \npaz e serenidade,\n paz essa que durou centenas de eras. \nPorem, \nchega o momento que Deus mais temia, \nseu fiel arcanjo Lucifer, \njunto de inumeros companheiros, \nse revoltam contra o dominio divino, \ndando inicio a primeira Guerra Santa. \n\nDentro desse cenario, \n Deus envia seu arcanjo, Gabriel, \n afim de enfrentar o exercito de caidos,\n assim enfraquecendo o poder \nde seu ex-companheiro Lucifer \ne prende-lo nas profundezas do\n Tartaro pelo resto da eternidade"
}
scroll_speed = .5; 
y = room_height;

