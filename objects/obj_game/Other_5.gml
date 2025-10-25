if global.life > 0 
&& room != rmLvl1
&& room != rmLvl2{
	if (file_exists("checkpoint.ini"))
	{
	        file_delete("checkpoint.ini");
	}
}