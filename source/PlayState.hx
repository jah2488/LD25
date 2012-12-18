package ;

import org.flixel.plugin.photonstorm.FlxCollision;
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
    var missileManager:BulletManager;
    var laser:Laser;
    var laserManager:BulletManager;

    var blockBag:Array<Block>;
    var blockGroup:FlxGroup;

    var gold:FlxSprite;
    var speed = 1;

    override public function create():Void {

        FlxG.playMusic("bgMusic");

        world = new FlxSprite();
        world.loadGraphic("assets/data/background-day.png");
        world.x = world.y = 0;
        add(world);

        missileManager = new BulletManager(10, Missile);
        laserManager   = new BulletManager(10, Laser);

        gold = new FlxSprite();
        gold.loadRotatedGraphic("assets/data/coin-64x64.png");
        gold.x = FlxG.width / 2 - 32;
        gold.y = 40;
        gold.immovable = true;
        gold.elasticity = 1;
        add(gold);

        buildHighlight = new FlxSprite();
        buildHighlight.loadGraphic("assets/data/spritesheet-ancients-64x64.png", 64, 64);
        buildHighlight.x = -10000;
        add(buildHighlight);

        blockHealthHover = new FlxText(-1000,0, 65, "");

        defense = new FlxButtonPlus(20, 20, null, null, Std.format("Barrier   ${Block.create(0).cost}"), 60, 30);
        defense.setOnClickCallback(onButtonClicked, [0]);
        add(defense);

        attack = new FlxButtonPlus(20, 60, null, null, Std.format("Fence     ${Block.create(1).cost}"), 60, 30);
        attack.setOnClickCallback(onButtonClicked, [1]);
        add(attack);

        supply = new FlxButtonPlus(20, 100, null, null, Std.format("Supply   ${Block.create(2).cost}"), 60, 30);
        supply.setOnClickCallback(onButtonClicked, [2]);
        add(supply);

        add(coinText  = new FlxText(90,20,90, Std.format("$coins Coins")));
        add(timerText = new FlxText(FlxG.width * 0.7, 20, 120, Std.format("$timer seconds in $cycle")));

        buttons = [defense, attack, supply];

        blockBag = new Array<Block>();
        blockGroup = new FlxGroup();

        for(spot in 1...8) {
           var bs = new BuildSpot("foundation-64.png", 64, 14);
           bs.frame = 3;
           bs.setOnClickCallback(onBuildClicked, [bs]);
           bs.setMouseOverCallback(onBuildHovered, [bs]);
           bs.setMouseOutCallback(onBuildOut);
           bs.x = (FlxG.width  * .05) + (65 * spot);
           bs.y = (FlxG.height * .97);
           add(bs);
           if(spot == 4) { buildBlock(Block.create(2), bs); }
        }

        add(missileManager);
        add(laserManager);

        Registry.init();
        add(Registry.effects);
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
        tile.setMouseOutCallback(onBuildOut);
        tile.x = spot.x;
        tile.y = spot.y - tile.height;
        tile.builtOnTopOf = spot;
        coins -= tile.cost;
        add(tile);
        blockBag.push(tile);
        blockGroup.add(tile);
        spot.builtOn = true;
    }

    private function onBuildHovered(spot:BuildSpot):Void {
        buildHighlight.alpha = 0.70;
        buildHighlight.x = spot.x;
        buildHighlight.y = spot.y - 64;
    }

    private function onButtonClicked(button:Int):Void {
        FlxG.play("Beep");
        selectedIndex = button;
    }

    override public function update():Void {
        super.update();

        gold.angle += speed * cycleCount;
        gold.velocity.x = (2 * speed) * cycleCount;

        if (gold.x >= FlxG.width - gold.width /2) { gold.x = (FlxG.width - gold.width / 2) - 10; speed *= -1; }
        if (gold.x <= gold.width / 2)             { gold.x = (gold.width / 2) + 10;              speed *= -1; }

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
                    }
                    coinText.flicker();
                    if(block.alive) {
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
                var y = FlxG.width / 2 ;
                var locationsX = [0, 150, 300,      0, FlxG.width + 20];
                var locationsY = [y, -50, -50, y + 50, y - 100];
                var r = FlxMath.rand(0,4);
                missileManager.fire(locationsX[r], locationsY[r], 0);
                missileTimer = 0;
            }
            if (Math.ceil(missileTimer) == 1) {
                var loc = [-60, -40, -20, 0, 20, 40, 60, 80, 100];
                laserManager.fire(0, FlxG.height/2 + loc[FlxMath.rand(0,loc.length)], 0);
                missileTimer = 1.1;
            }
        }

        FlxG.collide(gold, blockGroup, onCoinCollected);
        FlxG.overlap(blockGroup, missileManager, onCollision);
        FlxG.overlap(blockGroup, laserManager, onCollision);
        FlxG.overlap(blockGroup, blockGroup, onBlockCollision);
    }

    private function onCoinCollected(goldRef:FlxObject, blockRef:FlxObject):Void {
        var g = cast(goldRef, FlxSprite);
        var b = cast(blockRef, Block);
        if( Type.getClassName(Type.getClass(b)) == "ResourceBlock" ) {
            b.kill();
            FlxG.play("Coin");
            b.flicker();
            g.flicker();
            FlxG.flash(0xFFFFFFFF, 2, onCompleteFlash);
        } else {
            b.collide();
        }
    }

    private function onCompleteFlash():Void {
        FlxG.switchState(new WinState());
    }

    private function onBlockCollision(block1Ref:FlxObject, block2Ref:FlxObject):Void {
        var b1 = cast(block1Ref, Block);
        var b2 = cast(block2Ref, Block);
        b1.velocity.y = 0;
        b2.velocity.y = 0;
        b1.builtOnTopOf = b2;
        b2.builtOn = true;
    }
    private function onCollision(blockRef:FlxObject, missileRef:FlxObject):Void {
        cast(blockRef, Block).collide();
        missileRef.hurt(1);
    }
}




