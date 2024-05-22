package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSubState extends FlxSubState
{
	var selectText:FlxText;
	var curTextofSelect:String = "";
	var curIntSelctText:Int = 0;
	var curSaveToSee:String = "";
	var text:FlxText;

	public static var titleText:FlxText;

	public function new()
	{
		super();
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width * 100, FlxG.height * 100, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);
		titleText = new FlxText(2, 2, 0, "OPTIONS - MENU", 8);
		titleText.scrollFactor.set();
		add(titleText);
		selectText = new FlxText(15, FlxG.height - 40, 0, curTextofSelect, 18, false);
		selectText.setFormat(null, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(selectText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		selectText.text = curTextofSelect;

		switch (curIntSelctText)
		{
			case 0:
				curTextofSelect = "Control";
			case 1:
				curTextofSelect = "Gameplay";
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText - 1) % 2;
			if (curIntSelctText < 0)
				curIntSelctText = 1;
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText + 1) % 2;
		}

		if (FlxG.keys.justReleased.ESCAPE)
		{
			FlxG.save.flush();
			close();
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (curIntSelctText)
			{
				case 0:
					// close();
					curTextofSelect = "";
					openSubState(new ControlsSubState());
				case 1:
					// close();
					curTextofSelect = "";
					openSubState(new GameplaySubState());
			}
		}
	}
}