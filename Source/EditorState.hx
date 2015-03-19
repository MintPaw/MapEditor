package ;

class EditorState
{
	private var _gameVars:Dynamic;
	private var _tilemap:Array<Tile>;

	private var _widthInTiles:Int = 32;
	private var _heightInTiles:Int = 18;

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

	public function update(time:Float):Array<TileRender>
	{
		var renders:Array<TileRender> = [];

		for (tileIndex in 0..._tilemap.length)
		{
			var point:Utils.Point = Utils.index_to_point(tileIndex, _widthInTiles);
			renders.push({ x: point.x, y: point.y, width: _gameVars.width, height: _gameVars.height, colour: 0xFF0000 });
		}

		return renders;
	}
}

typedef TileRender = {
	x:Float,
	y:Float,
	width:Float,
	height:Float,
	colour:Int
}