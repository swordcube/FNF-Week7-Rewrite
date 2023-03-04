package music;

import haxe.Json;

typedef SwagSong = {
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var validScore:Bool;
}

typedef SwagSection = {
	var sectionNotes:Array<Array<Dynamic>>;
	var lengthInSteps:Int;
	var mustHitSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}

class Song {
	public static inline function loadFromJson(song:String, ?difficulty:String = "normal"):SwagSong {
		return parseJSONshit(OpenFLAssets.getText(Paths.songJson(song, difficulty)));
	}

	public static inline function parseJSONshit(json:String):SwagSong {
		return Json.parse(json).song;
	}
}