package mvc.core {	import flash.events.Event;	import flash.events.EventDispatcher;	public class Model extends EventDispatcher {				// singleton stuff		private static var _instance : Model;		private static var _allowInstantiation : Boolean;		// events		public static const ALL_EVENTS : String = "onAllEvents";		public static const CLEAR : String = "_destroy";		// vars		private var _data : * = null;
		private var _event : String = "";		private var _viewNameArray : Array = [];				// singleton		public static function getInstance() : Model {			if (_instance == null) {				_allowInstantiation = true;				_instance = new Model();				_allowInstantiation = false;			}			return _instance;		}		public function Model() : void {			if (!_allowInstantiation) {				throw new Error("Error: Instantiation failed: Use Model.getInstance() instead of new.");			}		}		/**		 * clear the model (data)		 */		public function clearModel() : void {			_data = null;		}				/**		 * 		 */		public function updateView( event : String ) : void {			// If no events defined yet, then send out the first event.			if( _event.length == 0 ) {				_event = event;				dispatchEvent(new Event(event));			} else {				// Run the event to destroy the current event.				dispatchEvent(new Event(( _event + Model.CLEAR )));								// Then send out the new event and make that the current event.				_event = event;			}			// Send out an all events request.			dispatchEvent(new Event(Model.ALL_EVENTS));		}		/**		 * @example		Model.getInstance().showDefaultView();		 * 		 * first View initiated will be the default view		 */		public function showDefaultView() : void {
			updateView(viewNameArray[0]);
		}
		/**		 * no show our hides are used here, just for the views who listen to this command		 * on hide, it will be automatically triggered		 */		public function sendInternalEvent( event : String ) : void {			dispatchEvent(new Event(event));		}		//////////////////////////////////////// getter/setter ////////////////////////////////////////	
		public function get data() : * {			return _data;		}		public function set data( data : * ) : void {			_data = data;		}		public function get currentEvent() : String {			return _event;		}
		public function get viewNameArray() : Array {
			return _viewNameArray;
		}
		public function set viewNameArray(inViewName : *) : void {
			_viewNameArray.push(inViewName);
		}
		//////////////////////////////////////// remove ////////////////////////////////////////	
				/**		 * little hack to remove the automatic add from every view		 */		public function removeViewNameFromArray() : void {
			// only when you init a view, and you don't want it managed by the model, 			// call this function to remove it from the show/hide list
			_viewNameArray.pop();
		}
	}}