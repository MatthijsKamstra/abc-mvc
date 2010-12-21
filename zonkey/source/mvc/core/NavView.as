package mvc.core {	import flash.geom.Point;	import mvc.utils.EasyButton;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	/**	 * @author Matthijs Kamstra aka [mck]	 */	public class NavView extends View {		//		public static const HORIZONTAL : String = "horizontal";		public static const VERTICAL : String = "vertical";		// horizontal or vertical		public static var direction : String = HORIZONTAL;		// private var _navController : Controller;		
		/**		 * Constructor		 */		public function NavView() {			// trace ( "+ NavView.NavView() - args: " + [  ] );			// visible = true; // override the default visible = false :D			// removeFromModel(); // not really necessary, but otherwise 'NavView' (this view) is added to the navigation			// _navController = new NavController(model, this);			// wait for the stage...			if (stage)				initialize(null);			else				addEventListener(Event.ADDED_TO_STAGE, initialize);		}		private function initialize(e : Event) : void {			removeEventListener(Event.ADDED_TO_STAGE, initialize);			setupNavigation();		}		/**		 * override Method used to register events.		 */		override public function registerEvents() : void {			// listen to all events, so we know if there is a View added			model.addEventListener(Model.ALL_EVENTS, onAllEventsHandler);		}		/**		 * Setup the navigation.		 */		private function setupNavigation() : void {			// every time a View is added to the model, the navigation is rebuild			// so first we remove the wrapper with the navigation items in there			if (getChildByName("wrapper") != null ) {				removeChild(getChildByName("wrapper"));			}			// build the navigation in a wrapper (wrapper sprite)			var wrapper : Sprite = new Sprite();			wrapper.name = "wrapper";			var array : Array = model.viewNameArray;			var previous : EasyButton;			for (var i : int = 0;i < array.length;i++) {				var viewName : String = array[i].toString();				var eb : EasyButton = new EasyButton(viewName);				eb.name = viewName;				var _offset : Number;				if (NavView.direction == NavView.HORIZONTAL) {					previous == null ? _offset = 0 : _offset = previous.width + previous.x + 5;					// to make sure that the nav is in a wrapper or on the root					var p : Point = localToGlobal(new Point(this.x, this.y));					// make sure that the navigation is not moving outside the stagewidth - 100 (<-- mrdoob stats profiler)										// for some reason the stage can be zero... so no problem now
					if (_offset >= (stage.stageWidth - p.x - 100) && stage.stageWidth != 0) {						eb.x = 0;						eb.y = previous.height + 5;					} else {						eb.x = _offset;						eb.y = previous == null ? 0 : previous.y;					}				} else {					eb.y = i * 35;				}				eb.addEventListener(MouseEvent.CLICK, onClickHandler);				// eb.addEventListener(MouseEvent.CLICK, _navController.onClickHandler);				if (model.currentEvent == viewName) {					eb.enabled = false;					eb.alpha = .5;				}				wrapper.addChild(eb);				previous = eb;				// remember previous easybutton			}			wrapper.x = wrapper.y = 20;			addChild(wrapper);		}		/**		 * Setup navigation after a view is added to the model		 */		private function onAllEventsHandler(event : Event) : void {			setupNavigation();		}		/**		 * Event handler for the Navigation.		 * 		 * @param event		mouse event.		 */		private function onClickHandler(e : MouseEvent) : void {			model.updateView(e.target.name);		}	}}