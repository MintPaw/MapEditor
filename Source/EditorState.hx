package ;

import Utils.Point;
import openfl.utils.ByteArray;

class EditorState
{
	public var buffer:ByteArray;
	public var write_file:Dynamic;
	public var read_file:Dynamic;

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
					Std.int(_tilemap[indexOver].x * _tileWidth),
					Std.int(_tilemap[indexOver].y * _tileHeight),
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
			if (keyboard.keysJustDown[76]) load();
		}
	}

	private function save():Void
	{
		var data:String = "";

		for (key in _gameVars.keys())
		{
			data += key + "-" + _gameVars.get(key) + "|";
		}
		data = data.substr(0, data.length - 1);

		data += "\n-\n";

		for (tile in _tilemap)
		{
			data += tile.toString() + "|";
		}
		data = data.substr(0, data.length - 1);

		write_file(_filename, data);
	}

	private function load():Void
	{
		_gameVars = new Map();
		_tilemap = [];

		var data:String = read_file(_filename);

		var gameVarStrings:Array<String> = data.split("\n-\n")[0].split("|");
		for (gameVar in gameVarStrings)
		{
			_gameVars.set(gameVar.split("-")[0], gameVar.split("-")[1]);
		}

		var tileStrings:Array<String> = data.split("\n-\n")[1].split("|");

		for (tile in tileStrings)
		{
			var t:Tile = new Tile();
			t.fromString(tile);
			_tilemap.push(t);
		}

		reblit();
	}

	private function reblit():Void
	{
		for (tile in _tilemap)
		{
			trace("- " + tile.toString() + " " + tile.debugColour);
			_renderer.draw_rect(
					Std.int(tile.x * _tileWidth),
					Std.int(tile.y * _tileHeight),
					Std.int(_tileWidth),
					Std.int(_tileHeight),
					tile.debugColour);
		}
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