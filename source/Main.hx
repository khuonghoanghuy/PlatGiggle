package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 240, PlayState));
		addChild(new FPS(5, 5, 0xffffff));
	}
}
