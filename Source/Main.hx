package ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Memory;
import openfl.utils.ByteArray;

class Main extends Sprite
{
	private var _editorState:EditorState;
	private var _gameVars:Dynamic;
	private var _mouseState:EditorState.MouseState;
	private var _keyboardState:EditorState.KeyboardState;

	private var _canvas:Bitmap;
	private var _canvasData:BitmapData;
	
	public function new()
	{
		super();
		_mouseState = { x: 0, y: 0, mouse1: false };
		_keyboardState = { keysDown: [], keysJustDown: [], keysJustUp: [] };

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
		stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
		stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
	}

	private function update(e:Event):Void
	{
		var start:Float = Sys.time() * 1000;

		for (i in 0...1)
		{			
			_canvasData.setPixel(Math.round(Math.random() * _gameVars.width), Math.round(Math.random() * _gameVars.height), Math.round(Math.random() * 0xFFFFFF));
		}
		
		trace(Sys.time() * 1000 - start + "ms.");

		return;
		_editorState.update(1/60 * 1000, _mouseState, _keyboardState);

		{ // Render Tiles
			for (tile in _editorState.renders)
			{
				_canvasData.fillRect(new Rectangle(tile.x, tile.y, tile.width, tile.height), tile.colour);
			}
		}

		{ // Recheck just keys
			for (keyIndex in 0..._keyboardState.keysJustUp.length) _keyboardState.keysJustUp[keyIndex] = false;
			for (keyIndex in 0..._keyboardState.keysJustDown.length) _keyboardState.keysJustDown[keyIndex] = false;
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

	private function key_down(e:KeyboardEvent):Void
	{
		_keyboardState.keysJustDown[e.keyCode] = true;
		_keyboardState.keysDown[e.keyCode] = true;
	}

	private function key_up(e:KeyboardEvent):Void
	{
		_keyboardState.keysJustUp[e.keyCode] = true;
		_keyboardState.keysDown[e.keyCode] = false;
	}
}