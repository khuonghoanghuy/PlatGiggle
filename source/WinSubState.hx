package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class WinSubState extends FlxSubState
{
	var coinGet:Int = 0;
	var coinGetTxt:FlxText;
	var timeCompleteLevel:Float = 0;
	var timeCompleteLevelTxt:FlxText;

	public function new()
	{
		super();
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width * 100, FlxG.height * 100, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		bg.cameras = [PlayState.camHUD];
		add(bg);

		var youWin:FlxText = new FlxText(0, 0, 0, "!!You Win!!", 25);
		youWin.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		youWin.screenCenter();
		youWin.cameras = [PlayState.camHUD];
		add(youWin);

		coinGetTxt = new FlxText(youWin.x - 50, youWin.y - 50, 0, "Coin: " + coinGet, 18);
		coinGetTxt.setFormat(null, 8, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		coinGetTxt.cameras = [PlayState.camHUD];
		add(coinGetTxt);

		timeCompleteLevelTxt = new FlxText(coinGetTxt.x - 50, coinGetTxt.y - 50, 0, "Time Complete: " + timeCompleteLevel, 18);
		timeCompleteLevelTxt.setFormat(null, 8, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		timeCompleteLevelTxt.cameras = [PlayState.camHUD];
		add(timeCompleteLevelTxt);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			close();
			FlxG.switchState(new MenuState());
		}
	}
}