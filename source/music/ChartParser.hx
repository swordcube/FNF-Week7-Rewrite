package music;

import objects.ui.Note;
import music.Song.SwagSong;

class ChartParser {
    public static inline function parseNotes(SONG:SwagSong) {
        var unspawnNotes:Array<Note> = [];

        for(section in SONG.notes) {
            for(note in section.sectionNotes) {
                var swagNote = new Note(-9999, -9999, note[0], Std.int(note[1]) % 4, Math.floor(note[2] / Conductor.stepCrochet) + 1);
                unspawnNotes.push(swagNote);
            }
        }
        return unspawnNotes;
    }
}