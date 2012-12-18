package ;

import org.flixel.FlxText;
import nme.events.Event;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Block extends BuildSpot {

    public var cost  = 0;
    public var value = 25;

    public function new(Graphic:String = "spritesheet-ancients-64x64.png") {
        super(Graphic, 64, 64);
    }

    public static function create(type:Int):Block {
        var r : Block = null;
        switch( type ) {
            case 0:
              r = new DefenseBlock();
            case 1:
              r = new AttackBlock();
            case 2:
              r = new ResourceBlock();
        }
        return r;
    }

    public function collide():Void {
        hurt(1);
        FlxG.play("Hurt");
        flicker(1);
    }

    override public function kill():Void {
        flicker(1);
        FlxG.shake(0.02, 0.5, killIt);
        builtOnTopOf.builtOn = false;
    }

    private function killIt():Void {
        super.kill();
    }

    override public function update():Void {
        super.update();
        if(!builtOnTopOf.alive) {
//           velocity.y += 2;
        }
    }
    
    override public function destroy():Void {
        super.destroy();
    }
}
