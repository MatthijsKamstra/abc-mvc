package mvc.core {
	import mvc.utils.ClassUtil;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;

	/**
	 * every movieclip that want to reacte like a "View" needs labels with these names:
	 * 		>> show
	 * 		>> hide
	 * 		>> onShowFinished
	 * 		>> onHideFinished
	 * 		
	 * otherwise it will react like a "normal" Movieclip
	 */
	public class View extends MovieClip {
		// default frames for the show and hide
		private static var SHOW_FRAME : int = -1;
		private static var HIDE_FRAME : int = -1;
		private static var SHOW_FINISHED_FRAME : int = -1;
		private static var HIDE_FINISHED_FRAME : int = -1;
		// abc-mvc stuff
		private var _model : Model;
		private var _controller : Controller = null;
		private var _type : String;
		private var _viewName : String;
		// check if there is a timeline (defaul:t no timeline == 1 frame)
		private var _isTimeline : Boolean = false;
		// check the labels: default values are false
		private var _labelsNeeded : Object = {show:false, hide:false, onShowFinished:false, onHideFinished:false};
		// misc
		private var _target : MovieClip;
		private var _mouseBlock : Sprite;
		// debugging (default no debuggin)
		private static var _isDebugMode : Boolean = false;
		// auto stuff
		private var _isAutoRemove : Boolean = false;
		private var _isAutoHide : Boolean = false;
		// default the buttons are not clickable till animation is finished
		private var _isAutoBlock : Boolean = true;
		// view styles
		public static const VIEW_POPUP : String = "popup";
		public static const VIEW_STATIC : String = "static";
		public static const VIEW_ANIMATED : String = "animated";
		public static const VIEW_DEFAULT : String = "default";

		private var isNotModel : Boolean = false;
		/**		 * constructor		 * 		 * @param inController	specific controller use for this view (default: null)		 */
		public function View(inController : Controller = null, inType : String = VIEW_DEFAULT) {
			// start hidden
			visible = false;

			// makes sure if it has more frames it stops at the first frame
			stop();

			// get the rool
			_target = this;

			// get singleton Model
			_model = Model.getInstance();

			// If we have a controller set one.
			if( _controller != null )
				_controller = inController;

			// get viewname (classname)
			_viewName = ClassUtil.typeOf(this);

			// set type
			_type = inType;

			// stage
			if (stage)
				initialize(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}

		/**
		 * check stuff related to the stage
		 */
		private function initialize(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, initialize);

			if (name.indexOf("instance") != -1){
				name = ClassUtil.typeOf(this);
			}

			// check if current timeline has the correct labels
			getTarget();

			if (_type == View.VIEW_DEFAULT) {
				// trace(":: use View.VIEW_DEFAULT - " + _target);
				if (containsCorrectLabels(_target)) {
					// trace(":: -- corrrect labels in: " + _target);
					_type = VIEW_ANIMATED;
				} else {
					// trace(":: -- niet de correcte labels in: " + _target);
					_type = VIEW_STATIC;
					visible = true;
				}
			}

			// trace('_target: ' + (_target)+ ' || _type: ' + (_type));	
				
			// auto add the animated views to the Model
			if(_type == View.VIEW_ANIMATED && !isNotModel) {
				_model.viewNameArray = _viewName;
			}

			// Register events.
			registerEvents();

			// TODO: [mck] popup werkt nog niet
			// auto add the popup view to the Model
			if(_type == View.VIEW_POPUP)
				_model.popupNameArray = _viewName;

			// add blocker (so buttons in the movie are not clickable during animation)
			mouseBlocker();

			// use this when you want to do something which needs a stage ()
			stageReady();
		}

		/*		* override this function when a view needs a stage
		 * like 		stage.addEventListener (bla, bla);
		 * 
		 * @example 		override protected function stageReady():void {}		*/
		protected function stageReady():void {
		}

		/**
		 * it's possible to have a embedded movieclip as target and use that timeline as animation
		 */
		private function getTarget():void {
			if (containsCorrectLabels(this)) {
				_target = this;
				_isTimeline = true;
				stop();	// is already done, but what the hack
			} else {
				// is there an add to this timeline that is an movieclip?
				for (var i : uint = 0;i < this.numChildren;i++) {
					var _mc : MovieClip = this.getChildAt(i) as MovieClip;
					if (_mc && _mc.totalFrames > 1) {
						if (containsCorrectLabels(_mc)) {
							_target = _mc;
							_isTimeline = true;
							_mc.stop();	// stop this timeline
						}
					}
				}
			}
		}

		/**
		 * check if the labels are here
		 * 	 	>> show
		 * 		>> hide
		 * 		>> onShowFinished
		 * 		>> onHideFinished
		 */
		private function containsCorrectLabels(inMovieclip : MovieClip) : Boolean {
			var labels : Array = inMovieclip.currentLabels;
			for (var i : uint = 0;i < labels.length;i++) {
				var label : FrameLabel = labels[i];
				switch(label.name) {
					case "show":
						// trace("## show");
						SHOW_FRAME = label.frame;
						_labelsNeeded.show = true;
						break;
					case "hide":
						// trace("## hide");
						HIDE_FRAME = label.frame;
						_labelsNeeded.hide = true;
						break;
					case "onShowFinished":
						// trace("## onShowFinished");
						SHOW_FINISHED_FRAME = label.frame;
						_labelsNeeded.onShowFinished = true;
						break;
					case "onHideFinished":
						// trace("## onHideFinished");
						HIDE_FINISHED_FRAME = label.frame;
						_labelsNeeded.onHideFinished = true;
						break;
				}
			}

			// let's check if all labels are present
			var errorString : String = "";
			for (var lb:String in _labelsNeeded) {
				if (!_labelsNeeded[lb])
					errorString += "\t\tmissing label: " + lb + "\n";
			}
			if (errorString.length > 0)
				if (isDebugMode)
					trace(this + " --->\n" + errorString);
			// I recon that you need all labels, so they need all to be there
			return (errorString.length == 0);
		}

		/**		 * automaticly the view is added to the model.		 * If that is not wise (for example with navigation)		 * you should use this function to remove it from the model-list
		 * 
		 * 		 */
		public function removeFromModel() : void {
			// TODO: [mck] fix that it can be done in the constructor and not only in the onStageAdd
			// make sure that nothing else is removed...
			isNotModel = true;
			_model.removeViewNameFromArray();
			// TODO: [mck] perhaps not using array.pop but a named array..???
		}

		public function registerEvents() : void {
			// Abstract.
			model.addEventListener(_viewName, show);
			model.addEventListener(( _viewName + Model.CLEAR ), hide);
		}

		public function unRegisterEvents() : void {
			// Abstract.
			model.removeEventListener(_viewName, show);
			model.removeEventListener(( _viewName + Model.CLEAR ), hide);
		}

		private function onTargetFrameHandler(event : Event) : void {
			var _frameLabel : String = _target.currentLabel;
			var _frameNumber : int = _target.currentFrame;
			var evt : ViewEvent;
			switch (_frameLabel) {
				case 'show':
					if (_frameNumber == View.SHOW_FRAME){										
						if (isDebugMode)trace("::---> " + toString() + " :: onShowFinished");
						
						evt = new ViewEvent(ViewEvent.ON_SHOW, this);
						dispatchEvent(evt);
					}
					break;
				case 'onShowFinished':
					// trace('--->| onShowFinished ' + toString());
					_frameNumber == View.SHOW_FINISHED_FRAME;
					
					evt = new ViewEvent(ViewEvent.ON_SHOW_FINISHED, this);
					dispatchEvent(evt);
					
					if (isDebugMode)trace("::--->| " + toString() + " :: onShowFinished");
					
					_target.removeEventListener(Event.ENTER_FRAME, onTargetFrameHandler);
					_target.stop();
					
					// TODO: [mck] mouseblock needs to be on top of everything
					if (isAutoBlock)
						_mouseBlock.visible = false;
					break;
				case 'hide':
					if (_frameNumber == View.HIDE_FRAME) {
						
						if (isDebugMode) trace("::|<--- " + toString() + " :: onHide");
						
						evt = new ViewEvent(ViewEvent.ON_HIDE, this);
						dispatchEvent(evt);
					}
					break;
				case 'onHideFinished':
					// trace('--- onHideFinished');
					// trace('|<--- onHideFinished ' + toString());
					
					_frameNumber == View.HIDE_FINISHED_FRAME;

					evt = new ViewEvent(ViewEvent.ON_HIDE_FINISHED, this);
					dispatchEvent(evt);
					
					if (isDebugMode) trace("::|<--- " + toString() + " :: onHideFinished");
					
					_target.removeEventListener(Event.ENTER_FRAME, onTargetFrameHandler);
					_target.stop();
					visible = false;
					destroy();
					
					// TODO: [mck] mouseblock needs to be on top of everything					if (isAutoBlock)
						_mouseBlock.visible = false;
					if (isAutoRemove)
						this.parent.removeChild(this);
					break;
				default:
					// just in case something goes wrong
					_target.removeEventListener(Event.ENTER_FRAME, onTargetFrameHandler);
					// trace("case '" + value + "':\r\ttrace ('--- " + value + "');\r\tbreak;");
			}
		}

		/**		 * show this view		 * default: visibility = true		 */
		public function show(event : Event = null) : void {
			// override this function to use your custom show (tweens/animations)
			// override public function show( event : Event ) : void {}
			visible = true;
			// 1 frame movieclips and timeline need to be visible
			if (isDebugMode)
				trace(":: " + toString() + " :: show");
				
			if (isAutoBlock && _isTimeline) {
				if (isDebugMode)
					_mouseBlock.alpha = 0.5;
				
				_mouseBlock.visible = true;
			}
			if (_isTimeline) {
				_target.addEventListener(Event.ENTER_FRAME, onTargetFrameHandler);
				_target.gotoAndPlay("show");
			} else {
			}
		}

		/**		 * hide this view		 * default: visibility = false		 */
		public function hide(event : Event = null) : void {
			// override this function to use your custom hide (tweens/animations)
			// override public function hide( event : Event ) : void {}
			if (isDebugMode){
				trace(":: " + getQualifiedClassName(this) + " :: hide");
			}
			
			if (isAutoBlock && _isTimeline) {
				if (isDebugMode){
					_mouseBlock.alpha = 0.5;
				}
				_mouseBlock.visible = true;
			}
			if (_isTimeline) {
				_target.addEventListener(Event.ENTER_FRAME, onTargetFrameHandler);
				_target.gotoAndPlay("hide");
			} else {
				// no timeline!!
				visible = false;
				destroy();
			}
		}

		public function destroy() : void {
			// setTimeout(nextEvent, 50); // [mck] : original code
			// TODO: [mck] this works, but what why is it here?
			if (_isTimeline) {
				nextEvent();
			} else {
				// delay is 1 millisecond
				setTimeout(nextEvent, 1);
			}
		}

		private function nextEvent() : void {
			_model.sendInternalEvent(_model.currentEvent);
		}

		// blocker
		private function mouseBlocker() : void {
			_mouseBlock = new Sprite();
			_mouseBlock.graphics.clear();
			_mouseBlock.graphics.beginFill(0xff3333, 1);
			_mouseBlock.graphics.drawRect(0, 0, this.width, this.height);
			_mouseBlock.graphics.endFill();
			_mouseBlock.visible = false;
			_mouseBlock.alpha = 0;
			this.addChild(_mouseBlock);
		}

		////////////////////////////////////////  getter/setter ////////////////////////////////////////             
		public function set model(inModel : Model) : void {
			_model = inModel;
		}

		public function get model() : Model {
			return _model;
		}

		public function set controller(inController : Controller) : void {
			_controller = inController;
		}

		public function get controller() : Controller {
			return _controller;
		}

		// change debug mode
		public static function get isDebugMode() : Boolean {
			return _isDebugMode;
		}

		public static function set isDebugMode(isDebugMode : Boolean) : void {
			_isDebugMode = isDebugMode;
		}

		// change autoRemove mode
		public function get isAutoRemove() : Boolean {
			return _isAutoRemove;
		}

		public function set isAutoRemove(value : Boolean) : void {
			_isAutoRemove = value;
		}

		// TODO: [mck] // auto hide (WERKT NIET)
		public function get isAutoHide() : Boolean {
			return _isAutoHide;
		}

		// TODO: [mck] // auto hide (WERKT NIET)
		public function set isAutoHide(value : Boolean) : void {
			_isAutoHide = value;
		}

		// auto block
		public function get isAutoBlock() : Boolean {
			return _isAutoBlock;
		}

		public function set isAutoBlock(value : Boolean) : void {
			_isAutoBlock = value;
		}

		// //////////////////////////////////////  // ////////////////////// // // // //////////
		public override function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}