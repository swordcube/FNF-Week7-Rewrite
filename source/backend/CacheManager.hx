package backend;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

class CacheManager {
    public static var preloadedAssets:Map<String, CacheAsset> = [];

    public static inline function preloadAsset(path:String, asset:Dynamic, ?callback:Void->Void) {
        preloadedAssets.set(path, new CacheAsset(asset));
        if(callback != null) callback();
    }
}

class CacheAsset implements IFlxDestroyable {
    public var value:Dynamic;

    public function new(value:Dynamic) {
        this.value = value;
    }

	public function destroy() {
        if(value is BitmapData) {
            var bitmap:BitmapData = cast value;
            bitmap.disposeImage();
            bitmap.dispose();
        } else if(value is FlxGraphic) {
            var graphic:FlxGraphic = cast value;
            graphic.persist = false;
            graphic.destroyOnNoUse = true;
            graphic.dump();
            graphic.destroy();
        }
    }
}