package src.compilers;

import src.SlushiUtils;
import src.compilers.CafeCompiler;
import src.compilers.LimeCompiler;
import src.utils.Libs;

class MainCompiler {
	public static function start(arg2:String):Void {
		if (SlushiUtils.parseVersion(Main.version) < SlushiUtils.parseVersion(JsonFile.getJson().programVersion)
			|| SlushiUtils.parseVersion(Main.version) > SlushiUtils.parseVersion(JsonFile.getJson().programVersion)) {
			SlushiUtils.printMsg("The current version of HxCompileU (HashLink version) is not the same as the one in the JSON file, this may cause problems, consider checking that file.\n",
				"warning");
		}

		// check libs
		if (Libs.check() == FinalCheck.ERROR) {
			SlushiUtils.printMsg("Invalid libs, but continuing...", "error");
		}
		else if (Libs.check() == FinalCheck.SKIP) {
			SlushiUtils.printMsg("No extra libs found, but continuing...", "info");
		}

		SlushiUtils.printMsg("Starting...", "info");

		if (arg2 == "--onlyHaxe") {
			LimeCompiler.init();
			return;
		}

		// First compile Haxe part, then Wii U part
		LimeCompiler.init();
		Sys.sleep(2);
		CafeCompiler.init();
	}
}
