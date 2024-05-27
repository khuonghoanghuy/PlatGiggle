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
	var selectChap:FlxText;
	var curTextofSelect:String = "";
	var curTextofChap:String = "tutorial";
	var curIntSelctText:Int = 1;
	var curIntChapText:Int = 2;

	function loadstringFile(file:String)
	{
		var da:String = Assets.getText(file).trim();
		return da;
	}

	override function create()
	{
		super.create();
		FlxG.cameras.bgColor = 0xffaaaaaa;

		selectText = new FlxText(15, FlxG.height - 40, 0, curTextofSelect, 18, false);
		selectText.setFormat(null, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(selectText);
		selectChap = new FlxText(15, FlxG.height - 60, 0, curTextofChap, 18, false);
		selectChap.setFormat(null, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(selectChap);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// for real
		selectText.text = curTextofSelect;
		curTextofSelect = "Level Select: " + Std.string(curIntSelctText);
		selectChap.text = "Chapter Select: " + curTextofChap;

		switch (curIntChapText)
		{
			case 1:
				curTextofChap = "Tutorial";
			case 2:
				curTextofChap = "P1";
			case 3:
				curTextofChap = "P2";
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			trace("level select: " + curIntSelctText);
			PlayState.levelID = curIntSelctText;
			PlayState.chapType = curTextofChap;
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.UP)
		{
			trace(curIntChapText);
			curIntChapText = (curIntChapText - 1 + 1) % 3;
			if (curIntChapText == 0)
				curIntChapText = 3;
		}

		if (FlxG.keys.justPressed.DOWN)
		{
			trace(curIntChapText);
			curIntChapText = (curIntChapText + 1) % (3 + 1);
			if (curIntChapText == 0)
				curIntChapText = 1;
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText - 1 + 1) % 1;
			if (curIntSelctText == 0)
				curIntSelctText = 1;
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText + 1) % (1 + 1);
			if (curIntSelctText == 0)
				curIntSelctText = 1;
		}
	}
}