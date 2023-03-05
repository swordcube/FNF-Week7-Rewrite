package states;

import objects.fonts.Alphabet;

class TitleState extends MusicBeatState {
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
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		
		if(FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		else
			Conductor.songPosition += elapsed * 1000;

		if(FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new PlayState());
	}
}