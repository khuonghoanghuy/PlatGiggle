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

class WinSubState extends FlxSubState
{
	var buttonReturn:Button;
	var buttonRestart:Button;

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

		var text:FlxText = new FlxText(0, 0, 0, "You are Win, wanna back to the Main Menu?");
		text.screenCenter();
		text.alignment = CENTER;
		add(text);

		buttonReturn = new Button();
		buttonReturn.x = Std.parseFloat(loadstringFile("assets/buttonPOS/returnMenuX.txt"));
		buttonReturn.y = Std.parseFloat(loadstringFile("assets/buttonPOS/returnMenuY.txt"));
		buttonReturn.text = "Yea";
		buttonReturn.addEventListener(TriggerEvent.TRIGGER, onExit);
		FlxG.stage.addChild(buttonReturn);

		buttonRestart = new Button();
		buttonRestart.x = Std.parseFloat(loadstringFile("assets/buttonPOS/restartX.txt"));
		buttonRestart.y = Std.parseFloat(loadstringFile("assets/buttonPOS/restartY.txt"));
		buttonRestart.text = "Restart Please";
		buttonRestart.addEventListener(TriggerEvent.TRIGGER, onResume);
		FlxG.stage.addChild(buttonRestart);
	}

	private function onExit(event:TriggerEvent):Void
	{
		trace("Button was clicked or tapped");
		FlxG.stage.removeChild(buttonReturn);
		FlxG.stage.removeChild(buttonRestart);
		close();
		FlxG.switchState(new MenuState());
	}

	private function onResume(event:TriggerEvent):Void
	{
		trace("Button was clicked or tapped");
		FlxG.stage.removeChild(buttonReturn);
		FlxG.stage.removeChild(buttonRestart);
		close();
		FlxG.resetState();
	}
}