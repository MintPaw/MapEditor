package ;

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

typedef Point = {
	x:Float,
	y:Float
}