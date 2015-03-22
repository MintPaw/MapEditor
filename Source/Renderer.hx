package ;

// NOTE(jeru): Is platform dependant
import openfl.utils.ByteArray;
import openfl.Memory;
import Utils.Tilemap;

class Renderer
{
	private var _bufferWidth:Int;

	public function new(bufferWidth:Float)
	{
		_bufferWidth = Std.int(bufferWidth);
	}

	public function draw_rect(x:Int, y:Int, width:Int, height:Int, colour:UInt):Void
	{
		for (xi in x...x+width)
		{
			for (yi in y...y+height)
			{
				draw_pixel(xi, yi, colour);
			}
		}
	}

	public function draw_tile(tilemap: Tilemap, tileIndex:Int, x: Float, y:Float):Void
	{
		var bytesPerPixel:Int = 4;
		tilemap.byteArrays[tileIndex].position = 0;

		for (byteIndex in 0...tilemap.byteArrays[tileIndex].length - 1)
		{
			//x: index % totalWidth, y: (index - index%totalWidth) / totalWidth
			//Std.int(Std.int(y)*totalWidth + Std.int(x));
			var realIndex:Int = Std.int(byteIndex % (tilemap.tileWidth * 4)) + Std.int(byteIndex / (tilemap.tileWidth*4)) * 1280 * 4;
			//trace(Std.int(byteIndex / tilemap.tileWidth) * 1280);

			//trace(Std.int(y * tilemap.tileWidth + x));
			//trace(tilemap.byteArrays[tileIndex].readByte());
			Memory.setByte(realIndex, tilemap.byteArrays[tileIndex].readByte());
			//draw_pixel(xi, yi, colour);
		}
	}

	public inline function draw_pixel(x:Int, y:Int, colour:UInt):Void
	{
		Memory.setI32((y * _bufferWidth + x) * 4, colour);
	}

}