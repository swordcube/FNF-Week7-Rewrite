package backend;

class Paths {
    public static final imageExtensions:Array<String> = [
        "png",
        "jpg",
        "jpeg",
        "bmp"
    ];
    public static inline final preloadLibrary:String = "nopreload";

    public static inline function exists(path:String) {
        return OpenFLAssets.exists(path);
    }

	public static inline function getPath(path:String, ?library:Null<String>) {
        if(library != null && library.length > 0) library += ":";
        else library = "";
        
        return '${library}assets/$path';
    }

    public static inline function image(path:String, ?library:Null<String>) {
        var gottenPath:String = getPath('images/$path.png', library);
        for(extension in imageExtensions) {
            var path:String = getPath('images/$path.$extension', library);
            if(exists(path)) {
                gottenPath = path;
                break;
            }
        }
        return gottenPath;
    }

    public static inline function music(path:String, ?library:Null<String>) {
        return getPath('music/$path.ogg', library);
    }

    public static inline function sound(path:String, ?library:Null<String>) {
        return getPath('sounds/$path.ogg', library);
    }
}