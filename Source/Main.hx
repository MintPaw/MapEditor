package ;

// NOTE(jeru): Is platform dependant
import haxe.io.Bytes;
import openfl.Assets;
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
import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;

class Main extends Sprite
{
	private var _editorState:EditorState;
	private var _systemVars:Dynamic;
	private var _mouseState:EditorState.MouseState;
	private var _keyboardState:EditorState.KeyboardState;

	private var _canvas:Bitmap;
	private var _canvasData:BitmapData;
	private var _buffer:ByteArray;
	private var _rect:Rectangle;
	
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

		_systemVars = 
		{
			width: stage.stageWidth,
			height: stage.stageHeight
		};

		_editorState = new EditorState(_systemVars);
		_editorState.write_file = write_file;
		_editorState.read_file = read_file;
		_editorState.get_image_data = get_image_data;
		_editorState.image_to_tilemap = image_to_tilemap;
		_editorState.start();

		_canvasData = new BitmapData(_systemVars.width, _systemVars.height);

		_rect = _canvasData.rect;
		_buffer = _canvasData.getPixels(_rect);
		Memory.select(_buffer);

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
		_editorState.update(1/60 * 1000, _mouseState, _keyboardState);
		_buffer.position = 0;
		_canvasData.setPixels(_rect, _buffer);

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

	private function write_file(filename:String, contents:String):Void
	{
		var file:FileOutput = File.write(filename);
		file.write(Bytes.ofString(contents));
		file.close();
	}
	
	private function read_file(filename:String):String
	{
		var file:FileInput = File.read(filename);
		var bytes:Bytes = file.readAll();
		var string:String = bytes.getString(0, bytes.length);
		file.close();

		return string;
	}

	private function get_image_data(filename:String):Utils.ImageData
	{
		var bitmapData:BitmapData = Assets.getBitmapData(filename);
		var ba:ByteArray = bitmapData.getPixels(bitmapData.rect);
		return { width: bitmapData.width, height: bitmapData.height, byteArray: ba };
	}

	private function image_to_tilemap(imageData: Utils.ImageData, tileWidth:Int, tileHeight:Int):Utils.Tilemap
	{
		var tilemap:Utils.Tilemap = { byteArrays: [], tileWidth: tileWidth, tileHeight: tileHeight };
		var bitmapData:BitmapData = new BitmapData(imageData.width, imageData.height, false);
		var tilesWide:Int = Std.int(imageData.width / tileWidth);
		var tilesHigh:Int = Std.int(imageData.height / tileHeight);

		imageData.byteArray.position = 0;
		bitmapData.setPixels(new Rectangle(0, 0, imageData.width, imageData.height), imageData.byteArray);

		for (xi in 0...tilesWide)
		{
			for (yi in 0...tilesHigh)
			{
				tilemap.byteArrays[yi * tilesWide + xi] = bitmapData.getPixels(new Rectangle(xi * tileWidth, yi * tileHeight, tileWidth, tileHeight));
			}
		}

		return tilemap;
	}
}