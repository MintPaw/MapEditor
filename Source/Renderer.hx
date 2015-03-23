package ;

// NOTE(jeru): Is platform dependant
import openfl.utils.ByteArray;
import openfl.Memory;
import Utils.Tilemap;
import Utils.TextField;

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

	public function draw_tile(tilemap: Tilemap, tileIndex:Int, x: Int, y:Int):Void
	{
		tilemap.byteArrays[tileIndex].position = 0;

		draw_byte_array(tilemap.byteArrays[tileIndex], x, y, tilemap.tileWidth, tilemap.tileHeight);
		// for (byteIndex in 0...tilemap.byteArrays[tileIndex].length - 1)
		// {
		// 	var xAt:Int = Std.int(byteIndex % (tilemap.tileWidth * 4) + x * 4);
		// 	var yAt:Int = Std.int(byteIndex / (tilemap.tileWidth * 4) + y);

		// 	var realIndex:Int = yAt * _bufferWidth * 4 + xAt;

		// 	Memory.setByte(realIndex, tilemap.byteArrays[tileIndex].readByte());
		// }
	}

	public function draw_byte_array(byteArray:ByteArray, x:Int, y:Int, width:Int, height:Int):Void
	{
		byteArray.position = 0;

		for (byteIndex in 0...byteArray.length - 1)
		{
			var xAt:Int = Std.int(byteIndex % (width * 4) + x * 4);
			var yAt:Int = Std.int(byteIndex / (height * 4) + y);

			var realIndex:Int = yAt * _bufferWidth * 4 + xAt;

			Memory.setByte(realIndex, byteArray.readByte());
		}
	}

	public function draw_text_field(textField:TextField):Void
	{

	}

	public inline function draw_pixel(x:Int, y:Int, colour:UInt):Void
	{
		Memory.setI32((y * _bufferWidth + x) * 4, colour);
	}

}