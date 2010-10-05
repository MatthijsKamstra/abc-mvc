package mvc.core {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Model extends EventDispatcher {
		// singleton stuff
		private static var _instance : Model;
		private static var _allowInstantiation : Boolean;
		// events
		public static const ALL_EVENTS : String = "onAllEvents";
		public static const CLEAR : String = "_destroy";
		// vars
		private var _data : * = null;
		private var _event : String = "";
		private var _viewNameArray : Array = [];
		private var _popupNameArray : Array = [];
		private var _xml : XML;

		// singleton
		public static function getInstance() : Model {
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new Model();
				_allowInstantiation = false;
			}
			return _instance;
		}

		public function Model() : void {
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use Model.getInstance() instead of new.");
			}
		}

		/**
		public function clearModel() : void {
			_data = null;
		}

		/**
		public function updateView(event : String) : void {
			// If no events defined yet, then send out the first event.
			if( _event.length == 0 ) {
				_event = event;
				dispatchEvent(new Event(event));
			} else {
				// Run the event to destroy the current event.
				dispatchEvent(new Event(( _event + Model.CLEAR )));
				// Then send out the new event and make that the current event.
				_event = event;
			}
			// Send out an all events request.
			dispatchEvent(new Event(Model.ALL_EVENTS));
		}

		/**
		public function showDefaultView() : void {
			updateView(viewNameArray[0]);
		}

		/**
		public function sendInternalEvent(event : String) : void {
			dispatchEvent(new Event(event));
		}

		/**
		private function typeData(inData : *) : void {
			var _type : String = typeof (inData);
			switch (_type) {
				case 'xml':
					_xml = inData as XML;
					break;
				case 'string':
					trace('--- string');
					break;
				case 'object':
					trace('--- object / array');
					break;
				case 'number':
					trace('--- number / int');
					break;
				default:
					trace("case '" + _type + "':\r\ttrace ('--- " + _type + "');\r\tbreak;");
			}
		}

		// ////////////////////////////////////// getter/setter // //////////////////////////////////////
		/**
		public function get data() : * {
			return _data;
		}

		/**
		public function set data(data : *) : void {
			_data = data;
			typeData(_data);
		}

		public function get currentEvent() : String {
			return _event;
		}

		public function get viewNameArray() : Array {
			return _viewNameArray;
		}

		public function set viewNameArray(inViewName : *) : void {
			_viewNameArray.push(inViewName);
		}

		public function get popupNameArray() : Array {
			return _popupNameArray;
		}

		public function set popupNameArray(inPopupName : *) : void {
			_popupNameArray.push(inPopupName);
		}

		/**
		 */
		public function get xml() : XML {
			var __xml : XML = _xml;
			if (__xml == null)
				__xml = null;
			return __xml;
		}

		/**
		public function outputViewNamePackage() : void {
			trace("package nl.xxx.yyy.data.enum {" + "/**" + "* @author Matthijs Kamstra aka [mck]" + "*/" + "public class ViewNames {");
			var array : Array = Model.getInstance().viewNameArray;
			for (var i : int = 0; i < array.length; i++) {
				var name : String = array[i];
				trace("static public const " + name.toUpperCase() + ":String = '" + name + "';");
			}
			trace("}" + "}");
		}

		// ////////////////////////////////////// remove // //////////////////////////////////////	
		/**
		public function removeViewNameFromArray() : void {
			// only when you init a view, and you don't want it managed by the model,
			// call this function to remove it from the show/hide list
			_viewNameArray.pop();
		}
	}
}