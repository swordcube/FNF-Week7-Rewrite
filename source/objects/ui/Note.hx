package objects.ui;

import flixel.util.FlxColor;

class Note extends FlxSprite {
    public static var swagWidth:Float = 160 * 0.7;

    public var strumTime:Float = 0;
    public var noteData:Int = 0;

    public var sustain:TiledSustain;

    public function new(?x:Float = 0, ?y:Float = 0, ?strumTime:Float = 0, ?noteData:Int = 0, ?sustainLength:Int = 0) {
        super(x, y);
        makeGraphic(Std.int(swagWidth * 0.9), Std.int(swagWidth * 0.9), FlxColor.RED);
        sustain = new TiledSustain(x, y, sustainLength);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}