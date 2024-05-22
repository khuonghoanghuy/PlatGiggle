package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class SelectLevelState extends FlxState
{
	var selectText:FlxText;
	var curTextofSelect:String = "";
	var curIntSelctText:Int = 1;

	// how much thing
	var howMuch:Int = 3;
	var maxMuch:Int = 0;
	var howLeftFor:Int = 2;

	function loadstringFile(file:String)
	{
		var da:String = Assets.getText(file).trim();
		return da;
	}

	override function create()
	{
		super.create();

		howMuch = Std.parseInt(loadstringFile("assets/id/countLevel.txt"));
		maxMuch = Std.parseInt(loadstringFile("assets/id/countLevel.txt"));
		FlxG.cameras.bgColor = 0xffaaaaaa;

		selectText = new FlxText(15, FlxG.height - 40, 0, curTextofSelect, 18, false);
		selectText.setFormat(null, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(selectText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// for real
		selectText.text = curTextofSelect;
		curTextofSelect = "Level Select: " + Std.string(curIntSelctText);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			trace("level select: " + curIntSelctText);
			PlayState.levelID = curIntSelctText;
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText - 1 + howMuch) % howMuch;
			if (curIntSelctText == 0)
				curIntSelctText = maxMuch;
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText + 1) % (howMuch + 1);
			if (curIntSelctText == 0)
				curIntSelctText = 1;
		}
	}
}