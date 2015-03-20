package ;

import Utils.Point;

class EditorState
{
	public var renders:Array<TileRender>;

	private var _gameVars:Dynamic;
	private var _tilemap:Array<Tile>;

	private var _tileWidth:Float = 40;
	private var _tileHeight:Float = 40;
	private var _widthInTiles:Int = 32;
	private var _heightInTiles:Int = 18;

	private var _tileToPaint:Int = 1;

	public function new(gameVars:Dynamic)
	{
		_gameVars = gameVars;

		generate_tilemap();
	}

	private function generate_tilemap():Void
	{
		_tilemap = [];

		for (tileY in 0..._heightInTiles)
		{
			for (tileX in 0..._widthInTiles)
			{
				_tilemap.push(new Tile(tileX, tileY, 0));
			}
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
			}
		}

		{ // Update Keyboard
			// NOTE(jeru): These are not ascii
			if (keyboard.keysJustDown[188]) _tileToPaint = _tileToPaint - 1 >= 0 ? _tileToPaint - 1: _tileToPaint;
			if (keyboard.keysJustDown[190]) _tileToPaint = _tileToPaint + 1;
		}

		{ // Update render
			renders = [];

			for (tileIndex in 0..._tilemap.length)
			{
				var point:Point = Utils.index_to_point(tileIndex, _widthInTiles);
				renders.push({ x: point.x * _tileWidth, y: point.y * _tileHeight, width: _tileWidth, height: _tileHeight, colour: _tilemap[tileIndex].debug_colour });
			}
		}
	}
}

typedef TileRender = {
	x:Float,
	y:Float,
	width:Float,
	height:Float,
	colour:Int
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