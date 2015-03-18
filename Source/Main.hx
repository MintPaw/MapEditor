package;

import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class Main extends Sprite
{
	
	public function new()
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event):Void
	{
		addEventListener(Event.ADDED_TO_STAGE, init);
		
		var gameVars:Dynamic = 
		{
			width: stage.stageWidth,
			height: stage.stageHeight
		};

		var bitmapData:BitmapData = new BitmapData(gameVars.width, gameVars.height);
		var bitmap:Bitmap = new Bitmap();

		addChild(bitmap);
	}
}