package music;

import music.Song.SwagSong;
import flixel.system.FlxSound;
import flixel.util.FlxSignal.FlxTypedSignal;

@:dox(hide)
typedef BPMChangeEvent = {
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor {
	/**
	 * A signal that runs when a beat is hit.
	 */
	public static var onBeatHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal();

	/**
	 * A signal that runs when a step is hit.
	 */
	public static var onStepHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal();

	/**
	 * A signal that runs when a BPM change happens.
	 */
	public static var onBPMChange:FlxTypedSignal<Float->Void> = new FlxTypedSignal();

	/**
	 * Current BPM.
	 */
	public static var bpm:Float = 0;

	/**
	 * Current speed of the song.
	 */
	public static var rate:Float = 1;

	/**
	 * Current Crochet (time per beat), in milliseconds.
	 */
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds

	/**
	 * Current StepCrochet (time per step), in milliseconds.
	 */
	public static var stepCrochet:Float = (crochet / 4); // steps in milliseconds

	/**
	 * Current position of the song, in milliseconds.
	 */
	public static var songPosition:Float = 0;

	/**
	 * Current step
	 */
	public static var curStep:Int = 0;

	/**
	 * Current beat
	 */
	public static var curBeat:Int = 0;

	/**
	 * Current step, as a `Float` (ex: 4.94, instead of 4)
	 */
	public static var preciseStep:Float = 0;

	/**
	 * Current beat, as a `Float` (ex: 1.24, instead of 1)
	 */
	public static var preciseBeat:Float = 0;

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public static var stepsPerSection:Int = 16;

	public static function init() {
		FlxG.signals.preUpdate.add(update);
		reset();
	}

	public static function reset() {
		songPosition = preciseBeat = preciseStep = curBeat = curStep = 0;
		bpmChangeMap = [];
		changeBPM(0);
	}

	public static function update() {
		if (bpm <= 0)
			return;

		// Handle BPM changes
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		};
		for (change in Conductor.bpmChangeMap) {
			if (Conductor.songPosition >= change.songTime)
				lastChange = change;
		}

		if (lastChange.bpm > 0 && bpm != lastChange.bpm)
			changeBPM(lastChange.bpm);

		// Handles beats, steps
		preciseStep = lastChange.stepTime + ((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
		preciseBeat = preciseStep / 4;

		if (Std.int(preciseStep) > 0 && curStep != (curStep = Std.int(preciseStep))) {
			var updateBeat:Bool = curBeat != (curBeat = Std.int(preciseBeat));

			onStepHit.dispatch(curStep);
			if (updateBeat)
				onBeatHit.dispatch(curBeat);
		}
	}

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

		recalculateStuff();
	}

	public static function changeBPM(newBpm:Float) {
		bpm = newBpm;
		recalculateStuff();
		onBPMChange.dispatch(bpm);
	}

	public static function recalculateStuff() {
		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}