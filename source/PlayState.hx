package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import hscript.Interp;
import hscript.Parser;
import lime.utils.Assets;

using StringTools;

class PlayState extends FlxState
{
	public static var levelID:Int = 1;
	
	// gui
	var player:FlxSprite;
	var exit:FlxSprite;

	// hud
	var levelTM:FlxTilemap;
	var scoreTxt:FlxText;
	var coins:FlxGroup;

	function loadstringFile(file:String):String
	{
		var da:String = Assets.getText(file).trim();
		return da;
	}

	// cam hud
	public static var camHUD:FlxCamera;

	override function create()
	{
		FlxG.cameras.bgColor = Std.parseInt(loadstringFile("assets/id/lev" + levelID + "/colorbg.txt"));
		// FlxG.cameras.bgColor = FlxColor.GRAY;
		
		super.create();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);
		
		levelTM = new FlxTilemap();
		levelTM.loadMapFromCSV("assets/id/lev" + levelID + "/data.csv",
			FlxGraphic.fromBitmapData(openfl.Assets.getBitmapData("assets/id/graphic/graphic.png")), 0, 0);
		add(levelTM);

		player = new FlxSprite(Std.parseFloat(loadstringFile("assets/id/lev" + levelID + "/playerX.txt")),
			Std.parseFloat(loadstringFile("assets/id/lev" + levelID + "/playerY.txt")));
		trace(player.x);
		trace(player.y);
		player.loadGraphic("assets/images/player.png", false, 8, 8);
		player.maxVelocity.set(80, 200);
		player.acceleration.y = 200;
		player.drag.x = player.maxVelocity.x * 4;
		// FlxG.camera.follow(player, LOCKON, 1);
		// FlxG.camera.zoom = 1.5;
		add(player);

		coins = new FlxGroup();
		var interp = new Interp();
		interp.variables.set("createCoin", createCoin);
		interp.variables.set("setExitPOS", function (x:Int, y:Int) {
			exit.setPosition(x * 8 + 1, y * 8);
		});
		interp.variables.set("setPlayerPOS", function(x:Float, y:Float)
		{
			player.x = x;
			player.y = y;
		});
		interp.variables.set("FlxG", FlxG);
		var parser = new Parser();
		interp.execute(parser.parseString(loadstringFile("assets/id/lev" + levelID + "/data.txt")));
		add(coins);

		exit = new FlxSprite(35 * 8 + 1, 25 * 8);
		exit.makeGraphic(14, 16, FlxColor.GREEN);
		exit.exists = false;
		add(exit);

		scoreTxt = new FlxText(2, 2, 80, "SCORE: 0");
		scoreTxt.setFormat(null, 8, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		scoreTxt.cameras = [camHUD];
		add(scoreTxt);
	}    

	/**
	 * Creates a new coin located on the specified tile
	 */
	function createCoin(X:Int, Y:Int):Void
	{
		var coin:FlxSprite = new FlxSprite(X * 8 + 3, Y * 8 + 2);
		coin.makeGraphic(2, 4, 0xffffff00);
		coins.add(coin);
	}

	override function update(elapsed:Float)
	{
		player.acceleration.x = 0;

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			player.flipX = true;
			player.acceleration.x = -player.maxVelocity.x * 2;
		}

		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			player.flipX = false;
			player.acceleration.x = player.maxVelocity.x * 2;
		}

		if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && player.isTouching(FLOOR))
		{
			player.velocity.y = -player.maxVelocity.y / 2;
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			openSubState(new PauseSubState());
		}

		super.update(elapsed);

		FlxG.overlap(coins, player, getCoin);
		FlxG.collide(levelTM, player);
		FlxG.overlap(exit, player, win);
	}

	function win(Exit:FlxObject, Player:FlxObject):Void
	{
		scoreTxt.text = "SCORE: " + (coins.countDead() * 100);
		player.kill();
		// openSubState(new WinSubState());
	}

	function getCoin(Coin:FlxObject, Player:FlxObject):Void
	{
		FlxG.sound.play("assets/sounds/coins.wav", 1);
		Coin.kill();
		scoreTxt.text = "SCORE: " + (coins.countDead() * 100);

		if (coins.countLiving() == 0)
		{
			exit.exists = true;
		}
	}
}