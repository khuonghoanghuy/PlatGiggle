package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var selectText:FlxText;
	var curTextofSelect:String = "";
	var curIntSelctText:Int = 0;

	override function create()
	{
		super.create();
		SaveData.init();
		if (FlxG.save.data.lowStage == true)
		{
			FlxG.stage.quality = LOW;
		}
		else
		{
			FlxG.stage.quality = MEDIUM;
		}

		FlxG.cameras.bgColor = 0xffaaaaaa;

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
				curTextofSelect = "Play";
			case 1:
				curTextofSelect = "Options";
			case 2:
				curTextofSelect = "Exit";
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText - 1) % 3;
			if (curIntSelctText < 0)
				curIntSelctText = 2;
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			trace(curIntSelctText);
			curIntSelctText = (curIntSelctText + 1) % 3;
		}

		if (FlxG.keys.justPressed.F11)
		{
			openSubState(new MenuSubState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (curIntSelctText)
			{
				case 0:
					trace("move to select level");
					FlxG.switchState(new SelectLevelState());
				case 1:
					trace("open config level");
					openSubState(new options.OptionsSubState());
				case 2:
					trace("exit game");
					FlxG.save.flush();
					Sys.exit(0);
			}
		}
	}
}

class MenuSubState extends FlxSubState
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
		titleText = new FlxText(2, 2, 0, "MENU SUBSTATE", 8);
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
				curTextofSelect = "Restart Game";
			case 1:
				curTextofSelect = "Restart State";
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
					FlxG.save.flush();
					FlxG.resetGame();
				case 1:
					FlxG.save.flush();
					FlxG.resetState();
			}
		}
	}
}