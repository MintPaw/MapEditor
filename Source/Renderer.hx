package ;

// NOTE(jeru): Is platform dependant
import openfl.utils.ByteArray;
import openfl.Memory;

class Renderer
{
	private var _buffer:ByteArray;
	private var _bufferWidth:Int;

	public function new(buffer:ByteArray, bufferWidth:Float)
	{
		_bufferWidth = Std.int(bufferWidth);
		_buffer = buffer;
	}

	public function draw_rect(x:Int, y:Int, width:Int, height:Int, colour:UInt):Void
	{
		for (xi in x...x+width)
		{
			for (yi in y...y+height)
			{
				Memory.setI32((yi * _bufferWidth + xi) * 4, colour);
			}
		}
	}

}