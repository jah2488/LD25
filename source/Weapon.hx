package;

import org.flixel.plugin.photonstorm.FlxVelocity;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxG;

class Weapon extends FlxSprite {

    public var damage:Int = 1;
    public var speed:Int = 100;

    public function init():Weapon {
        return new Weapon();
    }

    public function fire(bx:Float, by:Float, angle:Float):Void
    {
        x = bx;
        y = by;
//        var radiansFromAngle = (angle * (Math.PI / 180));
//        velocity.x = Math.cos(radiansFromAngle) * speed;
//        velocity.y = Math.sin(radiansFromAngle) * speed;
        exists = true;

        var targetPoint = new FlxPoint(FlxG.width/2, FlxG.height * .75);
        FlxVelocity.accelerateTowardsPoint(this, targetPoint, speed, speed, speed);
        this.angle = FlxVelocity.angleBetweenPoint(this, targetPoint, true);
        FlxG.play("Shoot");
    }

}