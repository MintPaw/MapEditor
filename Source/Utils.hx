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
}

typedef Point = {
	x:Float,
	y:Float
}