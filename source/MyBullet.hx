package;

import org.flixel.FlxG;
import org.flixel.FlxSprite;

class MyBullet extends FlxSprite
{
    public var damage:Int = 1;
    public var speed :Int = 300;

    public function new()
    {
        super();

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