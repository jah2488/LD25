package;

import org.flixel.FlxGroup;

class BulletManager extends FlxGroup
{
    public function new(poolSize:Int = 40)
    {
        super();
        var i = 0;
        while(i < poolSize) {
            var bullet = new MyBullet();
            add(bullet);
            i++;
        }
    }

    public function fire(bx:Float, by:Float, angle:Float):Void
    {
        if(getFirstAvailable() != null)
        {
            var bullet = cast(getFirstAvailable(), MyBullet);
            bullet.fire(bx, by, angle);
        }
    }
}