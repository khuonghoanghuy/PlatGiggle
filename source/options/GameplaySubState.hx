package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameplaySubState extends FlxSubState
{
	var selectText:FlxText;
	var curTextofSelect:String = "";
	var curIntSelctText:Int = 0;
	var curSaveToSee:String = "";
	var text:FlxText;

	public function new()
	{
		super();
		OptionsSubState.titleText.text = "OPTIONS - GAMEPLAY";
		selectText = new FlxText(15, FlxG.height - 40, 0, curTextofSelect, 18, false);
		selectText.setFormat(null, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(selectText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		selectText.text = curTextofSelect + curSaveToSee;

		switch (curIntSelctText)
		{
			case 0:
				curTextofSelect = "Set Low Quality Stage: ";
				curSaveToSee = FlxG.save.data.lowStage;
		}

		/*if (FlxG.keys.justPressed.LEFT)
			{
				trace(curIntSelctText);
				curIntSelctText = (curIntSelctText - 1) % 1;
				if (curIntSelctText < 0)
					curIntSelctText = 1;
			}

			if (FlxG.keys.justPressed.RIGHT)
			{
				trace(curIntSelctText);
				curIntSelctText = (curIntSelctText + 1) % 1;
		}*/

		if (FlxG.keys.justReleased.ESCAPE)
		{
			FlxG.save.flush();
			curTextofSelect = "";
			close();
			openSubState(new OptionsSubState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (curIntSelctText)
			{
				case 0:
					FlxG.save.data.lowStage = !FlxG.save.data.lowStage;
			}
		}
	}
}