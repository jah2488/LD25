package;

import org.flixel.plugin.photonstorm.FlxGradient;
import org.flixel.FlxGroup;
import org.flixel.FlxParticle;
import org.flixel.FlxEmitter;
import org.flixel.plugin.photonstorm.FlxMouseControl;
import org.flixel.plugin.photonstorm.FlxDisplay;
import org.flixel.FlxTileblock;
import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

class MenuState extends FlxState
{
    var startButton:FlxButton;

	override public function create():Void
	{
		#if !neko
            FlxG.bgColor = 0xff131c1b;
		#else
            FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();

        //create a button with the label Start and set an on click function
        startButton = new FlxButton(0, 0, "Start", onStartClick);
        //add the button to the state draw list
        add(startButton);
        //center align the button on the stage
        FlxDisplay.screenCenter(startButton,true,true);
    }

    private function onStartClick():Void
    {
        FlxG.switchState(new PlayState());
//        FlxG.fade(0xFFFFFFFF, 1, false, onFadeComplete);
    }

    private function onFadeComplete():Void {
        FlxG.switchState(new PlayState());
    }

    override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}
}