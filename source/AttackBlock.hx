package ;

import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.FlxWeapon;
import org.flixel.FlxG;
import org.flixel.FlxState;

class AttackBlock extends Block {

    var weapon:FlxWeapon;

    public function new() {
        super("attack-64x64.png");
        cost = 250;
        health = 4;
        weapon = new FlxWeapon("blaster", this, "x", "y");
        weapon.makePixelBullet(5,2,20,0xFFFFFFFF);
        weapon.setBulletDirection(FlxWeapon.BULLET_LEFT, 300);
    }

    public function fire(target:FlxSprite):Void {
        weapon.fireAtTarget(target);
    }

    override public function update():Void {
        super.update();
    }
    
    override public function destroy():Void {
        super.destroy();
    }
}
