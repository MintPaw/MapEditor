package ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Main extends Sprite
{
	var _editorState:EditorState;
	var _gameVars:Dynamic;
	var _canvas:Bitmap;
	var _canvasData:BitmapData;
	
	public function new()
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event):Void
	{
		addEventListener(Event.ADDED_TO_STAGE, init);
		stage.frameRate = 60;

		_gameVars = 
		{
			width: stage.stageWidth,
			height: stage.stageHeight,
		};

		_editorState = new EditorState(_gameVars);

		_canvasData = new BitmapData(_gameVars.width, _gameVars.height, false);

		_canvas = new Bitmap(_canvasData);
		addChild(_canvas);

		addEventListener(Event.ENTER_FRAME, update);
	}

	private function update(e:Event):Void
	{
		var renders:Array<EditorState.TileRender> = _editorState.update(1/60 * 1000);

		for (tile in renders)
		{
			_canvasData.fillRect(new Rectangle(tile.x, tile.y, tile.width, tile.height), tile.colour);
		}
	}
}