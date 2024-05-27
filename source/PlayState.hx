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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
	var debugTxt:FlxText;
	var coins:FlxGroup;

	function loadstringFile(file:String):String
	{
		var da:String = Assets.getText(file).trim();
		return da;
	}

	// cam hud
	public static var camHUD:FlxCamera;

	public static var chapType:String = "tutorial";

	var debugMode:Bool = false;

	override function create()
	{
		// FlxG.cameras.bgColor = Std.parseInt(loadstringFile("assets/id/lev" + levelID + "/colorbg.txt"));
		// FlxG.cameras.bgColor = FlxColor.GRAY;
		
		super.create();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);
		
		levelTM = new FlxTilemap();
		levelTM.loadMapFromCSV(Paths.file("id/" + chapType + "/lev" + levelID + ".csv"),
			FlxGraphic.fromBitmapData(openfl.Assets.getBitmapData("assets/id/" + chapType + "/graphic.png")), 0, 0);
		add(levelTM);

		exit = new FlxSprite(35 * 8 + 1, 25 * 8);
		exit.loadGraphic("assets/images/doors.png", true, 14, 16);
		exit.animation.add("still", [0]);
		exit.animation.add("open", [0, 1, 2, 3], 4, false);
		exit.animation.add("areopen", [3]);
		trace(exit.x);
		trace(exit.y);
		add(exit);

		player = new FlxSprite(/*Std.parseFloat(loadstringFile("assets/id/lev" + levelID + "/playerX.txt")),
			Std.parseFloat(loadstringFile("assets/id/lev" + levelID + "/playerY.txt")) */);
		trace(player.x);
		trace(player.y);
		player.loadGraphic("assets/images/player.png", true, 8, 8);
		player.animation.add("idle", [0, 1, 2], 1, true);
		player.animation.play("idle");
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
			exit.setPosition(x, y);
		});
		interp.variables.set("setPlayerPOS", function(x:Float, y:Float)
		{
			player.x = x;
			player.y = y;
		});
		interp.variables.set("levelID", levelID);
		interp.variables.set("FlxG", FlxG);
		var parser = new Parser();
		interp.execute(parser.parseString(loadstringFile("assets/id/" + chapType + "/data.txt")));
		add(coins);

		scoreTxt = new FlxText(2, 2, 80, "SCORE: 0\nLEVEL: " + levelID);
		scoreTxt.setFormat(null, 8, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		scoreTxt.cameras = [camHUD];
		add(scoreTxt);
		debugTxt = new FlxText(scoreTxt.x, scoreTxt.y, 0, "DEBUG MODE");
		debugTxt.setFormat(null, 8, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		debugTxt.cameras = [camHUD];
		add(debugTxt);
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

		if (FlxG.keys.justPressed.F12) // toggle debug key
		{
			debugMode = !debugMode;
			debugTxt.text = (debugMode ? "DEBUG MODE" : "");
		}

		if (debugMode)
		{
			if (FlxG.mouse.overlaps(exit))
			{
				debugTxt.text = "DEBUG MODE\nPOSTION: " + exit.x + " - " + exit.y;
				if (FlxG.keys.pressed.LEFT)
				{
					exit.x -= 1;
				}
				if (FlxG.keys.pressed.RIGHT)
				{
					exit.x += 1;
				}
				if (FlxG.keys.pressed.UP)
				{
					exit.y -= 1;
				}
				if (FlxG.keys.pressed.DOWN)
				{
					exit.y += 1;
				}
			}
		}

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

		/*if (FlxG.keys.justPressed.F6)
		{
			exit.exists = !exit.exists;
		}

		if (FlxG.keys.justPressed.F5)
		{
			FlxG.resetState();
		}*/

		super.update(elapsed);

		FlxG.overlap(coins, player, getCoin);
		FlxG.collide(levelTM, player);
		FlxG.overlap(exit, player, win);
	}

	function win(Exit:FlxObject, Player:FlxObject):Void
	{
		// check if player is get all coin
		if (coins.countLiving() == 0)
		{
			scoreTxt.text = "SCORE: " + (coins.countDead() * 100) + "\nLEVEL: " + levelID;
			player.kill();
			openSubState(new WinSubState());
		}
	}

	function getCoin(Coin:FlxObject, Player:FlxObject):Void
	{
		FlxG.sound.play("assets/sounds/coins.wav", 1);
		Coin.kill();
		scoreTxt.text = "SCORE: " + (coins.countDead() * 100) + "\nLEVEL: " + levelID;

		if (coins.countLiving() == 0)
		{
			exit.animation.play("open");
			exit.animation.finishCallback = function(name:String)
			{
				if (name == "open")
				{
					exit.animation.play("areopen");
				}
			}
		}
	}
}