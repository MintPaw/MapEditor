package ;

import openfl.utils.ByteArray;

class Utils
{
	public static var image_to_split_byte_arrays:Dynamic;
	
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

	public static function get_font(name:String, imageData:ImageData, glyphWidth:Int, glyphHeight:Int):Font
	{
		var font:Font = { name: name, glyphWidth: glyphWidth, glyphHeight: glyphHeight, glyphs: 0, byteArrays: [] };
		font.byteArrays = image_to_split_byte_arrays(imageData, glyphWidth, glyphHeight);

		return font;
	}

	public static function image_to_tilemap(imageData: Utils.ImageData, tileWidth:Int, tileHeight:Int):Tilemap
	{
		var byteArrays:Array<ByteArray> = image_to_split_byte_arrays(imageData, tileWidth, tileHeight);

		return { byteArrays: byteArrays, tileWidth: tileWidth, tileHeight: tileHeight };
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
	bgColour:Int,
	fontName:String
}

typedef Font = {
	name:String,
	glyphWidth:Int,
	glyphHeight:Float,
	glyphs:Int,
	byteArrays:Array<ByteArray>
}