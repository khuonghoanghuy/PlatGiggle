package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ControlsSubState extends FlxSubState
{
	var selectText:FlxText;
	var curTextofSelect:String = "";
	var curIntSelctText:Int = 0;
	var curSaveToSee:String = "";
	var curControlsChange:Bool = false;
	var text:FlxText;

	public function new()
	{
		super();
		OptionsSubState.titleText.text = "OPTIONS - CONTROLS";
		selectText = new FlxText(15, FlxG.height - 40, 0, curTextofSelect, 18, false);
		selectText.setFormat(null, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(selectText);
		text = new FlxText(0, 0, 0, "Press a Key to Apply", 18);
		text.screenCenter();
		add(text);
		text.text = "";
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		selectText.text = curTextofSelect + curSaveToSee;

		switch (curIntSelctText)
		{
			case 0:
				curTextofSelect = "Key Left: ";
				curSaveToSee = FlxG.save.data.leftKey;
			case 1:
				curTextofSelect = "Key Down: ";
				curSaveToSee = FlxG.save.data.downKey;
			case 2:
				curTextofSelect = "Key Up: ";
				curSaveToSee = FlxG.save.data.upKey;
			case 3:
				curTextofSelect = "Key Right: ";
				curSaveToSee = FlxG.save.data.rightKey;
		}

		if (FlxG.keys.justPressed.LEFT && !curControlsChange)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText - 1) % 4;
			if (curIntSelctText < 0)
				curIntSelctText = 3;
		}

		if (FlxG.keys.justPressed.RIGHT && !curControlsChange)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText + 1) % 4;
		}

		if (FlxG.keys.justReleased.ESCAPE && !curControlsChange)
		{
			FlxG.save.flush();
			close();
			curTextofSelect = "";
			openSubState(new OptionsSubState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			curControlsChange = true;
			trace("curControlsChange: " + curControlsChange);
		}

		if (curControlsChange)
		{
			text.text = "Press a Key to Apply";
			if (!FlxG.keys.justPressed.ENTER && FlxG.keys.justPressed.ANY)
			{
				switch (curIntSelctText)
				{
					case 0:
						FlxG.save.data.leftKey = FlxG.keys.getIsDown()[0].ID.toString();
						trace("change to " + FlxG.save.data.leftKey);
					case 1:
						FlxG.save.data.downKey = FlxG.keys.getIsDown()[0].ID.toString();
						trace("change to " + FlxG.save.data.downKey);
					case 2:
						FlxG.save.data.upKey = FlxG.keys.getIsDown()[0].ID.toString();
						trace("change to " + FlxG.save.data.upKey);
					case 3:
						FlxG.save.data.rightKey = FlxG.keys.getIsDown()[0].ID.toString();
						trace("change to " + FlxG.save.data.rightKey);
				}
				text.text = "";
				curControlsChange = false;
			}
		}
	}
}