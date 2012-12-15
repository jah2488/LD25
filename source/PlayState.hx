package ;

import org.flixel.plugin.photonstorm.FlxButtonPlus;
import org.flixel.FlxEmitter;
import org.flixel.FlxObject;
import org.flixel.FlxU;
import nme.Lib;
import nme.Assets;
import org.flixel.plugin.photonstorm.FlxMath;
import org.flixel.plugin.photonstorm.FlxVelocity;
import org.flixel.FlxText;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxG;

class PlayState extends FlxState {

    var controls:FlxButtonPlus;
    var selected:FlxButtonPlus;

    var world:FlxSprite;

    override public function create():Void {
        controls = new FlxButtonPlus(20, 20, onDefenseClicked, null, "select defense", 60, 30);
        controls.text = "Defense";
        selected = controls;
        add(controls);


        world = new FlxSprite();
        world.loadRotatedGraphic("assets/data/base.png");
        world.y = FlxG.height - world.height / 2;
        world.x = FlxG.width / 2;
        add(world);
    }

    private function onDefenseClicked():Void {
        FlxG.play("Beep");
        var colors = new Array();
        colors.push(0xFFFF00FF);
        colors.push(0xFFFF99FF);
        controls.updateInactiveButtonColors(colors);
    }

    override public function update():Void {
        super.update();
    }
}




