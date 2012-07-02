package org.cyclopsframework.starling.tiles
{
	public interface ICFTileDataSource
	{
		function readTileIndex(x:int, y:int):int;
		function writeTileIndex(x:int, y:int, tileIndex:int):void;
	}
}