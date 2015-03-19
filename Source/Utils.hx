package ;

class Utils
{
	public static function index_to_point(index:Int, totalWidth:Float):Point
	{
		return { x: index % totalWidth, y: (index - index%totalWidth) / totalWidth };
	}
}

typedef Point = {
	x:Float,
	y:Float
}