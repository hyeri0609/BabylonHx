package com.babylonhx.loading.ctm;

import haxe.io.BytesInput;

import lime.utils.Float32Array;
import lime.utils.UInt32Array;

/**
 * @author Krtolica Vujadin
 */
interface ICTMReader {
	
	function read(stream:BytesInput, body:CTMFileBody):Void;
	function readIndices(stream:BytesInput, indices:UInt32Array):Void;
	function readVertices(stream:BytesInput, vertices:Float32Array):Void;
	function readNormals(stream:BytesInput, normals:Float32Array):Void;
	function readUVMaps(stream:BytesInput, uvMaps:Array<CTMUVMap>):Void;
	function readAttrMaps(stream:BytesInput, attrMaps:Array<CTMAttrMap>):Void;
  
}
