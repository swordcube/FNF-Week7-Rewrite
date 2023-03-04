package states;

import flixel.FlxState;
import objects.fonts.Alphabet;

class TitleState extends FlxState {
	public var logo:FlxSprite;
	public var gfDance:FlxSprite;
	public var titleEnter:FlxSprite;

	override function create() {
		super.create();

		CoolUtil.playMusic(Paths.music("preload/freakyMenu"));

		add(logo = new FlxSprite(-150, -100));
		logo.frames = Paths.getSparrowAtlas("titlescreen/logoBumpin");
		logo.animation.addByPrefix("idle", "logo bumpin", 24, false);
		logo.animation.play("idle");

		add(gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07));
		gfDance.frames = Paths.getSparrowAtlas("titlescreen/gfDanceTitle");
		gfDance.animation.addByIndices("danceLeft", "gfDance", [for(i in 0...15) i], "", 24, false);
		gfDance.animation.addByIndices("danceRight", "gfDance", [for(i in 15...30) i], "", 24, false);
		gfDance.animation.play("danceLeft");

		add(titleEnter = new FlxSprite(100, FlxG.height * 0.8));
		titleEnter.frames = Paths.getSparrowAtlas("titlescreen/titleEnter");
		titleEnter.animation.addByPrefix("idle", "Press Enter to Begin", 24);
		titleEnter.animation.addByPrefix("press", "ENTER PRESSED", 24);
		titleEnter.animation.play("idle");

		add(new Alphabet(10, 10, Bold, "yo nice balls you got there\ncan i crush them"));
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		
		if(FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		else
			Conductor.songPosition += elapsed * 1000;
	}
}