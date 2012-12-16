package ;

import org.flixel.FlxG;
import org.flixel.FlxSprite;

class ResourceBlock extends Block {

    public function new() {
        super("supply-64x64.png");
        cost  = 100;
        value = 50;
        health = 3;
    }
    
    override public function update():Void {
        super.update();
    }
    
    override public function destroy():Void {
        super.destroy();
    }
}
