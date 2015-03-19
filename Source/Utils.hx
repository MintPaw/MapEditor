package ;

import openfl.geom.Point;

class Utils
{
	public static function index_to_point(index:Int, totalWidth:Float):Point
	{
		return new Point(index%totalWidth, (index - index%totalWidth) / totalWidth);
	}
}