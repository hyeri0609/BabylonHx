package com.babylonhx.math;

/**
 * ...
 * @author Krtolica Vujadin
 */
/*
enum Space = {
	LOCAL: 0,
	WORLD: 1
}*/
enum Space {
    LOCAL;
    WORLD;
}

@:expose('BABYLON.Axis') class Axis {
	
	public static var X:Vector3 = new Vector3(1, 0, 0);
	public static var Y:Vector3 = new Vector3(0, 1, 0);
	public static var Z:Vector3 = new Vector3(0, 0, 1);
	
}