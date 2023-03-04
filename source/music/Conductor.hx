package music;

import music.Song.SwagSong;

typedef BPMChangeEvent = {
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor {
	/**
	 * The current BPM of the song.
	 */
	public static var bpm:Float = 100;

	/**
	 * The time between beats in milliseconds.
	 */
	public static var crochet:Float = ((60 / bpm) * 1000);

	/**
	 * The time between steps in milliseconds.
	 */
	public static var stepCrochet:Float = crochet / 4;

	/**
	 * The position of the song in milliseconds.
	 */
	public static var songPosition:Float = 0;

    public static var curBeat:Int = 0;

    public static var curStep:Int = 0;

    public static var curSection:Int = 0;

	/**
	 * The timing window you get to hit notes.
	 */
	public static var safeFrames:Int = 10;

	/**
	 * `safeFrames` in milliseconds.
	 */
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

	/**
	 * An `Array` of `BPMChangeEvent`s that happen mid song.
	 */
	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	/**
	 * Maps BPM changes based on song data.
	 * @param song The song data to get BPM changes from.
	 */
	public static function mapBPMChanges(song:SwagSong) {
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length) {
			if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM) {
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
	}

	/**
	 * Changes the BPM of the song.
	 * @param newBpm The BPM to change to.
	 */
	public static function changeBPM(newBpm:Float) {
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}
