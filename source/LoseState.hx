
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.FlxSpecialFX;
import org.flixel.plugin.photonstorm.FlxDisplay;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxState;

class LoseState extends FlxState {
    var startButton:FlxButton;
    var logo:FlxSprite;

    override public function create():Void
    {
#if !neko
            FlxG.bgColor = 0xff131c1b;
#else
    FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
#end
        FlxG.mouse.show();

        if (FlxG.getPlugin(FlxSpecialFX) == null)
        {
            FlxG.addPlugin(new FlxSpecialFX());
        }
        var starfield = FlxSpecialFX.starfield();
        var stars = starfield.create(0, 0, FlxG.width,FlxG.height, 300);
        starfield.setStarSpeed ( 0, 1 );
        add(stars);

        startButton = new FlxButton(0, 0, "You Lose!", onStartClick);
        startButton.makeGraphic(100, 20, 0x00FFFFFF);
        startButton.label.width = 200;
        startButton.label.setSize(24);
        startButton.label.setColor(0xFFFFFFFF);
//center align the button on the stage
        FlxDisplay.screenCenter(startButton,true,true);

        logo = new FlxSprite();
        logo.loadGraphic("assets/data/riseOfAgents.png");
        logo.y = 1000;
        logo.velocity.y = -250;
        add(logo);
        FlxDisplay.screenCenter(logo,true,false);

        FlxG.playMusic("menuMusic");
        add(startButton);
    }


    private function showStart():Void {
    }

    private function onStartClick():Void
    {
        FlxG.fade(0xFFFFFFFF, 0.5, false, onFadeComplete);
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
        if(logo.y < 0) {
            logo.y = 1;
            logo.velocity.y = 0;
            FlxG.shake(0.025);
            FlxG.flash(0xFFFFFFFF,0.75, showStart);
            logo.flicker(0.75);
        }
    }
}
