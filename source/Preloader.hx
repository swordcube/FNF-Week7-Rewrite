package;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import haxe.io.Path;
import backend.utilities.CoolUtil;
import polymod.Polymod;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
#if (target.threaded)
import sys.thread.Thread;
#end
import flixel.ui.FlxBar;
import flixel.FlxState;

/**
 * The class that initializes the game and preloads assets.
 */
class Preloader extends FlxState {
    public var spinner:FlxSprite;
    public var logo:FlxSprite;
    public var progressBar:FlxBar;

    public var currentlyLoaded:Int = 0;
    public var totalToLoad:Int = 0;

    public var doneLoading:Bool = false;

    override function create() {
        super.create();

        Preloader.initGame();

        add(logo = new FlxSprite().loadGraphic(Paths.image("preloaderArt")));
        logo.scale.set(0.4, 0.4);
        logo.updateHitbox();
        logo.screenCenter();
        logo.y -= 50;
        
        var foldersToCheck:Array<String> = [
            // Images
            Paths.getPath("images/characters"),
            Paths.getPath("images/gameplay"),
            Paths.getPath("images/notes"),
            Paths.getPath("images/gui/preload"),
            Paths.getPath("images/titlescreen"),

            // Music
            Paths.getPath("music/preload"),
        ];

        var shitToLoad:Array<String> = OpenFLAssets.list().filter((path:String) -> {
            for(folder in foldersToCheck) {
                if(path.startsWith(folder))
                    return true;
            }
            return false;
        });
        totalToLoad = shitToLoad.length;

        add(progressBar = new FlxBar(0, logo.y + (logo.height + 30), LEFT_TO_RIGHT, Std.int(FlxG.width * 0.5), 10, this, "currentlyLoaded", 0, totalToLoad));
        progressBar.screenCenter(X);
        progressBar.createFilledBar(0xFF3F3F3F, 0xFFFFFFFF);

        add(spinner = new FlxSprite().loadGraphic(Paths.image("spinner")));
        spinner.setGraphicSize(45, 45);
        spinner.updateHitbox();
        spinner.setPosition(FlxG.width - (spinner.width + 20), FlxG.height - (spinner.height + 20));

        #if (target.threaded)
        trace("PRELOADING WITH A THREAD!");
        Thread.create(() -> preloadAssets(shitToLoad));
        #else
        trace("PRELOADING WITHOUT A THREAD!");
        preloadAssets(shitToLoad);
        #end
    }

    public static function initGame() {
        FlxG.fixedTimestep = false;
        Main.fpsCounter.visible = false;
        FlxSprite.defaultAntialiasing = true;

        FlxG.save.bind("preferences", CoolUtil.getSavePath());

        // Automatically set the volume to 0.3 to not blast your ears immediately
        // when initially creating save data
        // I'm nice like that :3
        if(FlxG.save.data.volume == null) {
            FlxG.save.data.volume = 0.3;
            FlxG.save.flush();
        }
        Conductor.init();

        Polymod.init({
            modRoot: "mods",
            dirs: ["introMod"],
            errorCallback: (error:PolymodError) -> {
                switch(error.severity) {
                    case ERROR:     Logs.trace(error.message, ERROR);
                    case WARNING:   Logs.trace(error.message, WARNING);
                    default: // nah
                }
            },
            framework: FLIXEL,
            customFilesystem: polymod.fs.ZipFileSystem
        });

        FlxG.signals.preStateCreate.add((state:FlxState) -> {
            CoolUtil.clearCache();
        });

        var diamond = FlxGraphic.fromClass(GraphicTransTileDiamond);
        diamond.persist = true;
        diamond.destroyOnNoUse = false;

        var transitionTileData:TransitionTileData = {asset: diamond, width: 32, height: 32};
        var transitionRect:FlxRect = FlxRect.get(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4);

        FlxTransitionableState.defaultTransIn = new TransitionData(FADE, 0xFF000000, 0.45, FlxPoint.get(0, -1), transitionTileData, transitionRect);
        FlxTransitionableState.defaultTransOut = new TransitionData(FADE, 0xFF000000, 0.45, FlxPoint.get(0, 1), transitionTileData, transitionRect);
    }

    public function preloadAssets(paths:Array<String>) {
        for(path in paths) {
            if(OpenFLAssets.exists(path, IMAGE)) {
                var graphic = FlxGraphic.fromBitmapData(OpenFLAssets.getBitmapData(path), false, path, false);
                graphic.persist = true;
                graphic.destroyOnNoUse = false;
                CacheManager.preloadAsset(path, graphic, updateCurrentlyLoaded);

                var xmlPath:String = path.substr(0, path.length - (Path.extension(path).length + 1)) + ".xml";
                if(OpenFLAssets.exists(xmlPath, TEXT))
                    CacheManager.preloadAsset(xmlPath, OpenFLAssets.getText(xmlPath));

                var txtPath:String = path.substr(0, path.length - (Path.extension(path).length + 1)) + ".txt";
                if(OpenFLAssets.exists(txtPath, TEXT))
                    CacheManager.preloadAsset(txtPath, OpenFLAssets.getText(txtPath));
            }
            else if(OpenFLAssets.exists(path, MUSIC))
                CacheManager.preloadAsset(path, OpenFLAssets.getMusic(path), updateCurrentlyLoaded);

            else if(OpenFLAssets.exists(path, SOUND))
                CacheManager.preloadAsset(path, OpenFLAssets.getSound(path), updateCurrentlyLoaded);

            else if(OpenFLAssets.exists(path, TEXT))
                CacheManager.preloadAsset(path, OpenFLAssets.getText(path), updateCurrentlyLoaded);

            else continue;
        }
        doneLoading = true;
    }

    public function updateCurrentlyLoaded() {
        currentlyLoaded++;
    }

    public function finish() {
        trace("FINISHED PRELOADING!");

        doneLoading = false;
        spinner.visible = false;

        FlxG.sound.play(Paths.sound("menus/confirmMenu"));
        FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> {
            Main.fpsCounter.visible = true;

            trace("SWITCHING TO INITIAL STATE!");
            FlxG.switchState(new states.TitleState());
        });
    }

    override function update(elapsed:Float) {
		super.update(elapsed);
        spinner.angle += elapsed * 125;

        if(doneLoading) finish();
	}
}