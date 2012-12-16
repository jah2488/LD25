package ;

import org.flixel.FlxPoint;
import org.flixel.FlxButton;
import org.flixel.plugin.photonstorm.FlxButtonPlus;
import org.flixel.FlxEmitter;
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

    var coinText:FlxText;
    var coins = 500;

    var defense:FlxButtonPlus;
    var attack:FlxButtonPlus;
    var supply:FlxButtonPlus;
    var buttons:Array<FlxButtonPlus>;

    var selected:FlxButtonPlus;
    var selectedIndex = 0;

    var world:FlxSprite;

    var buildHighlight:FlxSprite;
    var blockHealthHover:FlxText;

    var dayLength = 10.0;
    var timer:Float = 10.0;
    var timerText:FlxText;
    var cycle = "DAY";

    var cycleCount = 0;

    var missiles:FlxGroup;
    var missileTimer:Float = 0;
    var bulletManager:BulletManager;

    var blockBag:Array<Block>;

    override public function create():Void {

        world = new FlxSprite();
        world.loadGraphic("assets/data/background-day.png");
        world.x = world.y = 0;
        add(world);

        bulletManager = new BulletManager();

        buildHighlight = new FlxSprite();
        buildHighlight.loadGraphic("assets/data/spritesheet-ancients-64x64.png", 64, 64);
        buildHighlight.x = -10000;
        add(buildHighlight);

        blockHealthHover = new FlxText(-1000,0, 65, "");

        defense = new FlxButtonPlus(20, 20, null, null, "Defense 150", 60, 30);
        defense.setOnClickCallback(onButtonClicked, [0]);
        add(defense);

        attack = new FlxButtonPlus(20, 60, null, null, "Attack   250", 60, 30);
        attack.setOnClickCallback(onButtonClicked, [1]);
        add(attack);

        supply = new FlxButtonPlus(20, 100, null, null, "Supply   100", 60, 30);
        supply.setOnClickCallback(onButtonClicked, [2]);
        add(supply);

        add(coinText  = new FlxText(90,20,90, Std.format("$coins Coins")));
        add(timerText = new FlxText(FlxG.width * 0.7, 20, 120, Std.format("$timer seconds in $cycle")));

        buttons = [defense, attack, supply];


        for(spot in 1...8) {
           var bs = new BuildSpot("spritesheet-ancients-64x64.png", 64, 64);
           bs.frame = 3;
           bs.setOnClickCallback(onBuildClicked, [bs]);
           bs.setMouseOverCallback(onBuildHovered, [bs]);
           bs.setMouseOutCallback(onBuildOut);
           bs.x = (FlxG.width  * .05) + (65 * spot);
           bs.y = (FlxG.height * .95);
           add(bs);
           if(spot == 4) {
//               buildBlock(new ResourceBlock(), bs);
           // Y U NO WORK
           }
        }
        blockBag = new Array<Block>();
        add(bulletManager);
    }

    private function onBuildOut():Void {
        buildHighlight.x = -1000;
    }

    private function onBuildClicked(spot:BuildSpot):Void {
        if(!spot.builtOn) {
            FlxG.play("Beep");
            var tile = Block.create(selectedIndex);
            if (coins - tile.cost >= 0) {
                buildBlock(tile, spot);
            } else { FlxG.play("Shoot"); }
        } else     { FlxG.play("Shoot"); }
    }

    private function buildBlock(tile:Block, spot:BuildSpot):Void {
        tile.setOnClickCallback(onBuildClicked, [tile]);
        tile.setMouseOverCallback(onBuildHovered, [tile]);
        tile.x = spot.x;
        tile.y = spot.y - spot.height;
        coins -= tile.cost;
        add(tile);
        blockBag.push(tile);
        spot.builtOn = true;
    }

    private function onBuildHovered(spot:BuildSpot):Void {
        buildHighlight.x = spot.x;
        buildHighlight.y = spot.y - spot.height;
    }

    private function onButtonClicked(button:Int):Void {
        FlxG.play("Beep");
        selectedIndex = button;
    }

    override public function update():Void {
        super.update();
        coinText.text  = Std.format("$coins Coins");
        timerText.text = Std.format("${FlxU.floor(timer)} seconds left in $cycle");
        selected = buttons[selectedIndex];
        switch(selectedIndex) {
            case 0:
                buildHighlight.frame = 7;
            case 1:
                buildHighlight.frame = 11;
            case 2:
                buildHighlight.frame = 3;
        }

        if(FlxG.keys.justPressed("SPACE")) {
            selectedIndex += 1;
            if(selectedIndex > buttons.length - 1) { selectedIndex = 0; }
        }

        for(button in buttons){
             if(buttons[selectedIndex] == button) {
                 var colors = new Array();
                 colors.push(0xFFFF00FF);
                 colors.push(0xFFFF99FF);
                 selected.updateInactiveButtonColors(colors);
             } else if(!button.active) {
                 var colors = [0xff800000, 0xffff0000];
                 button.updateInactiveButtonColors(colors);
             } else {
                 var colors = [0xff008000, 0xff00ff00];
                 button.updateInactiveButtonColors(colors);
             }
        }

        var lastCycle = cycle;
        timer -= FlxG.elapsed;
        if(timer <= 0) {
            timer = dayLength;
            cycle = cycle == "NIGHT" ? "DAY" : "NIGHT";
            cycleCount++;
        }

        if(lastCycle != cycle){
            if(cycle == "DAY") {
                world.loadGraphic("assets/data/background-day.png");
                for ( block in blockBag ) {
                    if ( Type.getClassName(Type.getClass(block)) == "ResourceBlock" ) {
                        FlxG.play("Coin");
                        block.flicker();
                        coinText.flicker();
                        coins += block.value;
                    }
                }
            }
            if(cycle == "NIGHT") {
                world.loadGraphic("assets/data/background-night.png");
            }
        }

        if(cycle == "NIGHT") {
            missileTimer += FlxG.elapsed;
            if (missileTimer >= 3) {
                bulletManager.fire(-20, (FlxG.height / 2) + FlxMath.rand(-100,100), 0);
                missileTimer = 0;
            }
        }

        for ( block in blockBag ) {
            FlxG.overlap(block, bulletManager, onCollision);
        }
    }

    private function onCollision(blockRef:FlxObject, missileRef:FlxObject):Void {
        cast(blockRef, Block).collide();
        missileRef.hurt(1);
    }
}




