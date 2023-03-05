package objects.ui;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class StrumLine extends FlxTypedSpriteGroup<Receptor> {
    public function new(?x:Float = 0, ?y:Float = 0) {
        super(x, y);
        generateReceptors();
    }

    public function generateReceptors() {
        forEach((receptor:Receptor) -> {
            receptor.kill();
            receptor.destroy();
        });
        clear();

        for(i in 0...4) {
            var receptor = new Receptor(Note.swagWidth * i, 0, i);
            receptor.alpha = 0;
            FlxTween.tween(receptor, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
            add(receptor);
        }
    }
}