package objects.ui;

import flixel.util.FlxColor;

class Receptor extends FlxSprite {
    public var noteData:Int = 0;

    public function new(?x:Float = 0, ?y:Float = 0, ?noteData:Int = 0) {
        super(x, y);
        this.noteData = noteData;
        
        makeGraphic(Std.int(Note.swagWidth * 0.9), Std.int(Note.swagWidth * 0.9), FlxColor.BLUE);
        scale.set(0.7, 0.7);
        updateHitbox();
    }
}