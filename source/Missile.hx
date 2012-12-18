package ;

import org.flixel.plugin.photonstorm.FlxVelocity;
import org.flixel.FlxPoint;
import org.flixel.FlxG;
import org.flixel.FlxSprite;


class Missile extends Weapon {

    public function new()
    {
        super();
        loadRotatedGraphic("assets/data/missle.png");
        scale.x = 0.4;
        scale.y = 0.4;
        exists = false;
        width  = 60;
        height = 20;
        offset.x = 90;
        offset.y = 100;

        var s = new FlxSprite();
    }

    public static function init():Missile {
        return new Missile();
    }

    override public function fire(bx:Float, by:Float, angle:Float):Void
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

    override public function kill():Void {
        Registry.effects.explode(this.x, this.y);
        super.kill();
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
