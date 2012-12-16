package ;

import nme.events.Event;
import org.flixel.FlxCamera;
import org.flixel.plugin.photonstorm.FlxButtonPlus;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxButton;

class BuildSpot extends FlxButton {

    static public inline var NORMAL:Int = 0;
    static public inline var HIGHLIGHT:Int = 1;
    static public inline var PRESSED:Int = 2;

    public var pauseProof:Bool;

    var _onClick:Dynamic;

    private var onClickParams:Array<Dynamic>;

    private var enterCallback:Dynamic;

    private var enterCallbackParams:Array<Dynamic>;

    private var leaveCallback:Dynamic;

    private var leaveCallbackParams:Array<Dynamic>;

    private var prevStatus:Int;


    public var builtOn = false;

    public function new(Graphic:String, Width:Int = 45, Height:Int = 45, X:Int = 100, Y:Int = 100) {
        super();
        this.x = X;
        this.y = Y;
        this.width  = Width;
        this.height = Height;
        this.loadGraphic("assets/data/" + Graphic, true, false, Width, Height);
    }

    override public function update():Void {
        super.update();
        updateBuildSpot();
    }

    private function updateBuildSpot():Void {
        if (status != prevStatus)
        {
            if (status == NORMAL)
            {
                if (leaveCallback != null)
                {
                    Reflect.callMethod(null, leaveCallback, leaveCallbackParams);
                }
            }
            else if (status == HIGHLIGHT)
            {
                if (enterCallback != null)
                {
                    Reflect.callMethod(null, enterCallback, enterCallbackParams);
                }
            }
        }
        prevStatus = status;
    }

    override private function onMouseUp(event:Event):Void
    {
        if (exists && visible && active && (status == PRESSED) && (_onClick != null) && (pauseProof || !FlxG.paused))
        {
            Reflect.callMethod(this, Reflect.getProperty(this, "_onClick"), onClickParams);
        }
    }

    public function setMouseOverCallback(callbackFunc:Dynamic, params:Array<Dynamic> = null):Void
    {
        enterCallback = callbackFunc;
        enterCallbackParams = params;
    }

    public function setMouseOutCallback(callbackFunc:Dynamic, params:Array<Dynamic> = null):Void
    {
        leaveCallback = callbackFunc;
        leaveCallbackParams = params;
    }

    public function setOnClickCallback(callbackFunc:Dynamic, params:Array<Dynamic> = null):Void
    {
        _onClick = callbackFunc;

        if (params != null)
        {
            onClickParams = params;
        }
    }
    
    override public function destroy():Void {
        super.destroy();
    }
}
