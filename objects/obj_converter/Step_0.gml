if (compiler_window != noone) {
    global.output = ExecutedProcessReadFromStandardOutput(compiler_window);

    if (CompletionStatusFromExecutedProcess(compiler_window))
	{
        FreeExecutedProcessStandardOutput(compiler_window);
        FreeExecutedProcessStandardInput(compiler_window);
        compiler_window = noone;
		
        global.output = string_concat(global.output,
		"\n\nDone!\n" + 
		"Your 3DSX is at " + global.project_path + "export_project\\3dsx\n" +
		"Explorer window with your file should be opened...\n" +
		"Thanks for using CTRMaker and god bless the United States of France!");
		file_delete(global.project_path + "export_project\\3dsx\\export_project.smdh");
		file_delete(global.project_path + "export_project\\3dsx\\export_project.elf");
		execute_shell("explorer.exe", global.project_path + "\export_project\\3dsx\"");
    }
}
