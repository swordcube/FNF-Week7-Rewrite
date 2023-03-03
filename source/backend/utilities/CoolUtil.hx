package backend.utilities;

import openfl.system.System;
import flixel.system.FlxSound;
import polymod.Polymod;

class CoolUtil {
    /**
		Splits `text` into an array of multiple strings.
		@param text    The string to split
		@author swordcube
	**/
	public inline static function listFromText(text:String):Array<String> {
		var daList:Array<String> = text.trim().split('\n');
		for (i in 0...daList.length) daList[i] = daList[i].trim();
		return daList;
	}

	/**
	 * Gets the platform the game was compiled to.
	 * @author swordcube
	 */
	public inline static function getPlatform():String {
		#if sys
		return Sys.systemName();
		#elseif android
		return "Android";
		#elseif html5
		return "HTML5";
		#elseif (hl || hashlink) // idfk which one is hashlink so let's check both!! lol!!
		return "Hashlink";
		#elseif neko
		return "Neko";
		#else
		return "Unknown";
		#end
	}

	public static function addZeros(str:String, num:Int) {
		while(str.length < num) str = '0${str}';
		return str;
	}

	/**
	 * Converts bytes into a human-readable format `(Examples: 1b, 256kb, 1024mb, 2048gb, 4096tb)`
	 * @param num The bytes to convert.
	 * @return String
	 */
	public static function getSizeLabel(size:Float):String {
		var labels = ["B", "KB", "MB", "GB", "TB"];
		var rSize:Float = size;
		var label:Int = 0;
		while(rSize > 1024 && label < labels.length-1) {
			label++;
			rSize /= 1024;
		}
		return '${Std.int(rSize) + "." + addZeros(Std.string(Std.int((rSize % 1) * 100)), 2)}${labels[label]}';
	}

	/**
	 * Trims everything in an array of strings and returns it.
	 * @param a The array to modify.
	 * @return Array<String>
	 */
	public inline static function trimArray(a:Array<String>):Array<String> {
		var f:Array<String> = [];
		for(i in a) f.push(i.trim());
		return f;
	}

	/**
	 * Opens a instance of your default browser and navigates to `url`.
	 * @param url The URL to open.
	 */
	public inline static function openURL(url:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [url, "&"]);
		#else
		FlxG.openURL(url);
		#end
	}

	/**
	 * Splits `string` using `delimeter` and then converts all items in the array into an `Int` and returns it.
	 * @param string The string to split.
	 * @param delimeter The character to use for splitting.
	 * @return Array<Int>
	 */
	public inline static function splitInt(string:String, delimeter:String):Array<Int> {
		string = string.trim();
		var splitReturn:Array<Int> = [];
		if(string.length > 0) {
			var splitString:Array<String> = string.split(delimeter);
			for (string in splitString) splitReturn.push(Std.parseInt(string.trim()));
		}
		return splitReturn;
	}

	/**
	 * Clears all images and sounds from the cache.
	 * @author swordcube
	 */
     public inline static function clearCache() {
		// Clear OpenFL & Lime Assets
		OpenFLAssets.cache.clear();
		LimeAssets.cache.clear();

        // Clear assets using Polymod
        Polymod.clearCache();

		// Clear all Flixel bitmaps
		FlxG.bitmap.dumpCache();
		FlxG.bitmap.clearCache();

		// Clear all Flixel sounds
		FlxG.sound.list.forEach((sound:FlxSound) -> {
			sound.stop();
			sound.kill();
			sound.destroy();
		});
		FlxG.sound.list.clear();
		FlxG.sound.destroy(false);

		// Run garbage collector just in case none of that worked
		System.gc();
	}

	public static function setFieldDefault<T>(v:Dynamic, name:String, defaultValue:T):T {
		if (Reflect.hasField(v, name)) {
			var f:Null<Dynamic> = Reflect.field(v, name);
			if (f != null)
				return cast f;
		}
		Reflect.setField(v, name, defaultValue);
		return defaultValue;
	}
}