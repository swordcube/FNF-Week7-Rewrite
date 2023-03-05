package states;

import flixel.addons.ui.FlxUIState;
import backend.interfaces.IMusicHandler;

class MusicBeatState extends FlxUIState implements IMusicHandler {
    override function create() {
        Conductor.onBeatHit.add(beatHit);
        Conductor.onStepHit.add(stepHit);

        transIn = FlxTransitionableState.defaultTransIn;
        transOut = FlxTransitionableState.defaultTransOut;

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

    override function destroy() {
        Conductor.onBeatHit.remove(beatHit);
        Conductor.onStepHit.remove(stepHit);
        super.destroy();
    }
}