package ;

import Utils.Point;
import openfl.utils.ByteArray;

class EditorState
{
	public var buffer:ByteArray;
	public var write_file:Dynamic;

	private var _systemVars:Dynamic;
	private var _gameVars:Map<String, String>;
	private var _tilemap:Array<Tile>;
	private var _renderer:Renderer;

	private var _filename:String;

	private var _tileWidth:Float = 40;
	private var _tileHeight:Float = 40;
	private var _widthInTiles:Int = 32;
	private var _heightInTiles:Int = 18;

	private var _tileToPaint:Int = 1;

	public function new(systemVars:Dynamic, buffer:ByteArray)
	{
		this.buffer = buffer;
		_systemVars = systemVars;
		_filename = "UntitledMap.mim";
		_gameVars = new Map();

		_gameVars.set("tileWidth", Std.string(_tileWidth));
		_gameVars.set("tileHeight", Std.string(_tileHeight));
		_gameVars.set("widthInTiles", Std.string(_heightInTiles));
		_gameVars.set("heightInTiles", Std.string(_widthInTiles));

		{ // Setup tilemap
			_tilemap = [];

			for (tileY in 0..._heightInTiles)
			{
				for (tileX in 0..._widthInTiles)
				{
					_tilemap.push(new Tile(tileX, tileY, 0));
				}
			}
		}

		{ // Setup renderer
			_renderer = new Renderer(buffer, _systemVars.width);
		}
	}

	public function update(time:Float, mouse:MouseState, keyboard:KeyboardState):Void
	{
		{ // Update mouse
			if (mouse.mouse1)
			{
				var tileOver:Point = { x: mouse.x / _tileWidth, y: mouse.y / _tileHeight };
				var indexOver:Int = Utils.point_to_index(tileOver.x, tileOver.y, _widthInTiles);
				_tilemap[indexOver].paint(_tileToPaint);

				_renderer.draw_rect(
					Std.int(Utils.round(mouse.x, _tileWidth) - _tileWidth / 2),
					Std.int(Utils.round(mouse.y, _tileHeight) - _tileHeight / 2),
					Std.int(_tileWidth),
					Std.int(_tileHeight),
					_tilemap[indexOver].debugColour);
			}
		}

		{ // Update Keyboard
			// NOTE(jeru): These are not ascii
			if (keyboard.keysJustDown[188]) _tileToPaint = _tileToPaint - 1 >= 0 ? _tileToPaint - 1: _tileToPaint;
			if (keyboard.keysJustDown[190]) _tileToPaint = _tileToPaint + 1;

			if (keyboard.keysJustDown[83]) save();
		}
	}

	private function save():Void
	{
		var data:String = "";

		for (key in _gameVars.keys())
		{
			data += key + "-" + _gameVars.get(key) + "|";
		}

		data += "\n-\n";

		for (tile in _tilemap)
		{
			data += tile.toString() + "|";
		}		

		write_file(_filename, data);
	}
}

typedef MouseState = {
	x:Float,
	y:Float,
	mouse1:Bool
}

typedef KeyboardState = {
	keysDown:Array<Bool>,
	keysJustDown:Array<Bool>,
	keysJustUp:Array<Bool>
}