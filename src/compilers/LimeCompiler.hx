package src.compilers;

import sys.io.Process;
import sys.io.File;
import sys.FileSystem;
import src.JsonFile;
import src.SlushiUtils;
import src.Main;
import src.utils.Defines;

class LimeCompiler {
	static var jsonFile:JsonStruct = JsonFile.getJson();
	static var exitCodeNum:Int = 0;

	public static function init() {
		if (jsonFile == null) {
			SlushiUtils.printMsg("Error loading [hxCompileUHLConfig.json]", "error");
			return;
		}

		// Check if all required fields are set
		if (jsonFile.limeConfig.sourceDir == "") {
			SlushiUtils.printMsg("sourceDir in [hxCompileUHLConfig.json -> limeConfig.sourceDir] is empty", "error");
			exitCodeNum = 3;
			return;
		} else if (jsonFile.limeConfig.reportErrorStyle == "") {
			SlushiUtils.printMsg("reportErrorStyle in [hxCompileUHLConfig.json -> limeConfig.reportErrorStyle] is empty", "error");
			exitCodeNum = 3;
			return;
		}

		SlushiUtils.printMsg("Trying to compile Lime project... (To HLC)", "processing");

		var compileProcess = null;
		if (jsonFile.limeConfig.debugMode) {
			compileProcess = Sys.command("lime", ["test", "hl", "-hlc", "--debug", "-D SKIP_UCHAR"]);
		} else {
			compileProcess = Sys.command("lime", ["test", "hl", "-hlc", "-D SKIP_UCHAR"]);
		}
		if (compileProcess != 0) {
			SlushiUtils.printMsg("Compilation failed", "error", "\n");
			exitCodeNum = 2;
		}

		if (exitCodeNum == 0) {
			SlushiUtils.printMsg("Compilation successful", "success", "\n");
		}
	}

	public static function getExitCode():Int {
		return exitCodeNum;
	}
}
