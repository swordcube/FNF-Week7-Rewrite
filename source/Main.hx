package;

import openfl.display.FPS;
import lime.app.Application;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public static var funkinVersion(get, never):String;
	private static function get_funkinVersion():String {
		return Application.current.meta.get("version");
	}

	public static var engineVersion:String = "0.1.0";
	public static var engineNightlyTag:String = "alpha";

	public static var fpsCounter:FPS;

	public static inline function framerateAdjust(input:Float) {
		return FlxG.elapsed * 60 * input;
	}
	
	public function new() {
		super();
		fpsCounter = new FPS(10, 3, 0xFFFFFFFF);
		addChild(new FlxGame(1280, 720, Preloader, 240, 240, true));
		addChild(fpsCounter);
	}
}
