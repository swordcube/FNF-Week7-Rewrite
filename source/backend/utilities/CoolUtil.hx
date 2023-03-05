package backend.utilities;

import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.input.keyboard.FlxKey;
import flixel.animation.FlxAnimation;
import flixel.util.FlxSave;
import haxe.io.Path;
import openfl.system.System;
import flixel.system.FlxSound;
import polymod.Polymod;
import backend.utilities.IniParser;

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

    /**
     * Plays music from a path. If an INI file with the same name as the music exists in the same location as the music;
     * 
     * It loads it and sets the BPM from the Sound section.
     * 
     * @param path The path to the music.
     * @param volume The initial volume of the music.
     * @param looped Whether or not the music loops.
     * @param fadeInVolume (Optional) The volume the music should fade in to. If not specified, the volume will remain at it's initial value.
     * @param fadeInDuration (Optional) How long the music should fade in for. Defaults to 1 second if not specified.;
     */
	 public inline static function playMusic(path:FlxSoundAsset, ?volume:Float = 1.0, ?looped:Bool = true, ?iniData:Ini, ?fadeInVolume:Null<Float>, ?fadeInDuration:Float = 1.0) {
		if(path is String && !Paths.exists(path)) return;

        FlxG.sound.playMusic(path, volume, looped);
        if(fadeInVolume != null)
            FlxG.sound.music.fadeIn(fadeInDuration, volume, fadeInVolume);

		if(iniData == null) return;

		// If the "Sound" section doesn't exist, Stop the function right here
		if(!iniData.exists("Sound")) return;

		var section:IniSection = iniData["Sound"];

		// Set the Conductor's BPM if the "BPM" property exists
		if(section.exists("BPM"))
			Conductor.changeBPM(Std.parseFloat(section["BPM"]));
    }

	/**
	 * Quick function to fix save files for Flixel 5
	 * if you are making a source code mod, you are gonna wanna change "swordcube" to something else
	 * so base Funkin saves won't conflict with yours
	 */
	public static function getSavePath(folder:String = "swordcube"):String {
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get("company")
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get("file")) #end;
	}

    public inline static function switchAnimFrames(anim1:FlxAnimation, anim2:FlxAnimation) {
		if (anim1 == null || anim2 == null) return;
		var old = anim1.frames;
		anim1.frames = anim2.frames;
		anim2.frames = old;
	}

	/**
		Makes the first letter of each word in `s` uppercase.
		@param s       The string to modify
		@author swordcube
	**/
	public inline static function firstLetterUppercase(s:String):String {
		var strArray:Array<String> = s.split(' ');
		var newArray:Array<String> = [];
		
		for (str in strArray)
			newArray.push(str.charAt(0).toUpperCase()+str.substring(1));
	
		return newArray.join(' ');
	}

    /**
	 * Converts an `FlxKey` to a string representation.
	 * @param key The key to convert.
	 */
	public inline static function keyToString(key:Null<FlxKey>):String {
		return switch(key) {
			case null | 0 | NONE:	"---";
			case LEFT: 				"←";
			case DOWN: 				"↓";
			case UP: 				"↑";
			case RIGHT:				"→";
			case ESCAPE:			"ESC";
			case BACKSPACE:			"[←]";
			case NUMPADZERO:		"#0";
			case NUMPADONE:			"#1";
			case NUMPADTWO:			"#2";
			case NUMPADTHREE:		"#3";
			case NUMPADFOUR:		"#4";
			case NUMPADFIVE:		"#5";
			case NUMPADSIX:			"#6";
			case NUMPADSEVEN:		"#7";
			case NUMPADEIGHT:		"#8";
			case NUMPADNINE:		"#9";
			case NUMPADPLUS:		"#+";
			case NUMPADMINUS:		"#-";
			case NUMPADPERIOD:		"#.";
			case NUMPADMULTIPLY:	"#*";
			case GRAVEACCENT:		"`";
			case LBRACKET:			"[";
			case RBRACKET:			"]";
			case PRINTSCREEN:		"PrtScrn";
			case QUOTE:				"'";
			case ZERO:				"0";
			case ONE:				"1";
			case TWO:				"2";
			case THREE:				"3";
			case FOUR:				"4";
			case FIVE:				"5";
			case SIX:				"6";
			case SEVEN:				"7";
			case EIGHT:				"8";
			case NINE:				"9";
			case COMMA:				",";
			case PERIOD:			".";
			case SEMICOLON:         ";";
			case BACKSLASH:			"\\";
			case SLASH:				"/";
			case PAGEUP:			"PgUp";
			case PAGEDOWN:			"PgDown";
			case PLUS:				"+";
			case MINUS:				"-";
			default:				key.toString();
		}
	}

    /**
     * Gets the name of a class from an instance of said class.
     * @param instance The class instance to get the name of.
     */
    public inline static function getClassName<T>(instance:T):String {
        return Type.getClassName(Type.getClass(instance));
    }

    /**
     * Gets the last item of an array and returns it.
     * @param array The array to get the item from.
     */
     public inline static function last<T>(array:Array<T>):T {
        return array[array.length - 1];
    }

    /**
     * Removes extensions like `.png`, `.jpeg`, `.ogg`, etc from this string.
     * @param string The string to make extension-less.
     */
    public inline static function removeExtension(string:String):String {
        return string.substr(0, string.length - (Path.extension(string).length+1));
    }

    /**
     * Gets the most dominant color from the graphic of an `FlxSprite`.
     * @param sprite The sprite to get the dominant color of.
     */
    public static function dominantColor(sprite:flixel.FlxSprite):Int {
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}
}