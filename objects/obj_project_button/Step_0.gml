if (position_meeting(mouse_x, mouse_y, self)){
	if (mouse_check_button(mb_left))
		image_index = 2;
	else
		image_index = 1;	

	if (mouse_check_button_released(mb_left)){
		global.yyp = get_open_filename("GameMaker Project (*.yyp)", "");
		global.project_path = filename_path(global.yyp);
	}
}
else
	image_index = 0;
	