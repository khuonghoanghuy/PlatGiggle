package;

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

/**
 * @author Zaphod
 */
class PlayState extends FlxState
{
	static var _justDied:Bool = false;

	var _level:FlxTilemap;
	var _player:FlxSprite;
	var _exit:FlxSprite;
	var _scoreText:FlxText;
	var _status:FlxText;
	var _coins:FlxGroup;

	public static var levelID:Int = 1;

	function loadstringFile(file:String) {
		var da:String = Assets.getText(file).trim();
		return da;
	}

	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xffaaaaaa;

		_level = new FlxTilemap();
		_level.loadMapFromCSV("assets/id/lev" + levelID + "/data.csv", FlxGraphic.fromClass(GraphicAuto), 0, 0, AUTO);
		add(_level);

		// Create the _level _exit
		_exit = new FlxSprite(35 * 8 + 1, 25 * 8);
		_exit.makeGraphic(14, 16, FlxColor.GREEN);
		_exit.exists = false;
		add(_exit);

		// Create _coins to collect (see createCoin() function below for more info)
		_coins = new FlxGroup();
		var interp = new Interp();
		interp.variables.set("createCoin", createCoin);
		interp.variables.set("setExitPOS", function (x:Int, y:Int) {
			_exit.setPosition(x * 8 + 1, y * 8);
		});
		interp.variables.set("setPlayerPOS", function(x:Float, y:Float)
		{
			_player.x = x;
			_player.y = y;
		});
		interp.variables.set("FlxG", FlxG);
		var parser = new Parser();
		interp.execute(parser.parseString(loadstringFile("assets/id/lev"+levelID+"/coin.txt")));
		add(_coins);

		// Create _player
		_player = new FlxSprite(FlxG.width / 2 - 5);
		trace(_player.x);
		trace(_player.y);
		_player.loadGraphic("assets/images/player.png", false, 8, 8);
		_player.maxVelocity.set(80, 200);
		_player.acceleration.y = 200;
		_player.drag.x = _player.maxVelocity.x * 4;
		add(_player);

		_scoreText = new FlxText(2, 2, 80, "SCORE: " + (_coins.countDead() * 100));
		_scoreText.setFormat(null, 8, FlxColor.WHITE, null, NONE, FlxColor.BLACK);
		add(_scoreText);

		_status = new FlxText(FlxG.width - 160 - 2, 2, 160, "Collect coins.");
		_status.setFormat(null, 8, FlxColor.WHITE, RIGHT, NONE, FlxColor.BLACK);

		if (_justDied)
		{
			_status.text = "Aww, you died!";
		}

		add(_status);
	}

	override public function update(elapsed:Float):Void
	{
		_player.acceleration.x = 0;

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			_player.flipX = true;
			_player.acceleration.x = -_player.maxVelocity.x * 4;
		}

		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			_player.flipX = false;
			_player.acceleration.x = _player.maxVelocity.x * 4;
		}

		if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && _player.isTouching(FLOOR))
		{
			_player.velocity.y = -_player.maxVelocity.y / 2;
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			openSubState(new PauseSubState());
		}

		super.update(elapsed);

		FlxG.overlap(_coins, _player, getCoin);
		FlxG.collide(_level, _player);
		FlxG.overlap(_exit, _player, win);
	
		if (FlxG.keys.justPressed.F4) {
			FlxG.resetState();
		}

		if (_player.y > FlxG.height)
		{
			_justDied = true;
			FlxG.resetState();
		}
	}

	/**
	 * Creates a new coin located on the specified tile
	 */
	function createCoin(X:Int, Y:Int):Void
	{
		var coin:FlxSprite = new FlxSprite(X * 8 + 3, Y * 8 + 2);
		coin.makeGraphic(2, 4, 0xffffff00);
		_coins.add(coin);
	}

	function win(Exit:FlxObject, Player:FlxObject):Void
	{
		_status.text = "Yay, you won!";
		_scoreText.text = "SCORE: " + (_coins.countDead() * 100);
		_player.kill();
	}

	function getCoin(Coin:FlxObject, Player:FlxObject):Void
	{
		Coin.kill();
		_scoreText.text = "SCORE: " + (_coins.countDead() * 100);

		if (_coins.countLiving() == 0)
		{
			_status.text = "Find the exit";
			_exit.exists = true;
		}
	}
}
