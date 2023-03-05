package states;

import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import objects.ui.StrumLine;
import objects.ui.NoteField;
import objects.ui.Note;
import music.Song;
import flixel.FlxState;

class PlayState extends MusicBeatState {
	public static var SONG:SwagSong;
	public static var current:PlayState;

	public var strumLine:FlxSprite;
	public var cpuStrums:StrumLine;
	public var playerStrums:StrumLine;

	public var unspawnNotes:Array<Note>;
	public var notes:NoteField;

	public var scrollSpeed:Float = 3;

	override function create() {
		super.create();
		current = this;

		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if(SONG == null)
			SONG = Song.loadFromJson("fresh", "hard");

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		Conductor.songPosition = Conductor.crochet * -2;

		add(strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10));
		add(cpuStrums = new StrumLine(0, strumLine.y));
		add(playerStrums = new StrumLine(0, strumLine.y));

		for(strumLine in [cpuStrums, playerStrums])
			strumLine.screenCenter(X);

		var strumSpacing:Float = FlxG.width / 4;
		cpuStrums.x -= strumSpacing;
		playerStrums.x += strumSpacing;

		unspawnNotes = ChartParser.parseNotes(SONG);
		add(notes = new NoteField());

		var noteAsset = Paths.getSparrowAtlas("gameplay/notes/default/assets");

        var frame:FlxFrame = noteAsset.framesHash.get("right hold piece0000");
        var graphic:FlxGraphic = FlxGraphic.fromFrame(frame);
        var noteScale:Float = 0.7;

        var sustain = new FlxTiledSprite(graphic, graphic.width, 300);
        sustain.scale.set(noteScale, noteScale);
        sustain.updateHitbox();
        sustain.antialiasing = true;
        add(sustain);
	}
 
	override function update(elapsed:Float) {
		super.update(elapsed);
		Conductor.songPosition += elapsed * 1000;

		if(unspawnNotes[0] != null) {
			while(unspawnNotes[0] != null && unspawnNotes[0].strumTime <= Conductor.songPosition + (2500 / scrollSpeed))
				notes.add(unspawnNotes.shift());
		}
	}

	override function destroy() {
		current = null;
		super.destroy();
	}
}