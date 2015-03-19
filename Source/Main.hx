package ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Main extends Sprite
{
	var _editorState:EditorState;
	var _editorVars:Dynamic;
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
		
		_editorVars = 
		{
			width: stage.stageWidth,
			height: stage.stageHeight,
			tileWidth: 40,
			tileHeight: 40,
			widthInTiles: 32,
			heightInTiles: 18
		};

		_editorState = new EditorState(_editorVars);

		_canvasData = new BitmapData(_editorVars.width, _editorVars.height, false);

		_canvas = new Bitmap(_canvasData);
		addChild(_canvas);

		addEventListener(Event.ENTER_FRAME, update);
	}

	private function update(e:Event):Void
	{
		var _tiles:Array<Tile> = _editorState.get_tilemap();

		for (tileIndex in 0..._tiles.length)
		{
			var point:Point = Utils.index_to_point(tileIndex, _editorVars.widthInTiles);
			draw_rectangle(point.x * _editorVars.tileWidth, point.y * _editorVars.tileHeight, _editorVars.tileWidth, _editorVars.tileHeight, 0xFF0000);
		}
	}

	private function draw_rectangle(x:Float, y:Float, width:Float, height:Float, colour:UInt):Void
	{
		_canvasData.fillRect(new Rectangle(x, y, width, height), colour);
	}
}