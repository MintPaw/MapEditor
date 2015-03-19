package ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Main extends Sprite
{
	var _editorState:EditorState;
	var _gameVars:Dynamic;
	var _mouseState:EditorState.MouseState = { x: 0, y: 0, mouse1: false };
	
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
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouse_move);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
	}

	private function update(e:Event):Void
	{
		_editorState.update(1/60 * 1000, _mouseState);

		for (tile in _editorState.renders)
		{
			_canvasData.fillRect(new Rectangle(tile.x, tile.y, tile.width, tile.height), tile.colour);
		}
	}

	private function mouse_move(e:MouseEvent):Void
	{
		_mouseState.x = e.stageX;
		_mouseState.y = e.stageY;
	}

	private function mouse_down(e:MouseEvent):Void
	{
		_mouseState.mouse1 = true;
	}

	private function mouse_up(e:MouseEvent):Void
	{
		_mouseState.mouse1 = false;
	}
}