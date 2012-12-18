package ;

import org.flixel.plugin.photonstorm.FlxVelocity;
import org.flixel.FlxPoint;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Laser extends Weapon {

    public function new()
    {
        super();
        loadGraphic("assets/data/beam-green.png", false, false, 200, 5);
        width = width * 0.8;
        exists = false;
        origin.x = 0;
        origin.y = 0;
        speed = 900;
    }

    public static function init():Laser {
        return new Laser();
    }

    override public function fire(bx:Float, by:Float, angle:Float):Void
    {
        x = bx;
        y = by;
        exists = true;

        var targetPoint = new FlxPoint(FlxG.width/2, FlxG.height * .75);
        FlxVelocity.accelerateTowardsPoint(this, targetPoint, speed, speed, 1);
        FlxG.play("Laser", 0.2);
    }

    override public function update():Void
    {
        super.update();

        if (exists && y < -FlxG.height) { exists = false; }
        if (exists && y >  FlxG.height) { exists = false; }
        if (exists && x < -FlxG.width) { exists = false; }
        if (exists && x >  FlxG.width) { exists = false; }
    }
}
