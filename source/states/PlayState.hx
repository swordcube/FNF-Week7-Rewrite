package states;

import objects.ui.Note;
import music.Song;
import objects.ui.TiledSustain;
import flixel.FlxState;

class PlayState extends FlxState {
	public static var SONG:SwagSong;

	public var strumLine:FlxSprite;
	public var unspawnNotes:Array<Note>;

	override function create() {
		super.create();

		FlxG.sound.music.stop();

		if(SONG == null)
			SONG = Song.loadFromJson("test");

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		Conductor.songPosition = Conductor.crochet * -2;

		unspawnNotes = ChartParser.parseNotes(SONG);

		add(strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10));
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		Conductor.songPosition += elapsed * 1000;
	}
}