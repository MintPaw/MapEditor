package ;

import Utils.Point;
import Utils.ImageData;
import Utils.Tilemap;
import Utils.TextField;
import openfl.utils.ByteArray;

class EditorState
{
	public var write_file:Dynamic;
	public var read_file:Dynamic;
	public var get_image_data:Dynamic;
	public var image_to_tilemap:Dynamic;
	public var get_font:Dynamic;

	private var _systemVars:Dynamic;
	private var _gameVars:Map<String, String>;
	private var _tilemap:Array<Tile>;
	private var _renderer:Renderer;

	private var _filename:String;

	private var _tileToPaint:Int = -1;
	private var _tilemapData:Tilemap;

	public function new(systemVars:Dynamic)
	{
		{ // Setup vars
			_systemVars = systemVars;
			_renderer = new Renderer(_systemVars.width);
		}
	}

	public function start():Void
	{
		{ // Prepare fonts
			var testFont:Font = Utils.get_font("Open Sans", get_image_data("Assets/img/font/OpenSans.png"), 512/16, 592/16);
			_renderer.draw_byte_array(
		}

		

		return;

		_renderer.draw_rect(0, 0, _systemVars.width, _systemVars.height, 0x000000FF);

		var textField = { x: 0.0, y: 0.0, width: 200.0, height: 50.0, text: "test", bgColour: 0xFFFFFFFF, fontName: "OpenSans" };
		_renderer.draw_text_field(textField);
	}

	private function setupEditor()
	{
		{ // Setup starting variables
			_filename = "UntitledMap.mim";
			_gameVars = new Map();
			_tilemapData = Utils.image_to_tilemap(get_image_data("Assets/img/tilemaps/tilemap.png"), 40, 40);
		}

		_gameVars.set("tileWidth", "40");
		_gameVars.set("tileHeight", "40");
		_gameVars.set("widthInTiles", "32");
		_gameVars.set("heightInTiles", "18");

		{ // Setup tilemap
			_tilemap = [];

			for (tileY in 0...Std.parseInt(_gameVars.get("heightInTiles")))
			{
				for (tileX in 0...Std.parseInt(_gameVars.get("widthInTiles")))
				{
					_tilemap.push(new Tile(tileX, tileY, 0));
				}
			}
		}
	}

	public function update(time:Float, mouse:MouseState, keyboard:KeyboardState):Void
	{
		{ // Update mouse
			if (_tileToPaint != -1)
			{
				if (mouse.mouse1)
				{
					var tileOver:Point = {
						x: mouse.x / Std.parseInt(_gameVars.get("tileWidth")),
						y: mouse.y / Std.parseInt(_gameVars.get("tileHeight")) };

					var indexOver:Int = Utils.point_to_index(
						tileOver.x,
						tileOver.y,
						Std.parseInt(_gameVars.get("widthInTiles")));
					_tilemap[indexOver].paint(_tileToPaint);

					_renderer.draw_tile(_tilemapData, _tilemap[indexOver].type,
						Std.int(_tilemap[indexOver].x * Std.parseInt(_gameVars.get("tileWidth"))),
						Std.int(_tilemap[indexOver].y * Std.parseInt(_gameVars.get("tileHeight"))));
				}
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
			_renderer.draw_tile(_tilemapData, tile.type,
					Std.int(tile.x * Std.parseInt(_gameVars.get("tileWidth"))),
					Std.int(tile.y * Std.parseInt(_gameVars.get("tileHeight"))));
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