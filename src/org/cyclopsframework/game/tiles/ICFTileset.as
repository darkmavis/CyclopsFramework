package org.cyclopsframework.game.tiles
{
	import flash.display.BitmapData;

	public interface ICFTileset
	{	
		function get tileWidth():int;
		function get tileHeight():int;
		function get numTiles():int;
		function getTile(index:int):BitmapData;
	}
}