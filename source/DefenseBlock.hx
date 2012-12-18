package ;

import org.flixel.FlxG;
import org.flixel.FlxState;

class DefenseBlock extends Block {

    public function new() {
        super("defense-64x64.png");
        cost = 250;
        health = 7;
    }

    override public function update():Void {
        super.update();
    }
    
    override public function destroy():Void {
        super.destroy();
    }
}
