package com.babylonhx.mesh;

import lime.utils.Float32Array;
import lime.utils.Int32Array;

/**
 * @author Krtolica Vujadin
 */

@:expose('BABYLON.IGetSetVerticesData') interface IGetSetVerticesData {
	
	function isVerticesDataPresent(kind:String):Bool;
	function getVerticesData(kind:String, copyWhenShared:Bool = false, forceCopy:Bool = false):Float32Array;
	function getIndices(copyWhenShared:Bool = false):Int32Array;
	function setVerticesData(kind:String, data:Float32Array, updatable:Bool = false, ?stride:Int):Void;
	function updateVerticesData(kind:String, data:Float32Array, updateExtends:Bool = false, makeItUnique:Bool = false):Void;
	function setIndices(indices:Int32Array, totalVertices:Int = -1):Void;
	
}
