package ;

import org.flixel.FlxGroup;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Effects extends FlxSprite {

    public var z = 1000;

    public function new() {
        super();
        loadGraphic("assets/data/boom.png");
        this.x = -1000;
        scrollFactor.x = scrollFactor.y = 0;
        this.z = 1000;
    }

    public function explode(X:Float, Y:Float):Void {
        this.flicker(1);
        this.x = X;
        this.y = Y;
        FlxG.play("Hurt");
    }

override public function update():Void {
        super.update();
        if(!flickering) { this.x = -1000; }
    }
    
    override public function destroy():Void {
        super.destroy();
    }
}
