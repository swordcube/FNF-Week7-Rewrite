package objects.ui;

class TiledSustain extends FlxSprite {
    public var tileOffset:Float = -0.3;
    public var initialHeight:Float = 0;
    public var length:Int;

    public function new(?x:Float = 0, ?y:Float = 0, ?length:Int = 3) {
        super(x, y);
        this.length = length;    
    }

    override function updateHitbox() {
        super.updateHitbox();
        initialHeight = height;
        height *= length;
    }

    override function draw() {
        if(length < 1) return;
        
        var sinMult:Float = Math.sin((angle % 360) * Math.PI / -180);
        var cosMult:Float = Math.cos((angle % 360) * Math.PI / 180);

        var __x:Float = x;
        var __y:Float = y;
        for(i in 0...length) {
            if(i >= length - 1)
                animation.play("tail");
            else
                animation.play("hold");

            x = __x + ((initialHeight + (tileOffset * scale.y)) * i * sinMult);
            y = __y + ((initialHeight + (tileOffset * scale.y)) * i * cosMult);
            super.draw();
        }
        x = __x;
        y = __y;
    }
}