package;

import feathers.controls.Button;
import feathers.events.TriggerEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class ExitSubState extends FlxSubState
{
	var buttonExit:Button;
	var buttonResume:Button;

	function loadstringFile(file:String)
	{
		var da:String = Assets.getText(file).trim();
		return da;
	}

	public function new()
	{
		super();
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width * 100, FlxG.height * 100, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		var text:FlxText = new FlxText(0, 0, 0, "Are You sure?");
		text.screenCenter();
		text.alignment = CENTER;
		add(text);

		buttonExit = new Button();
		buttonExit.x = Std.parseFloat(loadstringFile("assets/buttonPOS/exitX.txt"));
		buttonExit.y = Std.parseFloat(loadstringFile("assets/buttonPOS/exitY.txt"));
		buttonExit.text = "Yea";
		buttonExit.addEventListener(TriggerEvent.TRIGGER, onExit);
		FlxG.stage.addChild(buttonExit);

		buttonResume = new Button();
		buttonResume.x = Std.parseFloat(loadstringFile("assets/buttonPOS/resumeX.txt"));
		buttonResume.y = Std.parseFloat(loadstringFile("assets/buttonPOS/resumeY.txt"));
		buttonResume.text = "Wait No!";
		buttonResume.addEventListener(TriggerEvent.TRIGGER, onResume);
		FlxG.stage.addChild(buttonResume);
	}

	private function onExit(event:TriggerEvent):Void
	{
		trace("Button was clicked or tapped");
		FlxG.save.flush();
		Sys.exit(0);
	}

	private function onResume(event:TriggerEvent):Void
	{
		trace("Button was clicked or tapped");
		// if we wanna resume instead exit, must remove all of them
		FlxG.stage.removeChild(buttonExit);
		FlxG.stage.removeChild(buttonResume);
		close();
	}
}