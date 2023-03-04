package backend.interfaces;

interface IMusicHandler {
    public function beatHit(a:Int):Void;
    public function stepHit(a:Int):Void;
    public function sectionHit(a:Int):Void;
}