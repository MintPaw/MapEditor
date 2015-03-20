package ;

class Tile
{
	public static var DEBUG_COLOURS:Array<UInt> = [
		0xFFFFFFFF,
		0x000000FF,
		0x0000FFFF,
		0x00FF00FF,
		0xFF0000FF,
		0x00FFFFFF,
		0xFF00FFFF,
		0xFFFF00FF
	];

	public var x:Float;
	public var y:Float;
	public var type:Int;
	public var debugColour:UInt;

	public function new(x:Float = 0, y:Float = 0, type:Int = 0)
	{
		this.x = x;
		this.y = y;
		paint(type);
	}

	public function paint(type):Void
	{
		this.type = type;	
		debugColour = DEBUG_COLOURS[type];
	}

	public function toString():String
	{
		return x + "," + y + "," + type;
	}

	public function fromString(s:String):Void
	{
		var parts:Array<String> = s.split(",");
		x = Std.parseFloat(parts[0]);
		y = Std.parseFloat(parts[1]);
		paint(Std.parseInt(parts[2]));
	}
}