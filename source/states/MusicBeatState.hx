package states;

import backend.interfaces.IMusicHandler;
import flixel.FlxState;

class MusicBeatState extends FlxState implements IMusicHandler {
    override function create() {
		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function beatHit(a:Int) {
        for(e in members) {
            if(e != null && e is IMusicHandler)
                cast(e, IMusicHandler).beatHit(a);
        }
    }

	public function stepHit(a:Int) {
        for(e in members) {
            if(e != null && e is IMusicHandler)
                cast(e, IMusicHandler).stepHit(a);
        }
    }

	public function sectionHit(a:Int) {
        for(e in members) {
            if(e != null && e is IMusicHandler)
                cast(e, IMusicHandler).sectionHit(a);
        }
    }
}