package com.babylonhx.actions;

/**
 * ...
 * @author Krtolica Vujadin
 */

@:expose('BABYLON.Action') class Action {
	
	public var trigger:Int;
	public var _actionManager:ActionManager;

	private var _nextActiveAction:Action;
	private var _child:Action;
	private var _condition:Condition;
	private var _triggerParameter:Dynamic;
	

	public function new(triggerOptions:Dynamic, ?condition:Condition) {
		if (Reflect.getProperty(triggerOptions, "parameter") != null) {
			this.trigger = Reflect.getProperty(triggerOptions, "trigger");
			this._triggerParameter = Reflect.getProperty(triggerOptions, "parameter");
		} else {
			this.trigger = triggerOptions;
		}

		this._nextActiveAction = this;
		this._condition = condition;
	}

	// Methods
	public function _prepare():Void {
		
	}

	public function getTriggerParameter():Dynamic {
		return this._triggerParameter;
	}

	public function _executeCurrent(evt:ActionEvent):Void {
		if (this._condition != null) {
			var currentRenderId = this._actionManager.getScene().getRenderId();

			// We cache the current evaluation for the current frame
			if (this._condition._evaluationId == currentRenderId) {
				if (!this._condition._currentResult) {
					return;
				}
			} else {
				this._condition._evaluationId = currentRenderId;

				if (!this._condition.isValid()) {
					this._condition._currentResult = false;
					return;
				}

				this._condition._currentResult = true;
			}
		}

		this._nextActiveAction.execute(evt);

		if (this._nextActiveAction._child != null) {

			if (this._nextActiveAction._child._actionManager == null) {
				this._nextActiveAction._child._actionManager = this._actionManager;
			}

			this._nextActiveAction = this._nextActiveAction._child;
		} else {
			this._nextActiveAction = this;
		}
	}

	public function execute(?evt:ActionEvent):Void {

	}

	public function then(action:Action):Action {
		this._child = action;

		action._actionManager = this._actionManager;
		action._prepare();

		return action;
	}

	public function _getProperty(propertyPath:String):String {
		return this._actionManager._getProperty(propertyPath);
	}

	public function _getEffectiveTarget(target:Dynamic, propertyPath:String):Dynamic {
		return this._actionManager._getEffectiveTarget(target, propertyPath);
	}
	
}
