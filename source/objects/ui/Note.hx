package objects.ui;

import flixel.util.FlxColor;

class Note extends FlxSprite {
    public static var swagWidth:Float = 160 * 0.7;

    public var strumTime:Float = 0;
    public var noteData:Int = 0;
    public var mustPress:Bool = false;
    public var strumLine:StrumLine;

    public function new(?x:Float = 0, ?y:Float = 0, ?strumTime:Float = 0, ?noteData:Int = 0, ?sustainLength:Int = 0, ?mustPress:Bool = false, ?strumLine:StrumLine) {
        super(x, y);
        this.strumTime = strumTime;
        this.noteData = noteData;
        this.mustPress = mustPress;
        this.strumLine = strumLine;
        
        makeGraphic(Std.int(swagWidth * 0.9), Std.int(swagWidth * 0.9), FlxColor.RED);
        scale.set(0.7, 0.7);
        updateHitbox();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    override function draw() {
        super.draw();
    }
}