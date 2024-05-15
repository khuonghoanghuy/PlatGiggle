package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

class OptionsSubState extends FlxSubState
{
	var selectText:FlxText;
	var curTextofSelect:String = "";
	var curIntSelctText:Int = 0;
	var curSaveToSee:String = "";
	var curControlsChange:Bool = false;

	public function new()
	{
		super();
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width * 100, FlxG.height * 100, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);
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

		if (FlxG.keys.justPressed.LEFT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText - 1) % 4;
			if (curIntSelctText < 0)
				curIntSelctText = 3;
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText + 1) % 4;
		}

		if (FlxG.keys.justReleased.ESCAPE)
		{
			FlxG.save.flush();
			close();
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			curControlsChange = true;
			if (curControlsChange)
			{
				switch (curIntSelctText)
				{
					case 0:
						FlxG.save.data.leftKey = FlxG.keys.getIsDown()[0].ID.toString();
						curControlsChange = false;
					case 1:
						FlxG.save.data.downKey = FlxG.keys.getIsDown()[0].ID.toString();
						curControlsChange = false;
					case 2:
						FlxG.save.data.upKey = FlxG.keys.getIsDown()[0].ID.toString();
						curControlsChange = false;
					case 3:
						FlxG.save.data.rightKey = FlxG.keys.getIsDown()[0].ID.toString();
						curControlsChange = false;
				}
			}
		}
	}
}