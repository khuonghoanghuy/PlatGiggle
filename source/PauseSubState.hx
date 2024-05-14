package;

import feathers.controls.Alert;
import feathers.controls.Button;
import feathers.events.TriggerEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class PauseSubState extends FlxSubState
{
	var selectText:FlxText;
	var curTextofSelect:String = "";
	var curIntSelctText:Int = 0;

	public function new()
	{
		super();
		var bg:FlxSprite = new FlxSprite();
		bg.screenCenter();
		bg.makeGraphic(FlxG.width * 100, FlxG.height * 100, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);
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
				curTextofSelect = "Resume";
			case 1:
				curTextofSelect = "Return To Main Menu";
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

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (curIntSelctText)
			{
				case 0:
					trace("resume thing");
					close();
				case 1:
					trace("return to main menu");
					FlxG.switchState(new MenuState());
			}
		}
	}
}