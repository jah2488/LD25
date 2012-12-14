package ;

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

    var player:FlxSprite;
    var speed:Int    = 8;
    var inertia:Float  = 0.04;
    var slowdown:Float = 0.09;

    var gun:BulletManager;

    var blocks:FlxGroup;

    override public function create():Void {
        player = new FlxSprite();
        player.x = FlxG.width  / 2;
        player.y = FlxG.height / 2;
        add(player);

        gun = new BulletManager();
        add(gun);
        add(new FlxText(0, FlxG.height - 20, 360, "W - A - S - D"));

        blocks = new FlxGroup();
        var b1 = new FlxSprite();
        var b2 = new FlxSprite();
        var b3 = new FlxSprite();
        blocks.add(b1);
        blocks.add(b2);
        blocks.add(b3);
        add(blocks);

        b1.health = 10;
        b2.health = 5;
        b3.health = 3;
        b1.x = FlxMath.rand(10, FlxG.width - 10);
        b2.x = FlxMath.rand(10, FlxG.width - 10);
        b3.x = FlxMath.rand(10, FlxG.width - 10);

        b1.y = FlxMath.rand(10, FlxG.height - 10);
        b1.y = FlxMath.rand(10, FlxG.height - 10);
        b1.y = FlxMath.rand(10, FlxG.height - 10);
    }
    override public function update():Void {
        super.update();

        player.angle = mouseAngle();

        if(FlxG.keys.pressed("W")) { player.y -= (speed + player.velocity.y); player.velocity.y += inertia; }
        if(FlxG.keys.pressed("A")) { player.x -= (speed + player.velocity.x); player.velocity.x += inertia; }
        if(FlxG.keys.pressed("S")) { player.y += (speed + player.velocity.y); player.velocity.y += inertia; }
        if(FlxG.keys.pressed("D")) { player.x += (speed + player.velocity.x); player.velocity.x += inertia; }

        if(FlxG.mouse.justPressed())    { gun.fire(player.x, player.y, player.angle); }

        if(player.x >= FlxG.width)  { player.x = FlxG.width  - player.width; }
        if(player.x <= 0)           { player.x = 0; }
        if(player.y >= FlxG.height) { player.y = FlxG.height - player.height; }
        if(player.y <= 0)           { player.y = 0; }


        player.velocity.x -= slowdown;
        player.velocity.y -= slowdown;

        if(player.velocity.x < 0) { player.velocity.x = 0; }
        if(player.velocity.y < 0) { player.velocity.y = 0; }

        FlxG.overlap(gun, blocks, shot);
    }

    private function shot(bulletRef:FlxObject, blockRef:FlxObject):Void
    {
        if (!blockRef.flickering){
            blockRef.hurt(1);
        }
        blockRef.flicker(1);
    }

    private function mouseAngle():Float
    {
        var radians = FlxMath.atan2(FlxG.mouse.x - player.x, FlxG.mouse.y - player.y);
        var degrees = (radians * (180 / Math.PI) * -1) + 90;
        return degrees;
    }

    override public function destroy():Void {
        super.destroy();
    }
}




