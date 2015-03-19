package ;

class EditorState
{
	private var _editorVars:Dynamic;
	private var _tilemap:Array<Tile>;

	public function new(editorVars:Dynamic)
	{
		_editorVars = editorVars;

		generate_tilemap();
	}

	private function generate_tilemap()
	{
		_tilemap = [];

		for (tileY in 0..._editorVars.heightInTiles)
		{
			for (tileX in 0..._editorVars.widthInTiles)
			{
				_tilemap.push(new Tile(tileX, tileY, 0));
			}
		}
	}

	public function get_tilemap():Array<Tile>
	{
		return _tilemap;
	}
}