package;

import org.flixel.plugin.photonstorm.FlxGradient;
import org.flixel.FlxGroup;
import org.flixel.FlxParticle;
import org.flixel.FlxEmitter;
import org.flixel.plugin.photonstorm.FlxMouseControl;
import org.flixel.plugin.photonstorm.FlxDisplay;
import org.flixel.FlxTileblock;
import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

class MenuState extends FlxState
{
    var player:FlxSprite;
    var block:FlxSprite;
    var whitePixel:FlxParticle;
    var rightEmitter:FlxEmitter;
    var leftEmitter:FlxEmitter;
    var startButton:FlxButton;
    var spriteGroup:FlxGroup;

	override public function create():Void
	{
		#if !neko
            FlxG.bgColor = 0xff131c1b;
		#else
            FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();

        player = new FlxSprite();
        player.x = 30;
        player.elasticity = 1;
        player.acceleration.y = 200;
        add(player);

        block = new FlxSprite();
        block.immovable = true;
        block.y = 200;
        block.x = 30;
        block.acceleration.y = 0;
        add(block);


        //create your text
        add(new FlxText(0, 0, 360, "THIS IS TEXT. OMGz put me places"));
        //create a button with the label Start and set an on click function
        startButton = new FlxButton(0, 0, "Start", onStartClick);
        //add the button to the state draw list
        add(startButton);
        //center align the button on the stage
        FlxDisplay.screenCenter(startButton,true,true);

        //Here we actually initialize out emitter
        //The parameters are        X   Y                Size (Maximum number of particles the emitter can store)
        rightEmitter = new FlxEmitter(10, FlxG.height / 2, 200);
        leftEmitter = new FlxEmitter(10, FlxG.height / 2, 200);

        //Now by default the emitter is going to have some properties set on it and can be used immediately
        //but we're going to change a few things.

        rightEmitter.bounce = 20.0;

        //First this emitter is on the button, and we want to show off the movement of the particles
        //so lets make them launch to the right and left of the button.
        rightEmitter.setXSpeed(100, 200);
        leftEmitter.setXSpeed(-100,-200);

        //and lets funnel it a tad
        rightEmitter.setYSpeed( -50, 50);
        leftEmitter.setYSpeed( -50, 50);

        //Let's also make our pixels rebound off surfaces
        rightEmitter.bounce = .8;
        leftEmitter.bounce = .8;

        //Now let's add the emitter to the state.
        add(rightEmitter);
        add(leftEmitter);

        addPixelsToEmitter(leftEmitter);
        addPixelsToEmitter(rightEmitter);


        //Now lets set our emitter free.
        //Params:        Explode, Particle Lifespan, Emit rate(in seconds)
        rightEmitter.x = startButton.x + startButton.width;
        rightEmitter.y = startButton.y;
        leftEmitter.y = startButton.y;
        leftEmitter.x = startButton.x;
        leftEmitter.setXSpeed(-100,-50);


        var b1:FlxSprite = new FlxSprite();
        var b2:FlxSprite = new FlxSprite();
        var b3:FlxSprite = new FlxSprite();
        var b4:FlxSprite = new FlxSprite();

        spriteGroup = new FlxGroup();

        b1.x = 150;
        b2.x = 250;
        b3.x = 400;
        b4.x = 450;

        b1.y = startButton.y;
        b2.y = startButton.y;
        b3.y = startButton.y;
        b4.y = startButton.y;

        spriteGroup.add(b1);
        spriteGroup.add(b2);
        spriteGroup.add(b3);
        spriteGroup.add(b4);

        add(spriteGroup);
    }

    private function addPixelsToEmitter(emitter:FlxEmitter):Void
    {
        for (i in 0...(Std.int(emitter.maxSize / 2)))
        {
            whitePixel = new FlxParticle();
            whitePixel.makeGraphic(2, 2, 0xFFFFFFFF);
            whitePixel.visible = false; //Make sure the particle doesn't show up at (0, 0)
            emitter.add(whitePixel);
            emitter.add(whitePixel);
            whitePixel = new FlxParticle();
            whitePixel.makeGraphic(1, 1, 0xFFFFFFFF);
            whitePixel.visible = false;
            emitter.add(whitePixel);
            emitter.add(whitePixel);
        }
    }

    private function onStartClick():Void
    {
        if(!rightEmitter.on && !leftEmitter.on){
            rightEmitter.start(false, 3, 0.1);
            leftEmitter.start(false, 3, 0.1);
            startButton.label.text = "Play";
        } else {
            rightEmitter.kill(); //Overwrite this to get custom behavior. (i.e. stop emitting particles and not kill off live ones.)
            leftEmitter.kill();
            startButton.label.text = "Start";
            FlxG.switchState(new PlayState());
        }
    }

    override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
        FlxG.collide(player, block);
        FlxG.collide(rightEmitter, player);
        FlxG.collide(rightEmitter, spriteGroup);
        FlxG.collide(leftEmitter, spriteGroup);
        rightEmitter.setRotation(0, 260);
	}
}