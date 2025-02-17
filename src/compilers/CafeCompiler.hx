package src.compilers;

import src.compilers.LimeCompiler;
import sys.io.Process;
import sys.io.File;
import sys.FileSystem;
import src.JsonFile;
import src.SlushiUtils;
import haxe.Resource;
import src.Main;
import src.utils.Libs;

using StringTools;

class CafeCompiler {
	static var jsonFile:JsonStruct = JsonFile.getJson();
	static var exitCodeNum:Int = 0;

	public static function init() {
		if (LimeCompiler.getExitCode() != 0) {
			return;
		}

		// SlushiUtils.printMsg("\n", "none");

		if (jsonFile == null) {
			SlushiUtils.printMsg("Error loading [hxCompileUHLConfig.json]", "error");
			return;
		}

		// Check if all required fields are set
		if (jsonFile.limeConfig.projectName == "") {
			SlushiUtils.printMsg("projectName in [hxCompileUHLConfig.json -> limeConfig.projectName] is empty", "error");
			exitCodeNum = 3;
			return;
		}

		SlushiUtils.printMsg("Trying to compile to Wii U project...", "processing");

		SlushiUtils.printMsg("Creating Makefile...", "processing");
		// Create a temporal Makefile with all required fields
		try {
			// Prepare Makefile
			var makefileContent:String = Resource.getString("cafeMakefileWUT");
			makefileContent = makefileContent.replace("[PROGRAM_VERSION]", Main.version);
			makefileContent = makefileContent.replace("[PROJECT_NAME]", jsonFile.limeConfig.projectName);
			makefileContent = makefileContent.replace("[SOURCE_DIR]", jsonFile.limeConfig.exportDir + "/hlc/obj");
			makefileContent = makefileContent.replace("[INCLUDE_DIR]", jsonFile.limeConfig.exportDir + "/hlc/obj");
			makefileContent = makefileContent.replace("[LIBS]", parseMakeLibs());

			if (!FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.limeConfig.exportDir + "/wiiuFiles")) {
				FileSystem.createDirectory(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.limeConfig.exportDir + "/wiiuFiles");
			}
			makefileContent = makefileContent.replace("[OUT_DIR]", jsonFile.limeConfig.exportDir + "/wiiuFiles");

			// Why Haxe can't delete that directory? wtf
			// delete build directory
			// if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/build")) {
			// 	FileSystem.deleteDirectory(SlushiUtils.getPathFromCurrentTerminal() + "/build");
			// }

			// Save Makefile
			// delete temporal makefile if already exists
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
				FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
				SlushiUtils.printMsg("Deleted existing [Makefile]", "info");
			}

			File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile", makefileContent);
			SlushiUtils.printMsg("Created Makefile", "success");
		} catch (e:Dynamic) {
			SlushiUtils.printMsg("Error creating Makefile: " + e, "error");
			exitCodeNum = 4;
			return;
		}

		SlushiUtils.printMsg("Compiling to Wii U...\n", "processing");

		var compileProcess = Sys.command("make");
		if (compileProcess != 0) {
			SlushiUtils.printMsg("Compilation failed", "error", "\n");
			exitCodeNum = 2;
		}

		// delete temporal makefile
		if (jsonFile.deleteTempFiles == true) {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
				FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
			}
		}

		if (exitCodeNum == 0) {
			SlushiUtils.printMsg('Compilation successful. Check [${jsonFile.limeConfig.exportDir}/wiiuFiles]', "success", "\n");
		}
	}

	public static function getExitCode():Int {
		return exitCodeNum;
	}

	static function parseMakeLibs():String {
		var libs = "";

		for (lib in Libs.parseMakeLibs()) {
			libs += lib + " ";
		}

		return libs;
	}
}
