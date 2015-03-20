package ;

class Tile
{
	public static var DEBUG_COLOURS:Array<UInt> = [
		0xFFFFFF,
		0x000000,
		0xFF0000,
		0x00FF00,
		0x0000FF,
		0xFFFF00,
		0xFF00FF,
		0x00FFFF
	];

	public var x:Float;
	public var y:Float;
	public var type:Int;
	public var debug_colour:UInt;

	public function new(x:Float, y:Float, type:Int)
	{
		this.x = x;
		this.y = y;
		this.type = type;
		debug_colour = DEBUG_COLOURS[type];
	}
}