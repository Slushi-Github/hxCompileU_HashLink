package src;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;
import src.SlushiUtils;
import src.Main;

typedef LimeConfig = {
	projectName:String,
	sourceDir:String,
	exportDir:String,
	reportErrorStyle:String,
	debugMode:Bool,
	hxDefines:Array<String>,
	othersOptions:Array<String>,
}

typedef JsonStruct = {
	programVersion:String,
	limeConfig:LimeConfig,
	deleteTempFiles:Bool,
	extraLibs:Array<String>,
}

class JsonFile {
	public static function getJson():JsonStruct {
		try {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUHLConfig.json")) {
				var jsonContent:Dynamic = Json.parse(File.getContent(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUHLConfig.json"));

				var jsonStructure:JsonStruct = {
					programVersion: jsonContent.programVersion,
					limeConfig: {
						projectName: jsonContent.limeConfig.projectName,
						sourceDir: jsonContent.limeConfig.sourceDir,
						exportDir: jsonContent.limeConfig.exportDir,
						reportErrorStyle: jsonContent.limeConfig.reportErrorStyle,
						debugMode: jsonContent.limeConfig.debugMode,
						hxDefines: jsonContent.limeConfig.hxDefines,
						othersOptions: jsonContent.limeConfig.othersOptions,
					},
					deleteTempFiles: jsonContent.deleteTempFiles,
					extraLibs: jsonContent.extraLibs,
				};
				return jsonStructure;
			}
		} catch (e) {
			SlushiUtils.printMsg("Error loading [hxCompileUHLConfig.json]: " + e, "error");
		}
		return null;
	}

	public static function createJson():Void {
		if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUHLConfig.json")) {
			SlushiUtils.printMsg("[hxCompileUHLConfig.json] already exists", "warning");
			return;
		}

		SlushiUtils.printMsg("Creating [hxCompileUHLConfig.json]", "processing");

		var jsonStructure:JsonStruct = {
			programVersion: Main.version,
			limeConfig: {
				projectName: "project",
				sourceDir: "source",
				exportDir: "export",
				reportErrorStyle: "pretty",
				debugMode: false,
				hxDefines: [],
				othersOptions: [],
			},
			deleteTempFiles: true,
			extraLibs: [],
		};

		try {
			File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUHLConfig.json", Json.stringify(jsonStructure, "\t"));
			SlushiUtils.printMsg("Created [hxCompileUHLConfig.json]", "success");
		} catch (e) {
			SlushiUtils.printMsg("Error creating [hxCompileUHLConfig.json]: " + e, "error");
		}
	}
}
