package ;

import openfl.utils.ByteArray;

class Utils
{
	public static function index_to_point(index:Int, totalWidth:Float):Point
	{
		return { x: index % totalWidth, y: (index - index%totalWidth) / totalWidth };
	}

	public static function point_to_index(x:Float, y:Float, totalWidth:Float):Int
	{
		return Std.int(Std.int(y)*totalWidth + Std.int(x));
	}

	public static function round(x:Float, toTheNearest:Float = 1):Int
	{
		return Std.int(Math.round(x / toTheNearest) *  toTheNearest);
	}
}

typedef ImageData = {
	byteArray:ByteArray,
	width:Int,
	height:Int
}

typedef Point = {
	x:Float,
	y:Float
}

typedef Tilemap = {
	byteArrays:Array<ByteArray>,
	tileWidth:Int,
	tileHeight:Int
}

typedef TextField = {
	x:Float,
	y:Float,
	width:Float,
	height:Float,
	text:String,
	bgColour:Int
}