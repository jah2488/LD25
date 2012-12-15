package ;

import org.flixel.plugin.photonstorm.FlxMath;
import org.flixel.FlxSprite;
import org.flixel.FlxG;

class Player extends LdEntity {

    var speed:Int    = 8;
    var inertia:Float  = 0.04;
    var slowdown:Float = 0.09;

    public function new() {
        super();
        loadRotatedGraphic("assets/data/base.png");
        immovable = true;
    }

    override public function update():Void {
        super.update();
        angle = mouseAngle();

        if(FlxG.keys.pressed("W")) { y -= (speed + velocity.y); velocity.y += inertia; }
        if(FlxG.keys.pressed("A")) { x -= (speed + velocity.x); velocity.x += inertia; }
        if(FlxG.keys.pressed("S")) { y += (speed + velocity.y); velocity.y += inertia; }
        if(FlxG.keys.pressed("D")) { x += (speed + velocity.x); velocity.x += inertia; }


        if(x >= FlxG.width - width)   { x = FlxG.width  - (width * 2); }
        if(x <= 0 + width)            { x = width + 2; }
        if(y >= FlxG.height - height) { y = FlxG.height - (height * 2); }
        if(y <= 0 + height)           { y = height + 2; }

        velocity.x -= slowdown;
        velocity.y -= slowdown;

        if(velocity.x < 0) { velocity.x = 0; }
        if(velocity.y < 0) { velocity.y = 0; }

    }

    private function mouseAngle():Float
    {
        var radians = FlxMath.atan2(FlxG.mouse.x - x, FlxG.mouse.y - y);
        var degrees = (radians * (180 / Math.PI) * -1) + 90;
        return degrees;
    }

    override public function destroy():Void {
        super.destroy();
    }
}
