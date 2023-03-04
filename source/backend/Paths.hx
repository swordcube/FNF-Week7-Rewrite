package backend;

import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.frames.FlxAtlasFrames;

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

    public static inline function image(path:String, ?library:Null<String>):FlxGraphicAsset {
        var gottenPath:String = getPath('images/$path.png', library);
        for(extension in imageExtensions) {
            var path:String = getPath('images/$path.$extension', library);
            if(exists(path)) {
                gottenPath = path;
                break;
            }
        }

        var cached:FlxGraphicAsset = (CacheManager.preloadedAssets.get(gottenPath) != null) ? CacheManager.preloadedAssets.get(gottenPath).value : null;
        if(cached != null) return cached;
        
        return gottenPath;
    }

    public static inline function getSparrowAtlas(path:String, ?library:Null<String>) {
        return FlxAtlasFrames.fromSparrow(image(path), xml('images/$path'));
    }

    public static inline function getPackerAtlas(path:String, ?library:Null<String>) {
        return FlxAtlasFrames.fromSpriteSheetPacker(image(path), txt('images/$path'));
    }

    public static inline function music(path:String, ?library:Null<String>):FlxSoundAsset {
        var path:String = getPath('music/$path.ogg', library);

        var cached:FlxSoundAsset = (CacheManager.preloadedAssets.get(path) != null) ? CacheManager.preloadedAssets.get(path).value : null;
        if(cached != null) return cached;

        return path;
    }

    public static inline function sound(path:String, ?library:Null<String>):FlxSoundAsset {
        var path:String = getPath('sounds/$path.ogg', library);

        var cached:FlxSoundAsset = (CacheManager.preloadedAssets.get(path) != null) ? CacheManager.preloadedAssets.get(path).value : null;
        if(cached != null) return cached;

        return path;
    }

    public static inline function txt(path:String, ?library:Null<String>) {
        var path:String = getPath('$path.txt', library);

        var cached:String = (CacheManager.preloadedAssets.get(path) != null) ? CacheManager.preloadedAssets.get(path).value : null;
        if(cached != null) return cached;
        
        return path;
    }

    public static inline function xml(path:String, ?library:Null<String>) {
        var path:String = getPath('$path.xml', library);

        var cached:String = (CacheManager.preloadedAssets.get(path) != null) ? CacheManager.preloadedAssets.get(path).value : null;
        if(cached != null) return cached;

        return path;
    }

    public static inline function json(path:String, ?library:Null<String>) {
        var path:String = getPath('$path.json', library);

        var cached:String = (CacheManager.preloadedAssets.get(path) != null) ? CacheManager.preloadedAssets.get(path).value : null;
        if(cached != null) return cached;

        return path;
    }
}