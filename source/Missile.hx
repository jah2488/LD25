package ;

import org.flixel.FlxPoint;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Missile extends FlxSprite {

    public var damage:Int = 1;
    public var speed :Int = 100;

    public function new()
    {
        super();
        loadRotatedGraphic("assets/data/missle.png");
        scale.x = scale.y = 0.4;
        width = width * 0.6;
        height = height * 0.5;
        exists = false;
    }

    public function fire(bx:Float, by:Float, angle:Float):Void
    {
        x = bx;
        y = by;
        var radiansFromAngle = (angle * (Math.PI / 180));
        velocity.x = Math.cos(radiansFromAngle) * speed;
        velocity.y = Math.sin(radiansFromAngle) * speed;
        exists = true;
        FlxG.play("Shoot");
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
