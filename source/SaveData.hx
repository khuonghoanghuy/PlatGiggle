package;

import flixel.FlxG;

class SaveData
{
	public static function init()
	{
		FlxG.save.bind("platGiggleData", "huy1234th");
		if (FlxG.save.data.leftKey == null)
		{
			FlxG.save.data.leftKey = "LEFT";
		}

		if (FlxG.save.data.downKey == null)
		{
			FlxG.save.data.downKey = "DOWN";
		}

		if (FlxG.save.data.upKey == null)
		{
			FlxG.save.data.upKey = "UP";
		}

		if (FlxG.save.data.rightKey == null)
		{
			FlxG.save.data.rightKey = "RIGHT";
		}
		FlxG.save.flush();
	}
}