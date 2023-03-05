package music;

import states.PlayState;
import objects.ui.Note;
import music.Song.SwagSong;

class ChartParser {
    public static inline function parseNotes(SONG:SwagSong) {
        var game:PlayState = PlayState.current;
        var unspawnNotes:Array<Note> = [];

        for(section in SONG.notes) {
            for(note in section.sectionNotes) {
				var gottaHitNote:Bool = section.mustHitSection;
				if (Std.int(note[1]) > 3)
					gottaHitNote = !section.mustHitSection;

                var swagNote = new Note(0, -9999, note[0], Std.int(note[1]) % 4, Math.floor(note[2] / Conductor.stepCrochet));
                swagNote.mustPress = gottaHitNote;
                swagNote.strumLine = (gottaHitNote) ? game.playerStrums : game.cpuStrums;
                unspawnNotes.push(swagNote);
            }
        }
        return unspawnNotes;
    }
}