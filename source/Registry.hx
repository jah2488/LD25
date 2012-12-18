package ;

import org.flixel.FlxG;
import org.flixel.FlxState;

class Registry {

    public static var effects:Effects;

    public static function init() {
        effects = new Effects();
    }
}
