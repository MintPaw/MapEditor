package ;

import Utils.Point;

class EditorState
{
	private var _gameVars:Dynamic;
	private var _tilemap:Array<Tile>;

	private var _tileWidth:Float = 40;
	private var _tileHeight:Float = 40;
	private var _widthInTiles:Int = 32;
	private var _heightInTiles:Int = 18;
 
	public var renders:Array<TileRender>;

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

	public function update(time:Float, mouse:MouseState):Void
	{
		{ // Update render
			renders = [];

			for (tileIndex in 0..._tilemap.length)
			{
				var point:Point = Utils.index_to_point(tileIndex, _widthInTiles);
				renders.push({ x: point.x, y: point.y, width: _tileWidth, height: _tileHeight, colour: _tilemap[tileIndex].debug_colour });
			}
		}

		{ // Update mouse
			if (mouse.mouse1)
			{
				var tileOver:Point = { x: mouse.x / _tileWidth, y: mouse.y / _tileHeight };
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