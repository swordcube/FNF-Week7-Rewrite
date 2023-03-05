package objects.ui;

import states.PlayState;
import flixel.group.FlxGroup.FlxTypedGroup;

class NoteField extends FlxTypedGroup<Note> {
    public var game:PlayState = PlayState.current;

    override function update(elapsed:Float) {
        super.update(elapsed);
        forEachAlive((note:Note) -> {
            note.x = note.strumLine.members[note.noteData].x;
            note.y = (note.strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * game.scrollSpeed));

            if(note.mustPress) {
                if(note.y < -note.height)
                    deleteNote(note);
            } else {
                if(note.strumTime <= Conductor.songPosition)
                    deleteNote(note);
            }
        });
    }

    public function deleteNote(note:Note) {
        note.kill();
        note.destroy();
        remove(note, true);
    }
}