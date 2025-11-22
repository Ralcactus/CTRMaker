// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_resetbuild(){
	var rootfolder_files = file_find_first(global.project_path + "\\export_project\\" + "*.*", 0);
	while rootfolder_files != ""
	{
		file_delete(global.project_path + "\\export_project\\" + rootfolder_files)
		rootfolder_files = file_find_next();
	}
	file_find_close();


	var buildfolder_files = file_find_first(global.project_path + "\\export_project\\build\\" + "*.*", 0);
	while buildfolder_files != ""
	{
		file_delete(global.project_path + "\\export_project\\build\\" + buildfolder_files);
		buildfolder_files = file_find_next();
	}
	file_find_close();


	var romfsfolder_files = file_find_first(global.project_path + "\\export_project\\romfs\\" + "*.*", 0);
	while romfsfolder_files != ""
	{
		file_delete(global.project_path + "\\export_project\\romfs\\" + romfsfolder_files);
		romfsfolder_files = file_find_next();
	}
	file_find_close();


	var sourcefolder_files = file_find_first(global.project_path + "\\export_project\\source\\" + "*.*", 0);
	while sourcefolder_files != ""
	{
		file_delete(global.project_path + "\\export_project\\source\\" + sourcefolder_files);
		sourcefolder_files = file_find_next();
	}
	file_find_close();


	var spritesfolder_files = file_find_first(global.project_path + "\\export_project\\sprites\\" + "*.*", 0);
	while spritesfolder_files != ""
	{
		file_delete(global.project_path + "\\export_project\\sprites\\" + spritesfolder_files);
		spritesfolder_files = file_find_next();
	}
	file_find_close();


	var outputfolder_files = file_find_first(global.project_path + "\\export_project\\3dsx\\" + "*.*", 0);
	while outputfolder_files != ""
	{
		file_delete(global.project_path + "\\export_project\\3dsx\\" + outputfolder_files);
		outputfolder_files = file_find_next();
	}
	file_find_close();

	directory_destroy(global.project_path + "\\export_project\\sprites\\");
	directory_destroy(global.project_path + "\\export_project\\source\\");
	directory_destroy(global.project_path + "\\export_project\\romfs\\");
	directory_destroy(global.project_path + "\\export_project\\build\\");
	directory_destroy(global.project_path + "\\export_project\\3dsx\\");
	directory_destroy(global.project_path + "\\export_project\\");
}