package;

import org.flixel.FlxSprite;
import org.flixel.FlxGroup;

class BulletManager extends FlxGroup
{

    public var bullet:Dynamic;

    public function new(poolSize:Int = 40, bType:Dynamic)
    {
        bullet = bType;
        super();
        var i = 0;
        while(i < poolSize) {
            var bullet = getBullet();
            add(bullet);
            i++;
        }
    }

    private function getBullet():Weapon {
        return bullet.init();
    }

    public function fire(bx:Float, by:Float, angle:Float):Void
    {
        if(getFirstAvailable() != null)
        {
            var bullet = cast(getFirstAvailable(), Weapon);
            bullet.fire(bx, by, angle);
        }
    }
}