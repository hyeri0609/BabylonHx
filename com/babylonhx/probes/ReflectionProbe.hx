package com.babylonhx.probes;

import com.babylonhx.Scene;
import com.babylonhx.math.Matrix;
import com.babylonhx.math.Vector3;
import com.babylonhx.mesh.AbstractMesh;
import com.babylonhx.tools.EventState;
import com.babylonhx.materials.textures.RenderTargetTexture;


/**
 * ...
 * @author Krtolica Vujadin
 */
@:expose('BABYLON.ReflectionProbe') class ReflectionProbe {
	
	private var _scene:Scene;
	private var _renderTargetTexture:RenderTargetTexture;
	private var _projectionMatrix:Matrix;
	private var _viewMatrix:Matrix = Matrix.Identity();
	private var _target:Vector3 = Vector3.Zero();
	private var _add:Vector3 = Vector3.Zero();
	private var _attachedMesh:AbstractMesh;

	public var invertYAxis:Bool = false;
	public var position:Vector3 = Vector3.Zero();
	
	public var name:String;
	public var size:Int;
	

	public function new(name:String, size:Int, scene:Scene, generateMipMaps:Bool = true) {
		this._scene = scene;
		
		this._scene.reflectionProbes.push(this);
		
		this._renderTargetTexture = new RenderTargetTexture(name, size, scene, generateMipMaps, true, Engine.TEXTURETYPE_UNSIGNED_INT, true);
		
		this._renderTargetTexture.onBeforeRenderObservable.add(function(faceIndex:Int, _) {
			switch (faceIndex) {
				case 0:
					this._add.copyFromFloats(1, 0, 0);
					
				case 1:
					this._add.copyFromFloats(-1, 0, 0);
					
				case 2:
					this._add.copyFromFloats(0, this.invertYAxis ? 1 : -1, 0);
					
				case 3:
					this._add.copyFromFloats(0, this.invertYAxis ? -1 : 1, 0);
					
				case 4:
					this._add.copyFromFloats(0, 0, 1);
					
				case 5:
					this._add.copyFromFloats(0, 0, -1);					
			}
			
			if (this._attachedMesh != null) {
				this.position.copyFrom(this._attachedMesh.getAbsolutePosition());
			}
			
			this.position.addToRef(this._add, this._target);
			
			Matrix.LookAtLHToRef(this.position, this._target, Vector3.Up(), this._viewMatrix);
			
			scene.setTransformMatrix(this._viewMatrix, this._projectionMatrix);
		});
		
		this._renderTargetTexture.onAfterUnbindObservable.add(function(_, _) {
			scene.updateTransformMatrix(true);
		});
		
		this._projectionMatrix = Matrix.PerspectiveFovLH(Math.PI / 2, 1, scene.activeCamera.minZ, scene.activeCamera.maxZ);
	}
	
	public var samples(get, set):Int;
	inline private function get_samples():Int {
		return this._renderTargetTexture.samples;
	}
	private function set_samples(value:Int):Int {
		return this._renderTargetTexture.samples = value;
	}
	
	public var refreshRate(get, set):Int;
	inline private function get_refreshRate():Int {
		return this._renderTargetTexture.refreshRate;
	}
	private function set_refreshRate(value:Int):Int {
		this._renderTargetTexture.refreshRate = value;
		
		return value;
	}

	public function getScene():Scene {
		return this._scene;
	}

	public var cubeTexture(get, never):RenderTargetTexture;
	private function get_cubeTexture():RenderTargetTexture {
		return this._renderTargetTexture;
	}

	public var renderList(get, never):Array<AbstractMesh>;
	private function get_renderList():Array<AbstractMesh> {
		return this._renderTargetTexture.renderList;
	}

	public function attachToMesh(mesh:AbstractMesh) {
		this._attachedMesh = mesh;
	}
	
	/**
	 * Specifies whether or not the stencil and depth buffer are cleared between two rendering groups.
	 * 
	 * @param renderingGroupId The rendering group id corresponding to its index
	 * @param autoClearDepthStencil Automatically clears depth and stencil between groups if true.
	 */
	public function setRenderingAutoClearDepthStencil(renderingGroupId:Int, autoClearDepthStencil:Bool) {
		this._renderTargetTexture.setRenderingAutoClearDepthStencil(renderingGroupId, autoClearDepthStencil);
	}
	
	public function dispose() {
		var index = this._scene.reflectionProbes.indexOf(this);
		
		if (index != -1) {
			// Remove from the scene if found 
			this._scene.reflectionProbes.splice(index, 1);
		}  
		
		if (this._renderTargetTexture != null) {
            this._renderTargetTexture.dispose();
            this._renderTargetTexture = null;
        }
	}
	
}
