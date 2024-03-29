package mvc.core {
	import net.hires.debug.Stats;

	import nl.noiselibrary.core.NoiseContextMenu;
	import nl.noiselibrary.utils.AlignUtil;
	import nl.noiselibrary.utils.CacheBuster;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;

	public class Application extends MovieClip {
		
		private var _flashVars : Object = null;
		
		public var STAGE_WIDTH : int = 0;
		public var STAGE_HEIGHT : int = 0;
		
		public static var IS_BROWSER : Boolean;
		public static var IS_ONLINE : Boolean;
		public static var IS_DEBUG : Boolean;
		
		protected static var _instance : Application;
		
		private var stats : Stats;
		
		public var model : Model = Model.getInstance();

		/**		 * constructor		 */
		public function Application() {
			// create a static var of this class
			_instance = this;
			// check the stage
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		// ////////////////////////////////////// sort of singleton // //////////////////////////////////////
		public static function get instance() : Application {
			return _instance;
		}

		public static function getInstance() : Application {
			return _instance;
		}

		// ////////////////////////////////////// check stage AND stageWidth/stageHeight // //////////////////////////////////////
		protected function onAddedToStage(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (stage.stageWidth == 0 || stage.stageHeight == 0) {
				addEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
			} else {
				_init();
			}
		}

		private function onWaitForWidthAndHeight(event : Event) : void {
			if (stage.stageWidth > 0 && stage.stageHeight > 0) {
				removeEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
				_init();
			}
		}

		// ////////////////////////////////////// default start-up stuff // //////////////////////////////////////
		private function _init() : void {
			if (!STAGE_WIDTH)
				STAGE_WIDTH = stage.stageWidth;
				
			if (!STAGE_HEIGHT)
				STAGE_HEIGHT = stage.stageHeight;
				
			CacheBuster.isOnline = (stage.loaderInfo.url.indexOf("http") == 0);
			
			IS_ONLINE = (stage.loaderInfo.url.indexOf("http") == 0);
			IS_BROWSER = (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn");
			IS_DEBUG = (Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External" || stage.loaderInfo.url.indexOf("http") != 0);
			
			if (IS_DEBUG || getBoolean('debug')) {
				// delay stats add, to make sure it will be placed on top
				var timer : Timer = new Timer(250, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, addStatsHandler);
				timer.start();
			}
			// get flashvars from html document
			flashVars = stage.loaderInfo.parameters;
			
			// start collection of startup commands
			setupStage();
			setupDomainAccess();
			setupContextMenu();
			setupConfig();
			setupApplication();
			
			// because I like init as a starting point
			init();
		}

		private function addStatsHandler(event : TimerEvent) : void {
			stats = new Stats() ;
			stats.name = 'Stats';
			addChild(stats);
			stats.x = stage.stageWidth - stats.width;
			
			// move to the right
			new AlignUtil(stats, AlignUtil.TOP_RIGHT, null, true);
		}

		// ////////////////////////////////////// custom start-up functions // //////////////////////////////////////
		protected function setupStage() : void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		protected function setupDomainAccess() : void {			// Allow domains here
		}

		protected function setupContextMenu() : void {
			new NoiseContextMenu(Sprite(stage.getChildAt(0)));
			if (IS_DEBUG || getBoolean('debug')) {
				new Version(Sprite(stage.getChildAt(0)));
			}
		}

		protected function setupConfig() : void {			// Load the config file here, like config.xml or navigation.xml
		}

		protected function setupStyles() : void {			// Load the style sheet
		}

		protected function setupApplication() : void {			// This is where you setup the application
		}

		// yep		protected function init() : void {
			trace("!! OVERRIDE !! :: Application.init :: override protected function init():void {}");
		}

		// ////////////////////////////////////// flashvars // //////////////////////////////////////
		/** 		 * get the flashVar defined in html		 * 		 * @example		var _xmlPath:String = NoiseMain.instance.getFlashVar("xml");		 *				trace( "_xmlPath : " + _xmlPath );		 * @param	inParam		var name 		 * @return				value defined or null (no value defined)		 */
		public function getFlashVar(inParam : String) : String {
			return stage.loaderInfo.parameters[inParam];
		}

		public function setFlashVar(inParam : String, inValue : String) : void {
			stage.loaderInfo.parameters[inParam] = inValue;
		}

		public function get flashVars() : Object {
			return _flashVars;
		}

		public function set flashVars(inObj : Object) : void {
			_flashVars = inObj;
		}

		/**		 * parse boolean flashvar		 */
		protected function getBoolean(inParam : String) : Boolean {
			return stage.loaderInfo.parameters[inParam] == 'true' || stage.loaderInfo.parameters[inParam] == '1';
		}

		/**		 * set the stats ontop (usefull if the app has a fullscreen background)		 * @example		NoiseMain.instance.placeStatsOnTop();		 */
		public function placeStatsOnTop() : void {
			if (IS_DEBUG || getBoolean('debug'))
				this.setChildIndex(stats, this.numChildren - 1);
		}

		// //////////////////////////////////////  // //////////////////////////////////////
		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}